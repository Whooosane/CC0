import 'dart:convert';
import 'dart:developer';
import 'package:circleapp/controller/utils/api_constants.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
class ShareInGroupApi {
  ///Share in Group Api Method
  Future<void> shareInGroupApiMethod(
      {required List<String> circleIds,
      required String itemIdKey,
      required String itemId,
      required String type,
      required String token})
  async {
    final url = Uri.parse("$baseURL$shareInGroupEp");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token"
    };
    final body = {
      "circleIds": circleIds,
      "type": type,
      itemIdKey: itemId,
    };
    http.Response response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    log("Before Response ${response.body}");
    log("Before Response ${response.statusCode}");
    if (response.statusCode == 201) {
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
