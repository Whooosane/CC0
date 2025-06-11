//Base Url
const baseURL = "https://circle-awgtevadd7fpf4cm.canadacentral-01.azurewebsites.net";
//End Points
//auth
const signUpEP = "api/auth/signup";
const addStoryEP = "/api/stories/create/";

const editProfileEP = "/api/auth/editProfile";
const getCurrentUserEP = "api/auth/profile";
const getAllUsersEP = "api/auth/members";

//circle
const getCircleByIdEP = "/api/circle/get-circle";
const editCircleEP = "/api/circle/update";
const uploadCircleImageEP = "api/circle/upload-image";
const addMemberToCircleEP = "api/circle/add-member";

//To do
const getTodos = "api/todos/get";
const getTodoByIdEP = "api/todos/get";
const getTodoBillEP = "api/todos/bill";
const payBillEp = 'api/todos/bill';

const getConversationsEP = "api/messenger/conversations";
const getMessagesEP = "api/messenger/get";
const sendMessageEP = "api/messenger/send";
const getCirclesEP = "api/circle/all";
const getCircleMembersEP = "api/circle/members";
const uploadFileEP = "api/upload/images";
const createStoryEP = "api/stories/create";
const getStoriesEP = "api/stories";
const createItineraryEP = "/api/itinerary/create";
const getItinerariesEP = "/api/itinerary/get?date=";
const createEventEP = "/api/plan/event-types/create";
const getEventsEP = "/api/plan/event-types";
const createPlanEP = "/api/plan/create";
const getPlansEP = "/api/plan/get?date=";
const deletePlanEP = "/api/plan/delete";


//Convos
const addToConvosEP = "/api/messenger/pin";
const getConvosEP = "/api/messenger/pinned";

//Offers
const getOffersEP = "/api/offer/get-offers";
const saveOfferEP = "/api/offer/toggle-saved-offer/";
const buyOfferEP = "api/offer/buy-offer";
//upload images
const uploadImagesEp="/api/upload/images";
//Share in Group
const shareInGroupEp="/api/messenger/share-in-circles";