const router = require("express").Router();

//Controllers
const {
  sendMessage,
  getMessages,
  getConversations,
  pinMessage,
  getPinnedMessages,
  shareToMultipleCircles,
} = require("../Controllers/messenger");

//Middlewares
const { customerMiddleware } = require("../Middlewares/user");

//Routes
router.use(customerMiddleware);
router.post("/send", sendMessage);
router.get("/get/:circleId", getMessages);
router.get("/conversations", getConversations);
router.post("/pin", pinMessage);
router.get("/pinned/:circleId", getPinnedMessages);
router.post("/share-in-circles", shareToMultipleCircles);

module.exports = router;
