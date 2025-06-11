import 'dart:convert';
import 'dart:developer';
import 'package:circleapp/controller/utils/api_constants.dart';
import 'package:circleapp/controller/utils/global_variables.dart';
import 'package:circleapp/models/offer_models/offers_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OfferApis {
  final BuildContext context;
  OfferApis(this.context);

  ///Get Offer Api Method
  Future<OffersModel?> getOffers(String interest) async {
    String apiName = "Get Event Types";
    final url = Uri.parse("$baseURL/$getOffersEP/$interest");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };
    log("$url\n$userToken");
    http.Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      log("API Success: $apiName\n${response.body}");
      return offersModelFromJson(response.body);
    }
    log("API Failed: $apiName\n ${response.body}");
    return null;
  }

  /// Save Offer Api Method
  Future<String> saveOffer({required String offerId, required String token}) async {
    final url = Uri.parse("$baseURL$saveOfferEP/$offerId");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    log("$url\n$userToken");

    final response = await http.post(
      Uri.parse("$baseURL/$saveOfferEP/$offerId"),
      headers: headers
    );

    // Logging after getting response
    log("Raw Response Body: ${response.body}");
    log("Response Status Code: ${response.statusCode}");

    log("Before Response :${response.body}");
    log("Before Response :${response.statusCode}");

    if (response.statusCode == 200 || response.statusCode==201) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);
      log("Decoded Message: ${decodedBody["message"]}");
      log(decodedBody["message"]);
      return decodedBody["message"];
    } else {
      log("Error: ${response.statusCode} - ${response.body}");
      return "";
    }

    log(response.body);
  }


  ///Book Offer Api Method
  Future<void> buyOffer(
      {required String offerId, required String token})
  async {
    final url = Uri.parse("$baseURL/$buyOfferEP");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = {
      "offerId": offerId,
    };
    log("$url\n$userToken");
    http.Response response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      Get.back();
      final decodedBody = jsonDecode(response.body);
      log("Response :${decodedBody["message"]}");
      customScaffoldMessenger("Response :${decodedBody["message"]}");
    }
    final decodedBody = jsonDecode(response.body);
    log("Response :${decodedBody["message"]}");
    customScaffoldMessenger("Response :${decodedBody["message"]}");
  }
}
