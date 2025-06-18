const router = require("express").Router();
const multer = require('multer');
const { adminMiddleware } = require("../Middlewares/admin");

const {
    adminLogin,
    adminForgotPassword,
    adminVerifyOtp,
    adminResetPassword,
    createOffer,
    getOffersByStatus,
    getInterestStats,
    getTypeStats,
    getOfferStats,
    deleteOffer 
} = require("../Controllers/admin");

router.post("/login", adminLogin);
router.post("/forgot-password", adminForgotPassword);
router.post("/verify-otp", adminVerifyOtp);
router.post("/reset-password", adminResetPassword);

router.use(adminMiddleware);
router.post("/create-offer", createOffer);
router.get('/offers', getOffersByStatus);
router.get('/interest-stats', getInterestStats);
router.get('/type-stats', getTypeStats);
router.get('/offer-stats', getOfferStats);
router.delete('/delete-offer/:offerId', deleteOffer); 

module.exports = router;