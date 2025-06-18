// sendMessage controller
const messageModel = require("../Models/message");
const { messageSchema } = require("../Schemas/message");
const {
  sendMessageToCircle,
  sendMessageToChatList,
} = require("../Socket/socketMethods");
const circleModel = require("../Models/circle");
const convosModel = require("../Models/convos");

/**
 *@description Send a message to a circle
 *@route POST /api/messenger/send
 *@access Private
 */

module.exports.sendMessage = async (req, res) => {
  try {
    const { error } = messageSchema.validate(req.body);
    if (error) {
      return res.status(400).json({ message: error.details[0].message });
    }

    const sender = req.user._id;
    const { circleId } = req.body;

    // Check if the circle exists
    const circle = await circleModel.findById(circleId);
    if (!circle) {
      return res.status(404).json({ message: "Circle not found" });
    }

    //check if the user is the member of the circle
    if (!circle.members.includes(sender)) {
      return res.status(403).json({
        message: "You are not authorized to send message to this circle",
      });
    }

    const message = new messageModel({ ...req.body, sender });
    const savedMessage = await message.save();

    // Emit the message to the circle
    handleNewMessage(circleId, savedMessage);

    res
      .status(201)
      .json({ message: "Message sent successfully", data: savedMessage });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

/**
 * @description Get all messages in a circle
 * @route GET /api/messenger/get/:circleId
 * @access Private
 */

module.exports.getMessages = async (req, res) => {
  try {
    const { circleId } = req.params;

    const circle = await circleModel.findById(circleId);
    if (!circle) {
      return res.status(404).json({ message: "Circle not found" });
    }

    if (!circle.members.includes(req.user._id)) {
      return res.status(403).json({
        message: "You are not authorized to view messages in this circle",
      });
    }

    const messages = await messageModel
      .find({ circleId: circleId })
      .populate("sender", "name profilePicture _id")
      .populate({
        path: "offerId",
        select:
          "title description numberOfPeople startingDate endingDate interest price imageUrls active createdAt",
      })
      .populate(
        "planId",
        "name description date location eventType members budget createdBy"
      )
      .populate({
        path: "planId",
        populate: {
          path: "eventType",
          select: "name color",
        },
      })
      .populate({
        path: "planId",
        populate: {
          path: "members",
          select: "name profilePicture",
        },
      })
      .populate({
        path: "planId",
        populate: {
          path: "createdBy",
          select: "name profilePicture",
        },
      })
      .populate({
        path: "itineraryId",
        select: "name about date time",
      })
      .sort({ createdAt: -1 })
      .exec();

    const result = messages.reverse().map((message) => {
      const messageData = {
        id: message._id,
        type: message.type,
        senderId: message.sender?._id,
        text: message.message,
        senderName: message.sender?.name,
        senderProfilePicture: message.sender?.profilePicture,
        sentAt: message.createdAt,
        pinned: message.pinned ?? false,
        media: (message.media || []).map((m) => ({
          type: m?.type || "",
          url: m?.url || "",
          mimetype: m?.mimetype || "",
        })),
      };

      if (message.type === "offer") {
        messageData.offerDetails = {
          _id: message.offerId?._id || "",
          title: message.offerId?.title || "",
          description: message.offerId?.description || "",
          numberOfPeople: message.offerId?.numberOfPeople || 0,
          startingDate: message.offerId?.startingDate || null,
          endingDate: message.offerId?.endingDate || null,
          interest: message.offerId?.interest || "",
          price: message.offerId?.price || 0,
          imageUrls: message.offerId?.imageUrls || [],
          active: message.offerId?.active ?? false,
          createdAt: message.offerId?.createdAt || null,
        };
      }

      if (message.type === "plan" && message.planId) {
        messageData.planDetails = {
          planId: message.planId?._id || "",
          planName: message.planId?.name,
          description: message.planId?.description,
          date: message.planId?.date,
          location: message.planId?.location,
          eventType: {
            eventId: message.planId?.eventType?._id || "",
            name: message.planId?.eventType?.name || "",
            color: message.planId?.eventType?.color || "",
          },
          members: (message.planId?.members || []).map((member) => ({
            memberId: member?._id,
            name: member?.name,
            profilePicture: member?.profilePicture,
          })),
          budget: message.planId?.budget,
          createdBy: {
            id: message.planId?.createdBy?._id,
            name: message.planId?.createdBy?.name,
            profilePicture: message.planId?.createdBy?.profilePicture,
          },
        };
      }

      if (message.type === "itinerary" && message.itineraryId) {
        messageData.itineraryDetails = {
          itineraryId: message.itineraryId?._id || "",
          name: message.itineraryId?.name,
          about: message.itineraryId?.about,
          date: message.itineraryId?.date,
          time: message.itineraryId?.time,
        };
      }

      return messageData;
    });

    res.status(200).json({
      success: true,
      data: result,
      circleId: circleId,
    });
  } catch (error) {
    console.error("Failed to retrieve messages:", error);
    res.status(500).json({
      success: false,
      message: "Failed to retrieve messages",
    });
  }
};
module.exports.pinMessage = async (req, res) => {
  try {
    const { messageIds, circleId } = req.body;

    // Find the messages by IDs
    const messages = await messageModel.find({ _id: { $in: messageIds } });

    // If no messages exist, return an error
    if (!messages.length) {
      return res.status(404).json({ message: "Messages not found" });
    }

    // Check if the circle exists
    const circle = await circleModel.findById(circleId);
    if (!circle) {
      return res.status(404).json({ message: "Circle not found" });
    }

    // Check if the user is a member of the circle
    if (!circle.members.includes(req.user._id)) {
      return res.status(403).json({
        message: "You are not authorized to pin messages in this circle",
      });
    }

    // Update the pinned field of all messages
    const updatedMessages = await Promise.all(
      messages.map(async (message) => {
        return await messageModel.findByIdAndUpdate(
          message._id,
          { pinned: !message.pinned },
          { new: true }
        );
      })
    );

    // Update canvas with pinned messages
    for (const message of updatedMessages) {
      if (message.pinned) {
        // Add to canvas if newly pinned
        const convos = await convosModel.findOne({ circleId: circleId });
        if (!convos) {
          await convosModel.create({
            circleId,
            pinnedMessages: [message._id],
          });
        } else {
          await convosModel.findOneAndUpdate(
            { circleId: circleId },
            { $addToSet: { pinnedMessages: message._id } },
            { new: true }
          );
        }
      } else {
        // Remove from canvas if unpinned
        await convosModel.findOneAndUpdate(
          { circleId: circleId },
          { $pull: { pinnedMessages: message._id } },
          { new: true }
        );
      }
    }

    // Return a success response with the updated messages
    res.status(200).json({
      success: true,
      message: "Messages pinned successfully",
    });
  } catch (error) {
    console.error("Failed to pin the messages:", error);
    res.status(500).json({
      success: false,
      message: "Failed to pin the messages",
    });
  }
};

/**
 * @description get the conversations of a user (all circles)
 * @route GET /api/messenger/conversations
 * @access Private
 */

module.exports.getConversations = async (req, res) => {
  try {
    const userId = req.user._id;

    // Find all circles where the user is a member
    const circles = await circleModel.find({ members: userId });

    // Get the latest message in each circle
    const conversations = await Promise.all(
      circles.map(async (circle) => {
        const latestMessage = await messageModel
          .findOne({ circleId: circle._id })
          .sort({ createdAt: -1 })
          .populate({
            path: "sender",
            select: "name profilePicture _id",
          })
          .exec();

        return {
          circleId: circle._id,
          circleName: circle.circleName,
          circleImage: circle.circleImage,
          latestMessage: latestMessage
            ? {
                senderId: latestMessage.sender._id,
                senderName: latestMessage.sender.name,
                senderProfilePicture: latestMessage.sender.profilePicture,
                text: latestMessage.message,
                sentAt: latestMessage.createdAt,
              }
            : null,
        };
      })
    );

    res.status(200).json({
      success: true,
      data: conversations,
    });
  } catch (error) {
    console.error("Failed to retrieve conversations:", error);
    res.status(500).json({
      success: false,
      message: "Failed to retrieve conversations",
    });
  }
};

module.exports.getPinnedMessages = async (req, res) => {
  try {
    const { circleId } = req.params;

    const circle = await circleModel.findById(circleId);
    if (!circle) {
      return res.status(404).json({ message: "Circle not found" });
    }

    if (!circle.members.includes(req.user._id)) {
      return res.status(403).json({
        message: "You are not authorized to view messages in this circle",
      });
    }

    const convos = await convosModel
      .findOne({ circleId })
      .populate({
        path: "pinnedMessages",
        populate: [
          {
            path: "sender",
            select: "name profilePicture _id",
          },
          {
            path: "offerId",
            select:
              "title description numberOfPeople startingDate endingDate interest price imageUrls active createdAt",
          },
          {
            path: "planId",
            populate: [
              { path: "eventType", select: "name color" },
              { path: "members", select: "name profilePicture _id" },
              { path: "createdBy", select: "name profilePicture" },
            ],
          },
          {
            path: "itineraryId",
            select: "name about date time",
          },
        ],
      })
      .sort({ "pinnedMessages.createdAt": -1 })
      .exec();

    const result = convos
      ? convos.pinnedMessages.reverse().map((message) => {
          const messageData = {
            id: message._id,
            type: message.type,
            senderId: message.sender._id,
            text: message.message,
            senderName: message.sender.name,
            senderProfilePicture: message.sender.profilePicture,
            sentAt: message.createdAt,
            pinned: true,
            media: message.media.map((m) => ({
              type: m.type,
              url: m.url,
              mimetype: m.mimetype,
            })),
          };

          if (message.type === "offer") {
            messageData.offerDetails = {
              _id: message.offerId?._id || "",
              title: message.offerId?.title || "",
              description: message.offerId?.description || "",
              numberOfPeople: message.offerId?.numberOfPeople || 0,
              startingDate: message.offerId?.startingDate || null,
              endingDate: message.offerId?.endingDate || null,
              interest: message.offerId?.interest || "",
              price: message.offerId?.price || 0,
              imageUrls: message.offerId?.imageUrls || [],
              active: message.offerId?.active ?? false,
              createdAt: message.offerId?.createdAt || null,
            };
          }

          if (message.type === "plan" && message.planId) {
            messageData.planDetails = {
              planId: message.planId?._id || "",
              planName: message.planId?.name,
              description: message.planId?.description,
              date: message.planId?.date,
              location: message.planId?.location,
              eventType: {
                eventId: message.planId?.eventType?._id || "",
                name: message.planId?.eventType?.name || "",
                color: message.planId?.eventType?.color || "",
              },
              members: (message.planId?.members || []).map((member) => ({
                memberId: member?._id,
                name: member?.name,
                profilePicture: member?.profilePicture,
              })),
              budget: message.planId?.budget,
              createdBy: {
                id: message.planId?.createdBy?._id || "",
                name: message.planId?.createdBy?.name,
                profilePicture: message.planId?.createdBy?.profilePicture,
              },
            };
          }

          if (message.type === "itinerary" && message.itineraryId) {
            messageData.itineraryDetails = {
              itineraryId: message.itineraryId?._id || "",
              name: message.itineraryId?.name,
              about: message.itineraryId?.about,
              date: message.itineraryId?.date,
              time: message.itineraryId?.time,
            };
          }

          return messageData;
        })
      : [];

    res.status(200).json({
      success: true,
      data: result,
      circleId: circleId,
    });
  } catch (error) {
    console.error("Failed to retrieve pinned messages:", error);
    res.status(500).json({
      success: false,
      message: "Failed to retrieve pinned messages",
    });
  }
};

const handleNewMessage = async (circleId, messageData) => {
  const message = await messageModel.create(messageData);

  // Prepare the last message summary for chat list
  let lastMessageData;
  if (message.type === "text") {
    lastMessageData = {
      message: message.message,
      type: "text",
      time: message.createdAt,
    };
  } else if (
    message.type === "offer" ||
    message.type === "plan" ||
    message.type === "itinerary"
  ) {
    lastMessageData = {
      message: message.type, // Show type in chat list
      type: message.type,
      time: message.createdAt,
    };
  } else {
    lastMessageData = {
      message: message.type, // Show type in chat list
      type: message.type,
      time: message.createdAt,
    };
  }

  // Emit new message for chat list
  sendMessageToChatList(circleId, lastMessageData);

  // Prepare message for chat details
  const messageInDetail = {
    circleId,
    message:
      message.type === "text"
        ? message.message
        : message.type === "offer"
        ? message.offerId
        : message.type === "plan"
        ? message.planId
        : message.type === "itinerary"
        ? message.itineraryId
        : message.media && message.media.length > 0
        ? message.media[0].url
        : "", // Fallback to null if media is empty or not available
    type: message.type,
    time: message.createdAt,
  };

  // Emit new message for chat details
  sendMessageToCircle(circleId, messageInDetail);
};

module.exports.shareToMultipleCircles = async (req, res) => {
  try {
    const sender = req.user._id;
    const { circleIds, type, offerId, planId, itineraryId } = req.body;

    if (!Array.isArray(circleIds) || circleIds.length === 0) {
      return res
        .status(400)
        .json({ message: "Circle IDs must be a non-empty array" });
    }

    if (!["text", "offer", "plan", "itinerary"].includes(type)) {
      return res.status(400).json({
        message:
          "Message type must be either 'text', 'offer', 'plan', or 'itinerary'",
      });
    }

    if (type === "offer" && !offerId) {
      return res
        .status(400)
        .json({ message: "offerId is required for offer type" });
    }

    if (type === "plan" && !planId) {
      return res
        .status(400)
        .json({ message: "planId is required for plan type" });
    }

    if (type === "itinerary" && !itineraryId) {
      return res
        .status(400)
        .json({ message: "itineraryId is required for itinerary type" });
    }

    // Check if all circles exist and user is member of each
    const circles = await circleModel.find({ _id: { $in: circleIds } });
    if (circles.length !== circleIds.length) {
      return res.status(404).json({ message: "One or more circles not found" });
    }

    const unauthorizedCircles = circles.filter(
      (circle) => !circle.members.includes(sender)
    );
    if (unauthorizedCircles.length > 0) {
      return res.status(403).json({
        message:
          "You are not authorized to send messages to one or more circles",
      });
    }

    // Create and save messages for each circle
    const savedMessages = await Promise.all(
      circleIds.map(async (circleId) => {
        const message = new messageModel({
          type,
          offerId,
          planId,
          itineraryId,
          circleId: circleId,
          sender,
        });
        const savedMessage = await message.save();

        // Emit the message to each circle
        handleNewMessage(circleId, savedMessage);

        return savedMessage;
      })
    );

    res.status(201).json({
      message: "Messages sent successfully to all circles",
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
