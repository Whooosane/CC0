const { getIo } = require('./socket');

// Broadcast message to a specific circle
const sendMessageToCircle = (circleId, message) => {
    const io = getIo();
    io.in(circleId).emit('newMessageInChat', message); // Emit to specific room in the chat details screen
};

// Broadcast message update for chat list
const sendMessageToChatList = (circleId, lastMessageData) => {
    const io = getIo();
    io.emit('newMessageInList', { circleId, ...lastMessageData }); // Emit message update for chat list
};

// Broadcast offer to a specific circle
const sendOfferToCircle = (circleId, offer) => {
    const io = getIo();
    io.in(circleId).emit('newOfferInChat', offer); // Emit to a specific room in the chat details screen
};

// Broadcast offer update for chat list
const sendOfferToChatList = (circleId, lastOfferData) => {
    const io = getIo();
    io.emit('newOfferInList', { circleId, ...lastOfferData }); // Emit offer update for chat list
};

module.exports = {
    sendMessageToCircle,
    sendMessageToChatList,
    sendOfferToCircle,
    sendOfferToChatList
};
