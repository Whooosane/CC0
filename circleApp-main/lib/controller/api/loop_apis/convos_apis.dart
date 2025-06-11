import 'dart:convert';
import 'dart:developer';
import 'package:circleapp/controller/utils/api_constants.dart';
import 'package:circleapp/models/get_convos_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:http/http.dart'as http;
class ConvosApis {
  final BuildContext context;
  ConvosApis(this.context);
 ///Add Convos Apis Method
  Future<bool> addToConvos({
    required String token,
    required String circleId,
    required RxList<String> messageIds,
  })
  async {
    String apiName = "Add To Convos";

    final url = Uri.parse("$baseURL/$addToConvosEP");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final encodedBody=jsonEncode({
      "circleId": circleId,
      "messageIds":messageIds
    });
    print("token : $token");
    print("circleId : $circleId");
    print("messageIds: $messageIds");

    http.Response response = await post(url, headers: headers,body:encodedBody );
    print("Before Pined Message Api : ${response.body}");
    print("Before Pined Message Api : ${response.statusCode}");
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    log(responseBody.toString());
    customScaffoldMessenger(responseBody["message"]);
    if (response.statusCode == 200) {
      print("After Pined Message Api : ${response.body}");
      print("After Pined Message Api : ${response.statusCode}");
      log("API Success: $apiName\n${response.body}");
      return true;
    } else {
      log("API Failed: $apiName\n ${response.body}");
      return false;
    }
  }

  ///Get Convos Apis Method
  Future<GetConvosModel?> getConvos({
    required String circleId,
    required String token,
  }) async {
    String apiName = "Get Convos";
    final url = Uri.parse("$baseURL/$getConvosEP/$circleId");
    log("URL: $url");

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      http.Response response = await http.get(url, headers: headers);
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final parsed = getConvosModelFromJson(response.body);
          print("Parsed GetConvosModel: $parsed");
          return parsed;
        } catch (e) {
          log("$apiName Parsing Error: $e");
          return null;
        }
      } else {
        Map<String, dynamic> decodedBody = jsonDecode(response.body);
        log("$apiName Error: ${decodedBody["message"]}");
        return null;
      }
    } catch (e) {
      log("$apiName Exception: $e");
      return null;
    }
  }
}
