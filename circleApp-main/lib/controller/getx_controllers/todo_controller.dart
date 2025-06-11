import 'dart:io';

import 'package:circleapp/controller/api/circle_apis.dart';
import 'package:circleapp/controller/api/loop_apis/todo_apis.dart';
import 'package:circleapp/models/all_todo_model.dart';
import 'package:circleapp/models/circle_models/circle_members_model.dart';
import 'package:circleapp/models/circle_models/post_circle_model.dart';
import 'package:circleapp/models/loop_models/todo_models/todo_bill_model.dart';
import 'package:circleapp/models/loop_models/todo_models/todo_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/add_todo_model.dart';
import '../../models/circle_models/get_circle_model.dart';
import '../../models/contact_model.dart';
import '../../models/is_user_model.dart';
import '../../view/custom_widget/customwidgets.dart';
import '../utils/common_methods.dart';

class TodosController extends GetxController {
  final BuildContext context;
  TodosController(this.context);

  //Variables
  RxBool loading = false.obs;
  RxBool newTodoLoading = false.obs;
  RxBool payingLoader = false.obs;
  Rxn<AllTodoModel> allTodosModel = Rxn<AllTodoModel>();
  Rxn<TodoDetailsModel> todoDetailModel = Rxn<TodoDetailsModel>();
  Rxn<TodoBillModel> todoBillModel = Rxn<TodoBillModel>();
  TextEditingController circleNameTextController = TextEditingController();
  TextEditingController circleDescriptionTextController = TextEditingController();

  //API Methods
  Future<void> createNewTodo({
    required bool load,
    required AddNewTodoModel addNewToDoModel,
  }) async {
    if (load) {
      newTodoLoading.value = true;
    }
    await TodoApis(context).addNewTodo(addNewTodoModel: addNewToDoModel);
    newTodoLoading.value = false;
  }

  Future<void> getTodosTodos({required bool load, required String circleId}) async {
    if (load) {
      loading.value = true;
    }

    allTodosModel.value = await TodoApis(context).getCircleTodos(circleId: circleId);
    loading.value = false;
  }

  Future<void> getTodoById({required bool load, required String circleId, required String todoId}) async {
    if (load) {
      loading.value = true;
    }

    todoDetailModel.value = await TodoApis(context).getTodoById(circleId: circleId, todoId: todoId);
    loading.value = false;
  }

  Future<void> getTodoBill({required bool load, required String todoId}) async {
    if (load) {
      loading.value = true;
    }

    todoBillModel.value = await TodoApis(context).getTodoBill(todoId: todoId);
    loading.value = false;
  }

  Future<bool> payBill({required bool load, required String circleId, required String todoId, required String memberId}) async {
    if (load) {
      payingLoader.value = true;
    }

    bool payed = await TodoApis(context).payBill(todoId: todoId, circleId: circleId, memberId: memberId);
    if(payed)
      {
        int index = todoBillModel.value!.billDetails.pendingUsers.indexWhere((m) => m.memberId == memberId);
        if (index != -1) {
          todoBillModel.value!.billDetails.paidUsers.add(todoBillModel.value!.billDetails.pendingUsers.removeAt(index));
        }
        return true;
      }

    payingLoader.value = true;
    return false;
  }
}
