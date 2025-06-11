import 'dart:convert';

import 'package:circleapp/controller/utils/global_variables.dart';
import 'package:circleapp/models/stories_model.dart';
import 'package:circleapp/view/screens/bottom_navigation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../view/custom_widget/customwidgets.dart';
import '../utils/api_constants.dart';

class StoriesApis {
  final BuildContext context;

  StoriesApis(this.context);

  Future<bool> uploadStory(
      {required String circleId,
      required String mediaType,
      required String text,
      required String mediaUrl}) async {
    String apiName = "Upload Story";

    final url = Uri.parse("$baseURL/$createStoryEP/$circleId");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    final body = {
      "mediaUrl": mediaUrl,
      "mediaType": mediaType,
      "text": text,
    };

    var response = await post(url, headers: headers, body: jsonEncode(body));
    Map<String, dynamic> responseBody = json.decode(response.body);
    customScaffoldMessenger( responseBody["message"]);

    if (response.statusCode == 201) {
      print("API Success: $apiName\n${response.body}");
      Get.off(() => BottomNavigationScreen());
      return true;
    }
    print("API Failed: $apiName\n ${response.body}");
    return false;
  }

  Future<StoriesModel?> getStories({required String circleId}) async {
    String apiName = "Get Stories";
    final url = Uri.parse("$baseURL/$getStoriesEP/$circleId");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };
    print("$url\n$userToken");
    final response = await get(url, headers: headers);
    if (response.statusCode == 200) {
      print("API Success: $apiName\n${response.body}");
      return StoriesModel.fromJson(jsonDecode(response.body));
    }
    print("API Failed: $apiName\n ${response.body}");
    return null;
  }
}
