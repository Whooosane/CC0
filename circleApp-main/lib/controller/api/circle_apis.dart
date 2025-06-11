import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:circleapp/controller/utils/api_constants.dart';
import 'package:circleapp/controller/utils/common_methods.dart';
import 'package:circleapp/controller/utils/global_variables.dart';
import 'package:circleapp/controller/utils/preference_keys.dart';
import 'package:circleapp/controller/utils/shared_preferences.dart';
import 'package:circleapp/models/circle_models/GetUserInterestsModel.dart';
import 'package:circleapp/models/circle_models/circle_details_model.dart';
import 'package:circleapp/models/circle_models/circle_members_model.dart';
import 'package:circleapp/models/circle_models/get_circle_model.dart';
import 'package:circleapp/models/is_user_model.dart';
import 'package:circleapp/models/loop_models/get_experience_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:circleapp/view/screens/bottom_navigation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Response, MultipartFile;
import 'package:http/http.dart';
import 'package:http/http.dart'as http;

class CircleApis {
  final BuildContext context;
  CircleApis(this.context);

  ///Create Circle Api Method
  Future<void> createCircleApi({
    required String circleName,
    required String circleImage,
    required String description,
    required String type,
    required List<String> circleInterests,
    required List<String> memberIds,
    required List<String> phoneNumbers,
  })
  async {
    final url = Uri.parse("$baseURL/api/circle/create");
    print("url :$url");
    print("userToken :$userToken");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    List<String> userInterests = MySharedPreferences.getListString('user_interests') ?? [];
    final encodedBody = jsonEncode({
      'circleName': circleName,
      'circleImage': circleImage,
      'description': description,
      'type': toCamelCase(type),
      'circle_interests': circleInterests,
      'memberIds': memberIds,
      'phoneNumbers': phoneNumbers,
      'interests': userInterests,
    });

    http.Response response = await post(url, headers: headers, body: encodedBody);
    print("Before Response Body :${response.body}");
    print("Before Response StatusCode :${response.statusCode}");
    if(response.statusCode==201){
      Map<String ,dynamic>decodedBody=jsonDecode(response.body);
      print("After Response Body :${response.body}");
      print("After Response StatusCode :${response.statusCode}");
      print("After Response Message :${decodedBody['message']}");
      Get.offAll(const BottomNavigationScreen());
      MySharedPreferences.setBool(isLoggedInKey, true);
      customScaffoldMessenger(decodedBody["message"]);
    }else{
      Map<String ,dynamic>decodedBody=jsonDecode(response.body);
      print(decodedBody["message"]);
      customScaffoldMessenger(decodedBody["message"]);

    }
  }


  ///Get User Api Method
  Future<List<IsUserModel>?> getIsUser({required List<String> numbers})
  async {
    String apiName = "Get is User";
    final url = Uri.parse("$baseURL/api/auth/check-users");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };
    final body = {"phoneNumbers": numbers};

    Response response = await post(url, headers: headers, body: jsonEncode(body));
    print(response.body);
    if (response.statusCode == 200) {
      print("API Success: $apiName\n${response.body}");
      return isUserModelFromJson(response.body);
    }
    print("API Failed: $apiName\n ${response.body}");
    return null;
  }

  ///Get Circle Api Method
  Future<GetCircleModel?> getCircles()
  async {
    String apiName = "Get Circles";
    final url = Uri.parse("$baseURL/$getCirclesEP");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };
    log("$url\n$userToken");
    Response response = await get(url, headers: headers);
    if (response.statusCode == 200) {
      print("API Success: $apiName\n${response.body}");
      return getCircleModelFromJson(response.body);
    }
    print("API Failed: $apiName\n ${response.body}");
    return null;
  }

  ///Get Circle Members Apis Method
   Future<CircleMembersModel?> getCircleMembers({required String circleId})
   async {
    String apiName = "Get Circle Members";
    final url = Uri.parse("$baseURL/$getCircleMembersEP/$circleId");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };
    print("$url\n$userToken");
    Response response = await get(url, headers: headers);
    if (response.statusCode == 200) {
      print("API Success: $apiName\n${response.body}");
      return circleMembersModelFromJson(response.body);
    }
    print("API Failed: $apiName\n ${response.body}");
    return null;
  }

  ///Upload Circle Image Api Method
  Future<String?> uploadCircleImage({
    required File imageFile,
  })
  async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseURL/$uploadImagesEp'),
    )
      ..headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $userToken',
      })
      ..files.add(await http.MultipartFile.fromPath('images', imageFile.path));
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      log('Parsed response data: $data');
      final imageUrls = data['imageUrls'] as List<dynamic>?;
      return imageUrls != null && imageUrls.isNotEmpty ? imageUrls.first as String : null;
    } else {
      log('Upload failed with status: ${response.statusCode}');
    }
    return null;
  }

  ///Update Circle Api Method
  Future<bool> updateCircle({required String circleId, required String circleName, required String circleImage})
  async {
    String apiName = "Update Circle";

    final url = Uri.parse("$baseURL/$editCircleEP/$circleId");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    final body = {
      "circleName": circleName,
      "circleImage": circleImage,
    };

    Response response = await put(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      print("API Success: $apiName\n${response.body}");
      return true;
    }
    print("API Failed: $apiName\n ${response.body}");
    return false;
  }

  ///Get Circle By Id Api Method
  Future<CircleDetailsModel?> getCircleById(String circleId)
  async {
    String apiName = "Get Circle By Id";

    final url = Uri.parse("$baseURL/$getCircleByIdEP/$circleId");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    Response response = await get(url, headers: headers);
    if (response.statusCode == 200) {
      print("API Success: $apiName\n${response.body}");
      return circleDetailsModelFromJson(response.body);
    }
    print("API Failed: $apiName\n ${response.body}");
    return null;
  }

  ///Add Circle Members Api Method
  Future<bool> addMembersToCircle({required String circleId, required List<String> memberIds})
  async {
    String apiName = "Add Members to Circle";

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    bool allSuccessful = true;

    for (String memberId in memberIds) {
      final url = Uri.parse("$baseURL/$addMemberToCircleEP/$circleId");
      final body = {
        "memberId": memberId,
      };

      Response response = await post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        print("API Success: $apiName\n${response.body}");
      } else {
        print("API Failed: $apiName\n ${response.body}");
        customScaffoldMessenger(jsonDecode(response.body)["error"]);
        allSuccessful = false;
      }
    }

    return allSuccessful;
  }

  /// Get User Interest Api Method
  Future<GetUserInterestsModel?> getUserInterests()
  async {
    String apiName = "Get User Interests";
    final url = Uri.parse("$baseURL/api/auth/user-intrests");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    Response response = await get(url, headers: headers);
    print(response.body);
    if (response.statusCode == 200) {
      print("API Success: $apiName\n${response.body}");
      return getUserInterestsModelFromJson(response.body);
    }
    print("API Failed: $apiName\n ${response.body}");
    return null;
  }

  ///Get Experience Api Method
  Future<GetExperienceModel?> getExperienceApiMethod()
  async {
    String apiName = "Get User Experience";
    final url = Uri.parse("$baseURL/api/offer/experiences");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };
    Response response = await get(url, headers: headers);
    print(response.body);
    print("Before Response Body :${response.body}");
    print("Before Response Body :${response.statusCode}");
    if (response.statusCode == 200) {
      print("After Response Body :${response.body}");
      print("After Response Body :${response.statusCode}");
      print("API Success: $apiName\n${response.body}");
      return getExperienceModelFromJson(response.body);
    }
    print("API Failed: $apiName\n ${response.body}");
    return null;
  }

}
