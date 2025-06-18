const mongoose = require("mongoose");

const mediaSchema = new mongoose.Schema({
  type: { type: String, required: true }, // e.g., 'image', 'video', etc.
  url: { type: String, required: true }, // URL of the media (image, video, etc.)
  mimetype: { type: String, required: true }, // Media type (image/jpeg, video/mp4, etc.)
});

const offerDetailsSchema = new mongoose.Schema({
  offerId: { type: mongoose.Schema.Types.ObjectId, ref: "Offer" },
  title: { type: String },
  description: { type: String },
  imageUrls: [{ type: String }],
  discount: { type: Number }, // If applicable, store discount percentage or value
  expiryDate: { type: Date },
});

const planDetailsSchema = new mongoose.Schema({
  planId: { type: mongoose.Schema.Types.ObjectId, ref: "Plan" },
  planName: { type: String },
  planDescription: { type: String },
  price: { type: Number },
  duration: { type: String }, // e.g., '1 month', '6 months', etc.
});

const messageSchema = new mongoose.Schema(
  {
    message: { type: String, default: "" }, // Text message content, if type is 'text'
    type: {
      type: String,
      enum: ["text", "offer", "plan", "itinerary"],
      required: true,
    }, // Message type
    sender: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    }, // Who sent the message
    circleId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Circle",
      required: true,
    }, // Circle to which message belongs
    media: [mediaSchema], // Media related to the message (images, videos, etc.)
    pinned: { type: Boolean, default: false }, // Whether the message is pinned
    offerId: { type: mongoose.Types.ObjectId, ref: "Offer", default: null }, // Offer details (if type is 'offer')
    planId: { type: mongoose.Types.ObjectId, ref: "Plan", default: null }, // Plan details (if type is 'plan')
    itineraryId: {
      type: mongoose.Types.ObjectId,
      ref: "Itinerary",
      default: null,
    }, // Itinerary details (if type is 'itinerary')
  },
  {
    timestamps: true, // Automatically adds createdAt and updatedAt
  }
);

module.exports = mongoose.model("Message", messageSchema);
