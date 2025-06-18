const bcrypt = require('bcrypt');
const Admin = require('../Models/admin');
const { sendEmail, success, successWithData, error, generateOTP } = require('../Utils/commonMethods');
const generateToken = require('../Utils/generateToken');
const Offer = require('../Models/offer');
const Circle = require('../Models/circle');
const Message = require('../Models/message');
const savedOffer = require('../Models/savedOfferModel');
// Admin login endpoint
module.exports.adminLogin = async (req, res) => {
  try {
    const { email, password } = req.body;
    const admin = await Admin.findOne({ email });

    if (!admin) {
      return res.status(404).json(error("Admin not found"));
    }

    const isMatch = await bcrypt.compare(password, admin.password);
    if (!isMatch) {
      return res.status(401).json(error("Invalid credentials"));
    }

    const token = generateToken(admin._id);

    return res.status(200).json(successWithData("Login successful", { token }));
  } catch (err) {
    console.error(err);
    return res.status(500).json(error("An error occurred during login"));
  }
};

// Admin forgot password endpoint
module.exports.adminForgotPassword = async (req, res) => {
  try {
    const { email } = req.body;
    const admin = await Admin.findOne({ email });

    if (!admin) {
      return res.status(404).json(error("Admin not found"));
    }

    const otp = generateOTP();
    admin.resetPasswordOtp = otp;
    admin.resetPasswordExpires = Date.now() + 3600000; // 1 hour
    await admin.save();

    // Send OTP via email
    const emailSent = await sendEmail(email, "Your OTP Code", `Your OTP code is ${otp}`);
    if (!emailSent) {
      return res.status(500).json(error("Failed to send OTP email"));
    }

    return res.status(200).json(success("OTP sent to your email"));
  } catch (err) {
    console.error(err);
    return res.status(500).json(error("An error occurred while processing your request"));
  }
};

// Admin verify OTP endpoint
module.exports.adminVerifyOtp = async (req, res) => {
  try {
    const { email, otp } = req.body;
    const admin = await Admin.findOne({
      email,
      resetPasswordOtp: otp,
      resetPasswordExpires: { $gt: Date.now() }
    });

    if (!admin) {
      return res.status(400).json(error("Invalid or expired OTP"));
    }

    // Mark OTP as verified (set a flag or use a session if needed)
    admin.resetPasswordVerified = true;
    await admin.save();

    return res.status(200).json(success("OTP verification successful"));
  } catch (err) {
    console.error(err);
    return res.status(500).json(error("An error occurred while verifying the OTP"));
  }
};

// Admin reset password endpoint
module.exports.adminResetPassword = async (req, res) => {
  try {
    const { email, newPassword, confirmPassword } = req.body;

    if (newPassword !== confirmPassword) {
      return res.status(400).json(error("Passwords do not match"));
    }

    const admin = await Admin.findOne({ email });

    if (!admin) {
      return res.status(404).json(error("Admin not found"));
    }

    // Ensure OTP was verified
    if (!admin.resetPasswordVerified) {
      return res.status(400).json(error("OTP verification required"));
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    admin.password = hashedPassword;

    // Clear reset flags
    admin.resetPasswordOtp = undefined;
    admin.resetPasswordExpires = undefined;
    admin.resetPasswordVerified = false;
    await admin.save();

    return res.status(200).json(success("Password reset successful"));
  } catch (err) {
    console.error(err);
    return res.status(500).json(error("An error occurred while resetting the password"));
  }
};


module.exports.createOffer = async (req, res) => {
  try {
    const {
      title,
      description,
      numberOfPeople,
      startingDate,
      endingDate,
      interest,
      price,
      imageUrls
    } = req.body;

    // Validation for numberOfPeople
    if (numberOfPeople < 1) {
      return res.status(400).json(error("Number of people must be at least 1"));
    }

    // Validation for startingDate and endingDate
    const currentDate = new Date();
    if (new Date(startingDate) < currentDate) {
      return res.status(400).json(error("Starting date cannot be in the past"));
    }
    if (new Date(endingDate) < new Date(startingDate)) {
      return res.status(400).json(error("Ending date cannot be before the starting date"));
    }

    // Create a new offer instance
    const newOffer = new Offer({
      title,
      description,
      numberOfPeople,
      startingDate,
      endingDate,
      interest,
      price,
      imageUrls
    });

    await newOffer.save();

    // Structure the clean offer data explicitly
    const offerData = {
      title: newOffer.title,
      description: newOffer.description,
      numberOfPeople: newOffer.numberOfPeople,
      startingDate: newOffer.startingDate,
      endingDate: newOffer.endingDate,
      interest: newOffer.interest,
      price: newOffer.price,
      imageUrls: newOffer.imageUrls,
      _id: newOffer._id,
      createdAt: newOffer.createdAt,
      __v: newOffer.__v
    };

    return res.status(201).json(successWithData("Offer created successfully", { offer: offerData }));
  } catch (err) {
    console.error(err);
    return res.status(500).json(error("An error occurred while creating the offer"));
  }
};

// Get offers by active status (true or false)
module.exports.getOffersByStatus = async (req, res) => {
  try {
    // Get the 'active' parameter from the query string
    const { active } = req.query;

    // Ensure the 'active' parameter is either true or false
    if (active !== 'true' && active !== 'false') {
      return res.status(400).json(error("Invalid 'active' parameter. It should be 'true' or 'false'."));
    }

    // Convert the active parameter to a boolean
    const isActive = active === 'true';

    console.log(`Fetching offers with active status: ${isActive}`);

    // Fetch offers based on the active status and populate buyers field with user info (name, profilePicture)
    const offers = await Offer.find({ active: isActive })
      .populate('buyers', 'name profilePicture'); // Populate the buyers array with name and profilePicture from the User model

    if (offers.length === 0) {
      console.log("No offers found with the given status");
      return res.status(404).json(error(`No ${isActive ? 'active' : 'inactive'} offers found`));
    }

    // Prepare the offers data to include numberOfPeople and buyers details
    const offersWithDetails = offers.map(offer => ({
        _id: offer._id,
        title: offer.title,
        description: offer.description,
        price: offer.price,
        startingDate: offer.startingDate,
        endingDate: offer.endingDate,
        interest: offer.interest,
        numberOfBuyers: offer.buyers.length,
        imageUrls: offer.imageUrls,
        buyers: offer.buyers.map(buyer => ({
          id: buyer._id,
          name: buyer.name,
          profilePicture: buyer.profilePicture
        })),
        active: offer.active,
        createdAt: offer.createdAt
    }));

    console.log(`Found ${offers.length} ${isActive ? 'active' : 'inactive'} offers`);
    return res.status(200).json(successWithData(`${isActive ? 'Active' : 'Inactive'} offers fetched successfully`, { offers: offersWithDetails }));
  } catch (err) {
    console.error("Error fetching offers:", err);
    return res.status(500).json(error("An error occurred while fetching offers"));
  }
};


module.exports.getInterestStats = async (req, res) => {
  try {
      // Extract query parameters for pagination
      const { itemsPerPage, currentPage } = req.query;

      // Validate pagination parameters
      if (isNaN(itemsPerPage) || itemsPerPage <= 0) {
          return res.status(400).json(error("'itemsPerPage' must be a positive number."));
      }
      if (isNaN(currentPage) || currentPage <= 0) {
          return res.status(400).json(error("'currentPage' must be a positive number."));
      }

      // Fetch all circles and populate members and events
      const circles = await Circle.find({}).populate('members', '_id').populate('events', '_id');

      const interestMap = {}; // Object to store interest details
      const interestCircleIds = {}; // Store circle IDs for each interest

      circles.forEach(circle => {
          circle.circle_interests.forEach(interest => {
              if (!interestMap[interest]) {
                  interestMap[interest] = {
                      count: 0,
                      totalMembers: 0,
                      totalEvents: 0,
                      totalMessages: 0,  // Initialize message counter
                  };
                  interestCircleIds[interest] = []; // Initialize interest-specific circle IDs
              }
              interestMap[interest].count += 1; // Increment circle count for this interest
              interestMap[interest].totalMembers += circle.members.length; // Sum members for average
              interestMap[interest].totalEvents += circle.events.length; // Sum events

              // Collect circle IDs for this interest
              interestCircleIds[interest].push(circle._id);
          });
      });

      // Fetch and count messages for each interest's circles
      for (const [interest, circleIds] of Object.entries(interestCircleIds)) {
          const messageCount = await Message.countDocuments({ circleId: { $in: circleIds } });
          interestMap[interest].totalMessages = messageCount;
      }

      // Prepare the final response
      const interestStats = Object.entries(interestMap).map(([interest, data]) => ({
          interest,
          groupCount: data.count,
          eventCount: data.totalEvents,
          averageGroupSize: (data.totalMembers / data.count).toFixed(0),
          messageCount: data.totalMessages, // Include total message count
      }));

      // Pagination logic
      const totalItems = interestStats.length;
      const totalPages = Math.ceil(totalItems / itemsPerPage);  // Total number of pages

      // Check if currentPage is greater than totalPages
      if (currentPage > totalPages) {
          return res.status(400).json({
              status: 'error',
              message: `Requested page exceeds total pages (${totalPages})`
          });
      }

      // Adjust startIndex based on the requested currentPage
      const startIndex = (currentPage - 1) * itemsPerPage;
      const endIndex = startIndex + itemsPerPage;

      // If startIndex exceeds totalItems, return an empty result
      if (startIndex >= totalItems) {
          return res.status(200).json({
              status: 'success',
              message: 'Interest statistics fetched successfully',
              data: {
                  interests: [],
                  currentPage: currentPage,
                  totalPages: totalPages,
              }
          });
      }

      // Slice the array to get the paginated interests
      const paginatedInterests = interestStats.slice(startIndex, endIndex);

      // Return the paginated response with total pages
      return res.status(200).json({
          status: 'success',
          message: 'Interest statistics fetched successfully',
          data: {
              interests: paginatedInterests,
              currentPage: currentPage,
              totalPages: totalPages,
          }
      });
  } catch (err) {
      console.error("Error fetching interest statistics:", err);
      return res.status(500).json(error("An error occurred while fetching interest statistics"));
  }
};


module.exports.getTypeStats = async (req, res) => {
  try {
    // Extract query parameters for active days, range, minimum messages, pagination
    const { activeDays, dayRange, minMessages, itemsPerPage, currentPage} = req.query;

    // Validate pagination parameters
    if (isNaN(itemsPerPage) || itemsPerPage <= 0) {
      return res.status(400).json(error("'itemsPerPage' must be a positive number."));
    }
    if (isNaN(currentPage) || currentPage <= 0) {
      return res.status(400).json(error("'currentPage' must be a positive number."));
    }

    // Validate required parameters
    if (!activeDays || !dayRange || !minMessages) {
      return res.status(400).json(error("Missing required parameters. Please provide 'activeDays', 'dayRange', and 'minMessages'."));
    }

    // Validate that activeDays, dayRange, and minMessages are numbers
    if (isNaN(activeDays)) {
      return res.status(400).json(error("'activeDays' must be a valid number. This is the number of days the user should be active."));
    }

    if (isNaN(dayRange)) {
      return res.status(400).json(error("'dayRange' must be a valid number. This is the range of days (from today) within which the user activity is being checked."));
    }

    if (isNaN(minMessages)) {
      return res.status(400).json(error("'minMessages' must be a valid number. This is the minimum number of messages a user must send on any given day to be considered active."));
    }

    // Validate that dayRange > activeDays
    if (Number(dayRange) <= Number(activeDays)) {
      return res.status(400).json(error("'dayRange' must be greater than 'activeDays'. 'dayRange' defines the window within which activity is tracked, and must be larger than the 'activeDays' period."));
    }

    // Convert query parameters to numbers
    const activeDaysNum = Number(activeDays);
    const dayRangeNum = Number(dayRange);
    const minMessagesNum = Number(minMessages);

    const endDate = new Date();
    const startDate = new Date();
    startDate.setDate(endDate.getDate() - dayRangeNum);

    // Calculate date ranges for message activity (daily, weekly, monthly)
    const dailyStartDate = new Date();
    dailyStartDate.setDate(endDate.getDate() - 1); // 1 day ago

    const weeklyStartDate = new Date();
    weeklyStartDate.setDate(endDate.getDate() - 7); // 7 days ago

    const monthlyStartDate = new Date();
    monthlyStartDate.setMonth(endDate.getMonth() - 1); // 1 month ago

    // Fetch all circles and populate members and events
    const circles = await Circle.find({}).populate('members', '_id').populate('events', '_id');

    const typeMap = {};  // Object to store circle type details
    const typeCircleIds = {};  // To collect circle IDs grouped by type

    // Group circles by type
    circles.forEach(circle => {
      const { type } = circle;
      if (!typeMap[type]) {
        typeMap[type] = {
          count: 0,
          totalMembers: 0,
          totalEvents: 0,
          totalMessages: 0,
          activeUsers: 0,  // Initialize active user count
          messageActivity: { daily: 0, weekly: 0, monthly: 0 }  // Initialize message activity
        };
        typeCircleIds[type] = [];  // Initialize array for circle IDs
      }

      typeMap[type].count += 1;
      typeMap[type].totalMembers += circle.members.length;
      typeMap[type].totalEvents += circle.events.length;
      typeCircleIds[type].push(circle._id);  // Collect circle IDs for messages
    });

    // Fetch and process messages for each type's circles
    for (const [type, circleIds] of Object.entries(typeCircleIds)) {
      // Fetch messages within the day range
      const messagesInRange = await Message.find({
        circleId: { $in: circleIds },
        createdAt: { $gte: startDate, $lte: endDate }
      }).select('sender createdAt');

      // Group messages by sender and day
      const userActivity = {};
      messagesInRange.forEach(msg => {
        const userId = msg.sender.toString();
        const day = msg.createdAt.toISOString().split('T')[0]; // Get date without time

        if (!userActivity[userId]) {
          userActivity[userId] = {};
        }
        if (!userActivity[userId][day]) {
          userActivity[userId][day] = 0;
        }
        userActivity[userId][day] += 1;
      });

      // Check users who meet the active criteria (sending at least minMessages on activeDays)
      let activeUserCount = 0;
      Object.values(userActivity).forEach(days => {
        const activeDayCount = Object.values(days).filter(count => count >= minMessagesNum).length;
        if (activeDayCount >= activeDaysNum) {
          activeUserCount += 1;
        }
      });

      typeMap[type].totalMessages = messagesInRange.length;
      typeMap[type].activeUsers = activeUserCount;

      // Calculate message activity (daily, weekly, monthly) only for active users
      const dailyMessages = await Message.find({
        circleId: { $in: circleIds },
        createdAt: { $gte: dailyStartDate, $lte: endDate },
        sender: { $in: Object.keys(userActivity) }  // Include only active users
      }).countDocuments();
      typeMap[type].messageActivity.daily = dailyMessages;

      const weeklyMessages = await Message.find({
        circleId: { $in: circleIds },
        createdAt: { $gte: weeklyStartDate, $lte: endDate },
        sender: { $in: Object.keys(userActivity) }  // Include only active users
      }).countDocuments();
      typeMap[type].messageActivity.weekly = weeklyMessages;

      const monthlyMessages = await Message.find({
        circleId: { $in: circleIds },
        createdAt: { $gte: monthlyStartDate, $lte: endDate },
        sender: { $in: Object.keys(userActivity) }  // Include only active users
      }).countDocuments();
      typeMap[type].messageActivity.monthly = monthlyMessages;
    }

    // Prepare the final response
    const typeStats = Object.entries(typeMap).map(([type, data]) => ({
      type,
      groupCount: data.count,
      averageGroupSize: (data.totalMembers / data.count).toFixed(2),
      messageCount: data.totalMessages,
      eventCount: data.totalEvents,
      activeUsers: data.activeUsers,  // Include active user count
      messageActivity: data.messageActivity  // Include message activity (daily, weekly, monthly)
    }));

    // Pagination logic
    const totalItems = typeStats.length;
    const totalPages = Math.ceil(totalItems / itemsPerPage);
    const startIndex = (currentPage - 1) * itemsPerPage;
    const paginatedTypes = typeStats.slice(startIndex, startIndex + itemsPerPage);

    // Return the paginated response with total pages
    return res.status(200).json({
      status: 'success',
      message: 'Circle type statistics fetched successfully',
      data: {
        types: paginatedTypes,
        currentPage: parseInt(currentPage),
        totalPages: totalPages
      }
    });
  } catch (err) {
    console.error("Error fetching circle type statistics:", err);
    return res.status(500).json(error("An error occurred while fetching circle type statistics"));
  }
};


// module.exports.getOfferStats = async (req, res) => {
//     try {
//         // Pagination parameters with validation
//         let { currentPage, itemsPerPage} = req.query;

//         // Convert to integers
//         currentPage = parseInt(currentPage);
//         itemsPerPage = parseInt(itemsPerPage);

//         // Validate pagination parameters
//         if (isNaN(currentPage) || currentPage <= 0) {
//             return res.status(400).json({ message: "Invalid 'currentPage' parameter. It must be a positive integer greater than 0." });
//         }
        
//         if (isNaN(itemsPerPage) || itemsPerPage <= 0 || itemsPerPage > 100) {
//             return res.status(400).json({ message: "Invalid 'itemsPerPage' parameter. It must be a positive integer between 1 and 100." });
//         }

//         const skip = (currentPage - 1) * itemsPerPage;

//         // Step 1: Fetch unique interests from all offers
//         const interests = await Offer.distinct('interest');

//         const result = {};

//         // Step 2: Loop through each interest and gather the required data
//         for (let interest of interests) {
//             const offersInInterest = await Offer.find({ interest }).skip(skip).limit(itemsPerPage);

//             // Step 3: Aggregate values for each interest
//             let totalOffers = offersInInterest.length;
//             let circleCount = 0;
//             let purchasedCircleCount = 0;
//             let totalRevenue = 0;
//             let totalDaysBetweenPurchases = 0;
//             let totalPurchases = 0;
//             let totalEventsCount = 0;

//             for (let offer of offersInInterest) {
//                 // Get circles that the offer is shared in
//                 const circlesWithOffer = await Circle.find({ circle_interests: interest });

//                 circleCount += circlesWithOffer.length;

//                 // Loop through each circle to calculate purchased circle count and revenue
//                 for (let circle of circlesWithOffer) {
//                     const purchases = circle.purchasedOffers.filter(purchase => String(purchase.offerId) === String(offer._id));
//                     if (purchases.length > 0) {
//                         purchasedCircleCount++;
//                         totalPurchases += purchases.length;
//                         totalRevenue += offer.price * purchases.length;

//                         // Calculate the days between purchases for this circle
//                         const purchaseDates = purchases.map(p => new Date(p.purchaseDate));
//                         const dateDifferences = [];
//                         for (let i = 1; i < purchaseDates.length; i++) {
//                             const diffTime = Math.abs(purchaseDates[i] - purchaseDates[i - 1]);
//                             const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
//                             dateDifferences.push(diffDays);
//                         }
//                         totalDaysBetweenPurchases += dateDifferences.reduce((a, b) => a + b, 0);
//                     }

//                     // Step 4: Count the total events for the circles in this interest
//                     totalEventsCount += circle.events.length;
//                 }
//             }

//             // Calculate the average days between purchases (if applicable)
//             const avgDaysBetweenPurchases = totalPurchases > 1 ? (totalDaysBetweenPurchases / (totalPurchases - 1)).toFixed(2) : 0;

//             // Save the aggregated result for this interest
//             result[interest] = {
//                 totalOffers,
//                 interest,
//                 groupsReach: circleCount,
//                 purchasedCircles: purchasedCircleCount,
//                 totalRevenue,
//                 avgDaysBetweenPurchases,
//                 eventsCount: totalEventsCount
//             };
//         }

//         // Convert the aggregated result object to an array
//         const resultArray = Object.values(result);

//         // Pagination information
//         const totalItems = await Offer.countDocuments();
//         const totalPages = Math.ceil(totalItems / itemsPerPage);

//         // Step 7: Return the response with pagination
//         return res.status(200).json({
//             message: 'Interest-based classified offers fetched successfully',
//             data: resultArray,
//             currentPage,
//             totalPages
//         });
//     } catch (err) {
//         console.error('Error fetching interest-based classified offers:', err);
//         return res.status(500).json({
//             message: 'An error occurred while fetching the offers data',
//             error: err.message
//         });
//     }
// };

module.exports.getOfferStats = async (req, res) => {
  try {
    // Pagination parameters with validation
    let { currentPage, itemsPerPage } = req.query;

    // Convert to integers
    currentPage = parseInt(currentPage);
    itemsPerPage = parseInt(itemsPerPage);

    // Validate pagination parameters
    if (isNaN(currentPage) || currentPage <= 0) {
      return res.status(400).json({ message: "Invalid 'currentPage' parameter. It must be a positive integer greater than 0." });
    }

    if (isNaN(itemsPerPage) || itemsPerPage <= 0 || itemsPerPage > 100) {
      return res.status(400).json({ message: "Invalid 'itemsPerPage' parameter. It must be a positive integer between 1 and 100." });
    }

    // Step 1: Fetch unique interests from all offers
    const interests = await Offer.distinct('interest');

    const result = [];

    // Step 2: Paginate interests
    const startIndex = (currentPage - 1) * itemsPerPage;
    const paginatedInterests = interests.slice(startIndex, startIndex + itemsPerPage);

    // Step 3: Loop through paginated interests and gather data
    for (let interest of paginatedInterests) {
      // Fetch offers for this interest
      const offersInInterest = await Offer.find({ interest }).lean();

      // Skip if no offers for this interest
      if (!offersInInterest.length) continue;

      // Step 4: Aggregate values for each interest
      let totalOffers = offersInInterest.length;
      let circleCount = 0;
      let purchasedCircleCount = 0;
      let totalRevenue = 0;
      let totalEventsCount = 0;
      let totalPurchases = 0;

      // Get circles that match this interest
      const circlesWithInterest = await Circle.find({ circle_interests: interest }).lean();
      circleCount = circlesWithInterest.length;

      // Calculate metrics for each offer
      for (let offer of offersInInterest) {
        // Number of purchases is the length of the buyers array
        const purchases = offer.buyers.length;
        totalPurchases += purchases;

        // Revenue = price * number of buyers
        totalRevenue += offer.price * purchases;

        // Check if any circle members bought this offer
        for (let circle of circlesWithInterest) {
          const hasPurchase = circle.members.some(member =>
            offer.buyers.map(b => b.toString()).includes(member.toString())
          );
          if (hasPurchase) {
            purchasedCircleCount++;
          }
          totalEventsCount += circle.events ? circle.events.length : 0;
        }
      }

      // Save the aggregated result for this interest
      result.push({
        interest,
        totalOffers,
        groupsReach: circleCount,
        purchasedCircles: purchasedCircleCount,
        totalRevenue,
        avgDaysBetweenPurchases: 0, // Cannot calculate without purchase dates
        eventsCount: totalEventsCount
      });
    }

    // Pagination information
    const totalItems = interests.length;
    const totalPages = Math.ceil(totalItems / itemsPerPage);

    // Step 5: Return the response with pagination
    return res.status(200).json({
      message: 'Interest-based classified offers fetched successfully',
      data: result,
      currentPage,
      totalPages
    });
  } catch (err) {
    console.error('Error fetching interest-based classified offers:', err);
    return res.status(500).json({
      message: 'An error occurred while fetching the offers data',
      error: err.message
    });
  }
};

module.exports.deleteOffer = async (req, res) => {
  try {
    const { offerId } = req.params;

    // Check if the offer exists
    const offer = await Offer.findById(offerId);
    if (!offer) {
      return res.status(404).json(error("Offer not found"));
    }

    // Delete the offer
    await Offer.findByIdAndDelete(offerId);

    // Remove the offer from savedOffer collection
    await savedOffer.deleteMany({ offerId });

    // Optionally: Remove associated messages
    // await Message.deleteMany({ "offerDetails._id": offerId });

    // Log the deletion
    console.log(`Offer ${offerId} deleted successfully`);

    return res.status(200).json(success("Offer deleted successfully"));
  } catch (err) {
    console.error("Error deleting offer:", err);
    return res
      .status(500)
      .json(error("An error occurred while deleting the offer"));
  }
};