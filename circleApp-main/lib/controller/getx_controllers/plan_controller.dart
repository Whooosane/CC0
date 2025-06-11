import 'package:circleapp/controller/utils/common_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/plan_model.dart';
import '../api/plan_apis.dart';

class PlanController extends GetxController {
  late final BuildContext context;

  PlanController(this.context);

  // Variables
  RxBool loading = false.obs;
  RxList<Plan> plans = RxList<Plan>();

  // API Methods
  Future<bool> createPlan({
    required bool load,
    required String name,
    required String description,
    required String date,
    required String location,
    required String eventType,
    required List<String> members,
    required int budget,
  }) async {
    if (load) {
      loading.value = true;
    }

    bool result = await PlanApis(context).createPlan(
      name: name,
      description: description,
      date: date,
      location: location,
      eventType: eventType,
      members: members,
      budget: budget,
    );

    loading.value = false;
    return result;
  }

  Future<void> getPlans({required bool load, required DateTime dateTime}) async {
    if (load) {
      loading.value = true;
    }

    List<Plan> fetchedPlans = await PlanApis(context).getPlans(date: getFormattedDate(dateTime));
    plans.assignAll(fetchedPlans);

    loading.value = false;
  }

  Future<bool> deletePlan(String planId, {required bool load}) async {
    if (load) {
      loading.value = true;
    }

    bool result = await PlanApis(context).deletePlan(planId);

    if (result) {
      plans.removeWhere((plan) => plan.id == planId);
    }

    loading.value = false;
    return result;
  }
}
