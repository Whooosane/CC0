import 'dart:developer';
import 'package:circleapp/controller/api/offer_apis.dart';
import 'package:circleapp/models/offer_models/offers_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
class OffersController extends GetxController {
  late final BuildContext context;
  OffersController(this.context);

 ///Loadings
  RxBool loading = false.obs;
  RxBool bookOfferLoading = false.obs;
  RxBool saveOfferLoading = false.obs;
  RxString returnMessage="".obs;
  ///Rx Models
  Rxn<OffersModel?> offersModel = Rxn<OffersModel>();
  Rxn<Offer?> offer = Rxn<Offer>();

  ///Get Offer Controller
  Future<void> getOffers({required bool load, required String interest})
  async {
    if (load) {
      loading.value = true;
    }

    offersModel.value = await OfferApis(context).getOffers(interest);

    loading.value = false;
  }

  ///Save Offer Controller

  Future<void> saveOffer(
      {required String offerId, required String token})
  async {
    try {
      saveOfferLoading.value = true;
      returnMessage.value= await OfferApis(context).saveOffer(offerId: offerId, token: token);
      saveOfferLoading.value = false;
      log("return Message :${returnMessage.value}");
    } catch (e) {
      saveOfferLoading.value = false;
      customScaffoldMessenger("Error Occurred :${e.toString()}");
    }
  }

  ///Book Offer Controller
  Future<bool> buyOffer({required String offerId, required String token})
  async {
    try {
      bookOfferLoading.value = true;
      log("Calling OfferApis.buyOffer with userId: $token, offerId: $offerId");
      await OfferApis(context).buyOffer(token: token, offerId: offerId);
      bookOfferLoading.value = false;
      return true; // Success
    } catch (e) {
      bookOfferLoading.value = false;
      log("Error Occurred: $e");
      return false; // Failure
    }
  }
}
