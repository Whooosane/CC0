const mongoose = require("mongoose");

const SavedOfferSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  offerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Offer",
    required: true,
  },
  savedAt: {
    type: Date,
    default: Date.now,
  },
});

// Compound index to prevent duplicate saves
SavedOfferSchema.index({ userId: 1, offerId: 1 }, { unique: true });

module.exports = mongoose.model("SavedOffer", SavedOfferSchema);
