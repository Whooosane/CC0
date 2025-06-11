import 'package:circleapp/controller/utils/common_methods.dart';
import 'package:circleapp/models/ItineraryModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../api/Itinerary_apis.dart';

class ItineraryController extends GetxController {
  late final BuildContext context;

  ItineraryController(this.context);

  // Variables
  RxBool loading = false.obs;
  RxList<ItineraryModel> itineraries = RxList<ItineraryModel>();

  // API Methods
  Future<bool> createItinerary({
    required bool load,
    required String name,
    required String about,
    required String date,
    required String time,
  }) async {
    if (load) {
      loading.value = true;
    }

    bool result = await ItinerariesApis(context).createItinerary(
      name: name,
      about: about,
      date: date,
      time: time,
    );

    loading.value = false;
    return result;
  }

  Future<void> getItineraries({required bool load, required DateTime dateTime}) async {
    if (load) {
      loading.value = true;
    }

    List<ItineraryModel>? fetchedItineraries = await ItinerariesApis(context).getItineraries(date: getFormattedDate(dateTime));
    if (fetchedItineraries != null) {
      itineraries.assignAll(fetchedItineraries);
    }

    loading.value = false;
  }
}
