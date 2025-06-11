import 'package:circleapp/controller/getx_controllers/todo_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/models/all_todo_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:circleapp/view/screens/loop_screens/todos/todo_bill_detail_screen.dart';
import 'package:circleapp/view/screens/loop_screens/todos/todo_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'create_new_todos_screen.dart';

Widget toDosWidget({required String circleId, required TodosController todosController}) {
  return todosController.loading.value
      ? Expanded(
          child: Shimmer.fromColors(
              baseColor: AppColors.shimmerColor1,
              highlightColor: AppColors.shimmerColor2,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.3.h),
                    alignment: Alignment.bottomCenter,
                    height: 15.h,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(20.px),
                    ),
                  );
                },
              )),
        )
      : todosController.allTodosModel.value?.todos.isEmpty ?? true
      ? Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      getVerticalSpace(16.h),
      Icon(
        Icons.task,
        size: 12.h,
        color: AppColors.secondaryColor,
      ),
      SizedBox(height: 2.h),
      Text(
        'No To-Dos Yet',
        style: CustomTextStyle.headingStyle.copyWith(color: Colors.white),
      ),
      SizedBox(height: 1.h),
      Text(
        'Add tasks to keep your circle organized and on track!',
        style: CustomTextStyle.hintText.copyWith(color: const Color(0xffF8F8F8)),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 3.h),
      GestureDetector(
        onTap: () => Get.to(CreateNewToDo(circleId: circleId)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 1.5.h),
          decoration: BoxDecoration(
            color: AppColors.textFieldColor,
            borderRadius: BorderRadius.circular(30.px),
          ),
          child: Text(
            'Add New To-Do',
            style: CustomTextStyle.smallText.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  )
      : Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: todosController.allTodosModel.value?.todos.length,
                itemBuilder: (context, index) {
                  bool isBill = todosController.allTodosModel.value!.todos[index].totalBill != 0;
                  Todo todoItem = todosController.allTodosModel.value!.todos[index];
                  return GestureDetector(
                    onTap: () {
                      if (isBill) {
                        Get.to(() => ToDoBillDetailScreen(
                              todoId: todoItem.id,
                              todoTitle: todoItem.title,
                              todoDescription: "Description",
                              images: const [],
                              circleId: circleId,
                            ));
                      } else {
                        Get.to(() => TodoDetailsScreen(circleId: circleId, todoId: todoItem.id));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.3.h),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 1.9.h, vertical: 1.4.h),
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(20.px),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Text(
                                todoItem.title,
                                style: CustomTextStyle.headingStyle,
                              ),
                              const Expanded(child: SizedBox()),
                              if (isBill) ...[
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Total Bill: ',
                                      style: CustomTextStyle.smallText.copyWith(color: const Color(0xffFFFFFF).withOpacity(0.48))),
                                  TextSpan(text: '\$${todoItem.totalBill}', style: CustomTextStyle.smallText),
                                ]))
                              ],
                            ],
                          ),
                          getVerticalSpace(.6.h),
                          if (isBill) ...[
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(text: 'Status: ', style: CustomTextStyle.smallText.copyWith(color: const Color(0xffFFFFFF).withOpacity(0.48))),
                              TextSpan(text: todoItem.billStatus, style: CustomTextStyle.smallText.copyWith(color: AppColors.secondaryColor)),
                            ])),
                            getVerticalSpace(.6.h),
                            Text(
                              'Splitting Bill',
                              style: CustomTextStyle.buttonText,
                            ),
                          ] else ...[
                            Text("Plan Members", style: CustomTextStyle.smallText.copyWith(color: const Color(0xffFFFFFF).withOpacity(0.48))),
                          ],
                          getVerticalSpace(.6.h),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 3.5.h,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: todoItem.members.length,
                                    itemExtent: 4.h,
                                    itemBuilder: (context, index) {
                                      Member memberItem = todoItem.members[index];
                                      return Container(
                                        padding: EdgeInsets.symmetric(horizontal: .3.h),
                                        decoration: BoxDecoration(border: Border.all(color: AppColors.secondaryColor), shape: BoxShape.circle),
                                        child: CircleAvatar(
                                          radius: 5.6.h,
                                          backgroundColor: AppColors.mainColor,
                                          backgroundImage: memberItem.profilePicture != ""
                                              ? NetworkImage(memberItem.profilePicture)
                                              : const AssetImage('assets/png/userplacholder.png') as ImageProvider,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              customTextButton2()
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
}
