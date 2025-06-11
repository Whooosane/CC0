import 'dart:convert';
import 'dart:developer';
import 'package:circleapp/controller/utils/api_constants.dart';
import 'package:circleapp/controller/utils/global_variables.dart';
import 'package:circleapp/models/conversation_model.dart';
import 'package:circleapp/models/message_models/get_message_model.dart';
import 'package:circleapp/models/message_models/post_message_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class MessengerApis {
  final BuildContext context;

  MessengerApis(this.context);
///Send Message Api Method
  Future<bool> sendMessage({required PostMessageModel postMessageModel})
  async {
    const apiName = 'Send Message';
    final url = Uri.parse('$baseURL/$sendMessageEP');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(postMessageModel.toJson()),
      );
      final responseBody = jsonDecode(response.body);
      customScaffoldMessenger(responseBody['message']);
      _logResponse(apiName, response);

      return response.statusCode == 201;
    } catch (e) {
      _logError(apiName, e);
      return false;
    }
  }

  ///Get Message Api Method
  Future<GetMessageModel?> getMessages({required String circleId}) async {
    const apiName = 'Get Messages';
    final url = Uri.parse('$baseURL/$getMessagesEP/$circleId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    try {
      http.Response response = await http.get(url, headers: headers);
      _logResponse(apiName, response);
      log("Before Message Api Response :${response.body}");
      log("Before Message Api Response Status :${response.statusCode}");
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedBody = jsonDecode(response.body);
        log("DecodedBody :$decodedBody");
        log("After Message Api Response :${response.body}");
        log("After Message Api Response Status :${response.statusCode}");
        return getMessageModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      log("Get Message Api Error :${e.toString()}");
      return null;
    }
  }

  ///Get Conversation Api Method
  Future<ConversationModel?> getConversations()
  async {
    const apiName = 'Get Conversations';
    final url = Uri.parse('$baseURL/$getConversationsEP');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    try {
      final response = await http.get(url, headers: headers);
      _logResponse(apiName, response);

      final responseData = jsonDecode(response.body);
      if (responseData['success']) {
        return ConversationModel.fromJson(responseData);
      }
      return null;
    } catch (e) {
      _logError(apiName, e);
      return null;
    }
  }

  void _logResponse(String apiName, http.Response response) {
    final status = response.statusCode;
    final body = response.body;
    log('API ${status == 200 || status == 201 ? 'Success' : 'Failed'}: $apiName\nStatus: $status\nBody: $body');
  }

  void _logError(String apiName, Object error) {
    log('API Failed: $apiName\nError: $error');
  }
}