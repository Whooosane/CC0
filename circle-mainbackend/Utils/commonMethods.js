const express = require('express');
const nodemailer = require('nodemailer');

// Success and error response functions
module.exports.success = (message) => ({ status: true, message });
module.exports.successWithData = (message, data) => ({ status: true, message, ...data });
module.exports.error = (message) => ({ status: false, message });

// Initialize the nodemailer transporter
const transporter = nodemailer.createTransport({
  service: 'gmail', // You can replace it with any other email provider
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASSWORD,
  },
});

/**
 * Function to send an email
 * @param {string} to - Recipient's email address
 * @param {string} subject - Email subject
 * @param {string} text - Email body text
 * @returns {boolean} - Returns true if email was sent successfully, otherwise false
 */
module.exports.sendEmail = async (to, subject, text) => {
  try {
    await transporter.sendMail({
      from: process.env.EMAIL_USER,
      to,
      subject,
      text,
    });
    return true;
  } catch (error) {
    console.error('Error sending email:', error.message);
    return false;
  }
};

// Function to generate OTP
module.exports.generateOTP = () => Math.floor(1000 + Math.random() * 900000);

// Function to validate and return
module.exports.validateAndReturn = (req, res, modelMethod) => {
  try {
    if ((req.method === 'POST' || req.method === 'PUT') && !req.is('application/json')) {
      console.error('Invalid data format: JSON required');
      return res.status(400).json(error('Invalid data format: JSON required'));
    }

    const data = req.body;
    const result = modelMethod(data);
    res.status(200).json(result);
  } catch (err) {
    console.error(`Error in model method: ${err.message}`);
    res.status(400).json(error(`An error occurred while processing the request: ${err.message}`));
  }
};

// Function to construct full URL
module.exports.constructFullURL = (req, filePath) => {
  const baseURL = `${req.protocol}://${req.get('host')}/`;
  return `${baseURL}${filePath}`;
};
