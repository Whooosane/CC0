const mongoose = require('mongoose');

const adminSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  password: {
    type: String,
    required: true,
    trim: true
  },
  resetPasswordOtp: {
    type: Number, // Or String if you prefer alphanumeric OTPs
    required: false // Optional: since it won't always be populated
  },
  resetPasswordExpires: {
    type: Date,
    required: false
  },
  resetPasswordVerified: {
    type: Boolean,
    default: false
  }
});

module.exports = mongoose.model('Admin', adminSchema);
