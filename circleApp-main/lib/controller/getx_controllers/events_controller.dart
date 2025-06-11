import 'package:circleapp/controller/api/event_apis.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../models/loop_models/event_model.dart';

class EventController extends GetxController {
  late final BuildContext context;

  EventController(this.context);

  // Variables
  RxBool loading = false.obs;
  RxList<Event> events = RxList<Event>();

  // API Methods
  Future<bool> createEvents({
    required bool load,
    required String eventName,
    required String color,
  }) async {
    if (load) {
      loading.value = true;
    }

    return await EventApis(context).createEvent(
      eventName: eventName,
      color: color,
    ).then((value) {
      loading.value = false;
      return value;
    },);
  }

  Future<void> getEvents({required bool load}) async {
    if (load) {
      loading.value = true;
    }

    List<Event> types = await EventApis(context).getEvents();
    events.assignAll(types);

    loading.value = false;
  }
}
