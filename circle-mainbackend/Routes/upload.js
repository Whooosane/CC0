const router = require("express").Router();
const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });
const fileUpload = require('express-fileupload');

// Controllers
const { 
    uploadImages, 
    uploadVideo,
    uploadDocument,
    uploadAudio
} = require('../Controllers/upload');

// Middlewares
const { combinedMiddleware } = require("../Middlewares/combined");
router.use(combinedMiddleware);

router.post('/images', upload.array('images', 10), uploadImages);
router.post('/video', fileUpload({ useTempFiles: true, tempFileDir: '/tmp/' }), uploadVideo);
router.post('/document', upload.single('document'), uploadDocument);
router.post('/audio', upload.single('audio'), uploadAudio);

module.exports = router;
