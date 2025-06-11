import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../controller/utils/global_variables.dart';
import '../../models/loop_models/event_model.dart';
import '../../view/custom_widget/customwidgets.dart';
import '../utils/api_constants.dart';

class EventApis {
  final BuildContext context;

  EventApis(this.context);

  Future<bool> createEvent({required String eventName, required String color}) async {
    String apiName = "Create Event Type";

    final url = Uri.parse("$baseURL/$createEventEP");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    final body = {
      "name": eventName,
      "color": color,
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

  Future<List<Event>> getEvents() async {
    String apiName = "Get Event Types";
    final url = Uri.parse("$baseURL/$getEventsEP");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };
    print("$url\n$userToken");
    Response response = await get(url, headers: headers);
    if (response.statusCode == 200) {
      print("API Success: $apiName\n${response.body}");
      List<dynamic> jsonList = jsonDecode(response.body)['eventTypes'];
      List<Event> eventTypes = jsonList.map((e) => Event.fromJson(e)).toList();
      return eventTypes;
    }
    print("API Failed: $apiName\n ${response.body}");
    return [];
  }
}
