import 'package:circleapp/controller/getx_controllers/todo_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../models/loop_models/todo_models/todo_details_model.dart';
import '../../../custom_widget/customwidgets.dart';

class TodoDetailsScreen extends StatefulWidget {
  final String circleId;
  final String todoId;

  const TodoDetailsScreen({super.key, required this.circleId, required this.todoId});

  @override
  State<TodoDetailsScreen> createState() => _TodoDetailsScreenState();
}

class _TodoDetailsScreenState extends State<TodoDetailsScreen> {
  late TodosController todosController;

  @override
  void initState() {
    todosController = Get.put(TodosController(context));
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await todosController.getTodoById(load: true, circleId: widget.circleId, todoId: widget.todoId);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.mainColorBackground,
        body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getVerticalSpace(6.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 2.h,
                            ),
                          ),
                        ),
                        getHorizentalSpace(1.5.h),
                        Text(
                          "${todosController.todoDetailModel.value!.todo.title} details",
                          style: CustomTextStyle.headingStyle,
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                    getVerticalSpace(3.3.h),
                    todosController.loading.value
                        ? Shimmer.fromColors(
                        baseColor: AppColors.shimmerColor1,
                        highlightColor: AppColors.shimmerColor2,
                        child: Container(
                          height: 20.px,
                          width: MediaQuery.sizeOf(context).width,
                          margin: EdgeInsets.symmetric(horizontal: 1.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.px),
                            color: AppColors.textFieldColor,
                          ),
                        ))
                        : RichText(
                      text: TextSpan(children: [
                        TextSpan(text: 'Title: ', style: CustomTextStyle.buttonText.copyWith(color: Colors.white, fontSize: 12.px)),
                        TextSpan(
                            text: todosController.todoDetailModel.value!.todo.title,
                            style: CustomTextStyle.buttonText.copyWith(color: Colors.white, fontSize: 12.px)),
                      ]),
                    ),
                    getVerticalSpace(1.2.h),
                    todosController.loading.value
                        ? Shimmer.fromColors(
                        baseColor: AppColors.shimmerColor1,
                        highlightColor: AppColors.shimmerColor2,
                        child: Container(
                          height: 20.px,
                          width: MediaQuery.sizeOf(context).width,
                          margin: EdgeInsets.symmetric(horizontal: 1.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.px),
                            color: AppColors.textFieldColor,
                          ),
                        ))
                        : Text(
                      todosController.todoDetailModel.value!.todo.description,
                      style: CustomTextStyle.hintText,
                    ),
                    getVerticalSpace(1.2.h),
                    Text(
                      'Images',
                      style: CustomTextStyle.headingStyle.copyWith(color: Colors.white),
                    ),
                    getVerticalSpace(1.h),
                    SizedBox(
                      height: 8.h,
                      width: MediaQuery.of(context).size.width - 2.3.h,
                      child: todosController.loading.value
                          ? Shimmer.fromColors(
                              baseColor: AppColors.shimmerColor1,
                              highlightColor: AppColors.shimmerColor2,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemExtent: 10.h,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 1.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.px),
                                      color: AppColors.textFieldColor,
                                    ),
                                  );
                                },
                              ))
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: todosController.todoDetailModel.value!.todo.images.length,
                              itemExtent: 10.6.h,
                              itemBuilder: (context, index) {
                                String image = todosController.todoDetailModel.value!.todo.images[index];
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 1.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.px),
                                      color: AppColors.textFieldColor,
                                      image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
                                );
                              },
                            ),
                    ),
                    getVerticalSpace(4.7.h),
                    Text(
                      'Added person',
                      style: CustomTextStyle.headingStyle.copyWith(color: Colors.white),
                    ),
                    getVerticalSpace(1.h),
                    SizedBox(
                      height: 4.h,
                      child: todosController.loading.value
                          ? Shimmer.fromColors(
                              baseColor: AppColors.shimmerColor1,
                              highlightColor: AppColors.shimmerColor2,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: 6,
                                itemExtent: 5.h,
                                itemBuilder: (context, index) {
                                  return Container(
                                    alignment: Alignment.bottomCenter,
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                  );
                                },
                              ))
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: todosController.todoDetailModel.value!.todo.members.length,
                              itemExtent: 5.h,
                              itemBuilder: (context, index) {
                                Member member = todosController.todoDetailModel.value!.todo.members[index];
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: .3.h),
                                  decoration: BoxDecoration(border: Border.all(color: AppColors.secondaryColor), shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(member.profilePicture))),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
