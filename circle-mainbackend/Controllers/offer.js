const Offer = require("../Models/offer");
const User = require("../Models/user");
const Circle = require("../Models/circle");
const savedOffer = require("../Models/savedOfferModel");
const {
  sendOfferToCircle,
  sendOfferToChatList,
} = require("../Socket/socketMethods");
const Message = require("../Models/message");
const mongoose = require("mongoose");
const {
  sendEmail,
  success,
  successWithData,
  error,
  generateOTP,
} = require("../Utils/commonMethods"); // Import response methods

// API to buy an offer
module.exports.buyOffer = async (req, res) => {
  try {
    const { offerId } = req.body;
    const userId = req.user._id;
    // Validate input
    if (!offerId || !userId) {
      return res
        .status(400)
        .json(error("Both 'offerId' and 'userId' are required"));
    }

    // Check if the offer exists
    const offer = await Offer.findById(offerId);
    if (!offer) {
      return res.status(404).json(error("Offer not found"));
    }

    // Check if the user exists
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json(error("User not found"));
    }

    // Check if the user already bought the offer
    if (offer.buyers.includes(userId)) {
      return res.status(400).json(error("You have already bought this offer"));
    }

    if (offer.buyersCount > offer.buyers.length) {
      return res.status(400).json(error("Offer sold out"));
    }

    // Update the offer using findOneAndUpdate
    const updatedOffer = await Offer.findOneAndUpdate(
      { _id: offerId },
      {
        $push: { buyers: userId },
        $inc: { buyersCount: 1 },
      },
      { new: true }
    );
    //todo: need to integrate payment system here

    console.log(`User ${userId} bought offer ${offerId}`);
    return res.status(200).json(success("Offer bought successfully"));
  } catch (err) {
    console.error("Error buying offer:", err);
    return res
      .status(500)
      .json(error("An error occurred while buying the offer"));
  }
};
module.exports.getOffersByInterest = async (req, res) => {
  try {
    const { interest } = req.params;

    // Validate input
    if (!interest) {
      return res.status(400).json(error("Interest parameter is required"));
    }

    let query = { active: true };

    // If interest is not 'all', add interest filter
    if (interest.toLowerCase() !== "all") {
      query.interest = { $regex: new RegExp(`^${interest.trim()}`, "i") };
    }

    // Fetch offers matching the given interest
    const offers = await Offer.find(query);

    // Return an empty array if no offers are found
    if (offers.length === 0) {
      return res.status(200).json(
        successWithData("No offers found for the specified interest", {
          offers: [],
        })
      );
    }

    return res
      .status(200)
      .json(successWithData("Offers retrieved successfully", { offers }));
  } catch (err) {
    console.error("Error fetching offers by interest:", err);
    return res
      .status(500)
      .json(error("An error occurred while fetching offers"));
  }
};

module.exports.getAllOffers = async (req, res) => {
  try {
    // Fetch all offers
    const offers = await Offer.find({});

    // Return an empty array if no offers are found
    if (offers.length === 0) {
      return res
        .status(200)
        .json(successWithData("No offers found", { offers: [] }));
    }

    return res
      .status(200)
      .json(successWithData("All offers retrieved successfully", { offers }));
  } catch (err) {
    console.error("Error fetching all offers:", err);
    return res
      .status(500)
      .json(error("An error occurred while fetching all offers"));
  }
};

module.exports.sendOffer = async (req, res) => {
  try {
    const { circleId, offerId } = req.body;
    const sender = req.user._id;

    // Check if the circle exists
    const circle = await Circle.findById(circleId);
    if (!circle) {
      return res.status(404).json({ message: "Circle not found" });
    }

    // Check if the user is a member of the circle
    if (!circle.members.includes(sender)) {
      return res.status(403).json({
        message: "You are not authorized to send offers to this circle",
      });
    }

    // Check if the offer exists
    const offer = await Offer.findById(offerId);
    if (!offer) {
      return res.status(404).json({ message: "Offer not found" });
    }

    // Create the offer message to send to the circle
    const newMessage = new Message({
      type: "offer", // Message type is 'offer'
      sender, // Sender is the user sending the offer
      circleId, // Circle to which the offer is sent
      offerDetails: {
        _id: offer._id,
        title: offer.title,
        description: offer.description,
        numberOfPeople: offer.numberOfPeople,
        startingDate: offer.startingDate,
        endingDate: offer.endingDate,
        interest: offer.interest,
        price: offer.price,
        imageUrls: offer.imageUrls,
        active: offer.active,
        buyers: offer.buyers,
        createdAt: offer.createdAt,
        __v: 0,
      },
    });

    // Save the message to the database
    const savedMessage = await newMessage.save();

    // Emit the offer message to the circle (e.g., via socket)
    sendOfferToCircle(circleId, savedMessage);

    res
      .status(201)
      .json({ message: "Offer sent successfully", data: savedMessage });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

//save unsave an offer
exports.toggleSaveOffer = async (req, res) => {
  try {
    const { offerId } = req.params;
    const userId = req.user._id;

    // Validate ObjectIds
    if (
      !mongoose.Types.ObjectId.isValid(userId) ||
      !mongoose.Types.ObjectId.isValid(offerId)
    ) {
      return res.status(400).json({ message: "Invalid userId or offerId" });
    }

    // Check if offer exists
    const offer = await Offer.findById(offerId);
    if (!offer) {
      return res.status(404).json({ message: "Offer not found" });
    }

    // Check if the offer is already saved
    const existingSave = await savedOffer.findOne({ userId, offerId });

    if (existingSave) {
      // If offer is already saved, remove it (unsave)
      await savedOffer.findByIdAndDelete(existingSave._id);
      return res.status(200).json({
        message: "Offer unsaved successfully",
        saved: false,
      });
    } else {
      // If offer is not saved, save it
      const newSavedOffer = new savedOffer({
        userId,
        offerId,
      });
      await newSavedOffer.save();
      return res.status(201).json({
        message: "Offer saved successfully",
        saved: true,
      });
    }
  } catch (error) {
    // Handle duplicate key error
    if (error.code === 11000) {
      return res.status(400).json({ message: "Offer already saved" });
    }
    return res.status(500).json({ message: error.message });
  }
};

// Fetch booked and saved offers
exports.fetchExperienceDetails = async (req, res) => {
  try {
    const userId = req.user.id; // Assuming user ID is available in `req.user`

    // Fetch booked offers where the user is in the `buyers` array
    const bookedOffersPromise = Offer.find({ buyers: userId })
      .select("-buyers") // Exclude buyers list from response (optional)
      .sort({ startingDate: 1 }) // Sort offers by starting date
      .lean(); // Return plain JavaScript objects

    // Fetch saved offers by joining with the Offer model
    const savedOffersPromise = savedOffer
      .find({ userId })
      .populate("offerId", "-buyers") // Populate offer details, excluding buyers
      .sort({ savedAt: -1 }) // Sort by savedAt in descending order (latest first)
      .lean();

    // Wait for both queries to complete
    const [bookedOffers, savedOffers] = await Promise.all([
      bookedOffersPromise,
      savedOffersPromise,
    ]);

    // Map booked offers to include only the required fields
    const formattedBookedOffers = bookedOffers.map((offer) => ({
      _id: offer._id || "",
      title: offer.title || "",
      description: offer.description || "",
      numberOfPeople: offer.numberOfPeople || "",
      startingDate: offer.startingDate || "",
      endingDate: offer.endingDate || "",
      interest: offer.interest || "",
      price: offer.price || "",
      imageUrls: offer.imageUrls || "",
      active: offer.active || false,
      createdAt: offer.createdAt || "",
    }));

    // Map saved offers to include only the required fields
    const formattedSavedOffers = savedOffers.map((saved) => ({
      _id: saved.offerId?._id || "",
      title: saved.offerId?.title || "",
      description: saved.offerId?.description || "",
      numberOfPeople: saved.offerId?.numberOfPeople || "",
      startingDate: saved.offerId?.startingDate || "",
      endingDate: saved.offerId?.endingDate || "",
      interest: saved.offerId?.interest || "",
      price: saved.offerId?.price || "",
      imageUrls: saved.offerId?.imageUrls || "",
      active: saved.offerId?.active || false,
      createdAt: saved.offerId?.createdAt || "",
    }));

    // Combine results and respond
    res.status(200).json({
      success: true,
      message: "Offers fetched successfully",
      data: {
        bookedOffers: formattedBookedOffers,
        savedOffers: formattedSavedOffers,
      },
    });
  } catch (error) {
    console.error("Error fetching offers:", error);
    res.status(500).json({
      success: false,
      message: "An error occurred while fetching offers",
    });
  }
};
