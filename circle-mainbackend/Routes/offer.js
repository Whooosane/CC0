const router = require("express").Router();
const multer = require("multer");
const { customerMiddleware } = require("../Middlewares/user");

const {
  buyOffer,
  getOffersByInterest,
  getAllOffers,
  sendOffer,
  toggleSaveOffer,
  fetchExperienceDetails,
} = require("../Controllers/offer"); // Ensure correct model import

router.use(customerMiddleware);
router.post("/buy-offer", buyOffer);
router.get("/get-all-offers", getAllOffers);
router.get("/get-offers/:interest", getOffersByInterest);
router.use(customerMiddleware);
router.post("/send", sendOffer);
router.post("/toggle-saved-offer/:offerId", toggleSaveOffer);
router.get("/experiences", fetchExperienceDetails);
module.exports = router;
