const router = require("express").Router();

//Project files
const admin = require('./admin');
const auth = require('./auth');
const circle = require('./circle')
const upload = require('./upload')
const messenger = require('./messenger')
const todos = require('./todos')
const stories = require('./stories')
const itinerary = require('./itinerary')
const plan = require('./plan')
const offer = require('./offer')

//connecting routes
router.use('/admin', admin);
router.use('/auth', auth);
router.use('/circle', circle)
router.use('/upload', upload)
router.use('/messenger', messenger)
router.use('/todos', todos)
router.use('/stories', stories)
router.use('/itinerary', itinerary)
router.use('/plan', plan)
router.use('/offer', offer)


module.exports = router;
