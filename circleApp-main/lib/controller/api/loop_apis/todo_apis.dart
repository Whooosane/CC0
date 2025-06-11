import 'dart:convert';

import 'package:circleapp/models/loop_models/todo_models/todo_bill_model.dart';
import 'package:circleapp/models/loop_models/todo_models/todo_details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Response, MultipartFile;
import 'package:http/http.dart';
import '../../../models/add_todo_model.dart';
import '../../../models/all_todo_model.dart';
import '../../../view/custom_widget/customwidgets.dart';
import '../../../view/screens/bottom_navigation_screen.dart';
import '../../utils/api_constants.dart';
import '../../utils/global_variables.dart';

class TodoApis{
  BuildContext context;

  TodoApis(this.context);

  Future<void> addNewTodo({
    required AddNewTodoModel addNewTodoModel
  }) async {
    String apiName = "Create Todo";

    final url = Uri.parse("$baseURL/api/todos/create");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    Response response = await post(url, headers: headers, body: jsonEncode(addNewTodoModel));
    Map<String, dynamic> responseBody = json.decode(response.body);
    print(response.body);

    if (response.statusCode == 201) {
      print("API Success: $apiName\n${response.body}");
      Get.offAll(const BottomNavigationScreen());
      customScaffoldMessenger( responseBody["message"]);
      return;
    }
    print("API Failed: $apiName\n ${response.body}");
    customScaffoldMessenger( responseBody["error"]);
    return;
  }

  Future<AllTodoModel?> getCircleTodos({required String circleId}) async {
    String apiName = "Get Circle Todos";
    final url = Uri.parse("$baseURL/$getTodos/$circleId");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    Response response = await get(url, headers: headers);
    if (response.statusCode == 200) {
      print("API Success: $apiName\n${response.body}");
      return allTodoModelFromJson(response.body);
    }
    print("API Failed: $apiName\n ${response.body}");
    return null;
  }

  Future<TodoDetailsModel?> getTodoById({required String circleId, required String todoId}) async {
    String apiName = "Get Todo Details";
    final url = Uri.parse("$baseURL/$getTodoByIdEP/$todoId/$circleId");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    Response response = await get(url, headers: headers);
    if (response.statusCode == 200) {
      print("API Success: $apiName\n${response.body}");
      return todoDetailsModelFromJson(response.body);
    }
    print("API Failed: $apiName\n ${response.body}");
    return null;
  }

  Future<TodoBillModel?> getTodoBill({required String todoId}) async {
    String apiName = "Get Todo Bill";
    final url = Uri.parse("$baseURL/$getTodoBillEP/$todoId");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    Response response = await get(url, headers: headers);
    if (response.statusCode == 200) {
      print("API Success: $apiName\n${response.body}");
      return todoBillModelFromJson(response.body);
    }
    print("API Failed: $apiName\n ${response.body}");
    return null;
  }

  Future<bool> payBill({required String todoId, required String circleId, required String memberId}) async {
    String apiName = "Pay Bill";
    final url = Uri.parse("$baseURL/$payBillEp/$todoId/$circleId");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    final body = {
      "memberId" : memberId
    };
    Response response = await put(url, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      print("API Success: $apiName\n${response.body}");
      return true;
    }
    print("API Failed: $apiName\n ${response.body}");
    return false;
  }
}