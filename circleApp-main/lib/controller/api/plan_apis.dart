import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../controller/utils/global_variables.dart';
import '../../models/plan_model.dart';
import '../../view/custom_widget/customwidgets.dart';
import '../utils/api_constants.dart';

class PlanApis {
  final BuildContext context;

  PlanApis(this.context);

  Future<bool> createPlan({
    required String name,
    required String description,
    required String date,
    required String location,
    required String eventType,
    required List<String> members,
    required int budget,
  }) async {
    String apiName = "Create Plan";

    final url = Uri.parse("$baseURL/$createPlanEP");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    final body = {
      "name": name,
      "description": description,
      "date": date,
      "location": location,
      "eventType": eventType,
      "members": members,
      "budget": budget,
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

  Future<List<Plan>> getPlans({required String date}) async {
    String apiName = "Get Plans";
    final url = Uri.parse("$baseURL/$getPlansEP$date");
    print(userToken);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };
    print("$url\n$userToken");
    Response response = await get(url, headers: headers);
    if (response.statusCode == 200) {
      print("API Success: $apiName\n${response.body}");
      List<dynamic> jsonList = jsonDecode(response.body)['plans'];
      List<Plan> plans = jsonList.map((e) => Plan.fromJson(e)).toList();
      return plans;
    }
    print("API Failed: $apiName\n ${response.body}");
    return [];
  }

  Future<bool> deletePlan(String planId) async {
    String apiName = "Delete Plan";
    final url = Uri.parse("$baseURL/$deletePlanEP/$planId");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    Response response = await delete(url, headers: headers);
    Map<String, dynamic> responseBody = json.decode(response.body);
    customScaffoldMessenger( responseBody["message"]);

    if (response.statusCode == 200) {
      print("API Success: $apiName\n${response.body}");
      return true;
    }
    print("API Failed: $apiName\n ${response.body}");
    return false;
  }
}
