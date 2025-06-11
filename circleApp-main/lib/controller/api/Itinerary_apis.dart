import 'dart:convert';

import 'package:circleapp/controller/utils/global_variables.dart';
import 'package:circleapp/models/stories_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../../models/ItineraryModel.dart';
import '../../view/custom_widget/customwidgets.dart';
import '../utils/api_constants.dart';

class ItinerariesApis {
  final BuildContext context;

  ItinerariesApis(this.context);

  Future<bool> createItinerary({required String name, required String about, required String date, required String time}) async {
    String apiName = "Create Itinerary";

    final url = Uri.parse("$baseURL/$createItineraryEP");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    final body = {
      "name": name,
      "about": about,
      "date": date,
      "time": time
    };

    Response response = await post(url, headers: headers, body: jsonEncode(body));
    Map<String, dynamic> responseBody = json.decode(response.body);
    customScaffoldMessenger( responseBody["message"]);

    if (response.statusCode == 201) {
      print("API Success: $apiName\n${response.body}");
      return true;
    }
    print("API Failed: $apiName\n ${response.body}");
    return false;
  }

  Future<List<ItineraryModel>?> getItineraries({required String date}) async {
    String apiName = "Get Itineraries";
    final url = Uri.parse("$baseURL/$getItinerariesEP$date");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    print("$url\n$userToken");

    try {
      Response response = await get(url, headers: headers);

      if (response.statusCode == 200) {
        print("API Success: $apiName\n${response.body}");

        List<dynamic> jsonList = jsonDecode(response.body);
        List<ItineraryModel> itineraries = jsonList.map((item) => ItineraryModel.fromJson(item)).toList();

        return itineraries;
      } else {
        print("API Failed: $apiName\n ${response.body}");
        return null;
      }
    } catch (e) {
      print("API Failed: $apiName\n $e");
      return null;
    }
  }
}
