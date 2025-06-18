const mongoose = require("mongoose");

const OfferSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true,
  },
  description: {
    type: String,
    required: true,
    trim: true,
  },
  numberOfPeople: {
    type: Number,
    required: true,
    min: [1, "Number of people must be at least 1"],
  },
  buyersCount: {
    type: Number,
    default: 0,
    min: [0, "Buyers count cannot be negative"],
  },
  startingDate: {
    type: Date,
    required: true,
    validate: {
      validator: function (value) {
        return value >= new Date();
      },
      message: "Starting date cannot be in the past",
    },
  },
  endingDate: {
    type: Date,
    required: true,
    validate: {
      validator: function (value) {
        return value >= this.startingDate;
      },
      message: "Ending date cannot be before the starting date",
    },
  },
  interest: {
    type: String,
    required: true,
    trim: true,
  },
  price: {
    type: Number,
    required: true,
    min: [0, "Price must be a positive number"],
  },
  imageUrls: {
    type: [String],
    required: true,
    validate: {
      validator: function (values) {
        return values.every((url) =>
          /^https?:\/\/.+\.(jpg|jpeg|png|gif|svg)$/i.test(url)
        );
      },
      message:
        "Each image URL must be a valid URL and end with an image extension (jpg, jpeg, png, gif, svg)",
    },
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  active: {
    type: Boolean,
    default: true,
  },
  buyers: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
  ],
});

module.exports = mongoose.model("Offer", OfferSchema);
