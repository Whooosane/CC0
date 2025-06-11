import 'dart:developer';
import 'package:circleapp/controller/api/loop_apis/convos_apis.dart';
import 'package:circleapp/models/get_convos_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConvosController extends GetxController {
  final BuildContext context;
  ConvosController(this.context);

  ///Variables
  RxBool getConvosLoading = false.obs;
  RxBool addConvosLoading = false.obs;
  Rxn<GetConvosModel?> convosModel = Rxn<GetConvosModel>();

  /// Get Convos Controller
  Future<void> getConvos({
    required bool isLoading,
    required String circleId,
    required String token,
  }) async {
    try {
      print("circleId: $circleId");
      print("token: $token");
      getConvosLoading.value = isLoading;

      final result = await ConvosApis(context).getConvos(
        circleId: circleId,
        token: token,
      );
      print("API Result: $result");
      if (result != null) {
        convosModel.value = result;
        print("convosModel.value: ${convosModel.value}");
      } else {
        print("Get Convos returned null");
        customScaffoldMessenger("Failed to load conversations: No data received");
      }
    } catch (e) {
      print("Get Convos Controller Error: $e");
      customScaffoldMessenger("Failed to load conversations: $e");
    } finally {
      getConvosLoading.value = false;
    }
  }
  ///Add Convos to Group Controller
  Future<void> addToConvos({
    required String token,
    required String circleId,
    required RxList<String> messageIds,
  })
  async {
    try {
      print("CircleId :$circleId");
      print("token :$token");
      print("messageIds :$messageIds");
      addConvosLoading.value = true;
      await ConvosApis(context).addToConvos(
          token: token, messageIds: messageIds, circleId: circleId);
      addConvosLoading.value = false;
    } catch (e) {
      addConvosLoading.value = false;
      customScaffoldMessenger("Error Add Convos Controller :$e");
    }
  }
}
