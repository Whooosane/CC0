import 'dart:io';
import 'package:circleapp/controller/getx_controllers/todo_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/models/loop_models/todo_models/todo_bill_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
class ToDoBillDetailScreen extends StatefulWidget {
  final String circleId;
  final String todoId;
  final String todoTitle;
  final String todoDescription;
  final List<File> images;

  const ToDoBillDetailScreen(
      {super.key, required this.todoId, required this.todoTitle, required this.todoDescription, required this.images, required this.circleId});

  @override
  State<ToDoBillDetailScreen> createState() => _ToDoBillDetailScreenState();
}

class _ToDoBillDetailScreenState extends State<ToDoBillDetailScreen> {
  late TodosController todosController;
  int selectedIndex = -1;

  @override
  void initState() {
    todosController = Get.put(TodosController(context));
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        todosController.getTodoBill(load: true, todoId: widget.todoId);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
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
                    todosController.loading.value
                        ? Shimmer.fromColors(
                            baseColor: AppColors.shimmerColor1,
                            highlightColor: AppColors.shimmerColor2,
                            child: Container(
                              height: 20.px,
                              width: MediaQuery.sizeOf(context).width / 2,
                              margin: EdgeInsets.symmetric(horizontal: 1.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.px),
                                color: AppColors.textFieldColor,
                              ),
                            ))
                        : Text(
                            ' details',
                            style: CustomTextStyle.headingStyle,
                          ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
                getVerticalSpace(2.h),
                todosController.loading.value
                    ? Shimmer.fromColors(
                    baseColor: AppColors.shimmerColor1,
                    highlightColor: AppColors.shimmerColor2,
                    child: Container(
                      height: 40.px,
                      margin: EdgeInsets.symmetric(vertical: .5.h),
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.px),
                        color: AppColors.textFieldColor,
                      ),
                    ))
                    : Container(
                  margin: EdgeInsets.symmetric(vertical: .5.h),
                  padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 10.px),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.px), color: AppColors.textFieldColor),
                  child: Row(
                    children: [
                      Text(
                        "Total Bill",
                        style: CustomTextStyle.headingStyle2,
                      ),
                      const Expanded(child: SizedBox()),
                      Text(
                        '${todosController.todoBillModel.value?.billDetails.totalBillAmount.toString()}\$',
                        style: CustomTextStyle.smallText.copyWith(
                          color: const Color(0xffF8F8F8),
                        ),
                      ),
                    ],
                  ),
                ),
                todosController.loading.value
                    ? Shimmer.fromColors(
                    baseColor: AppColors.shimmerColor1,
                    highlightColor: AppColors.shimmerColor2,
                    child: Container(
                      height: 40.px,
                      margin: EdgeInsets.symmetric(vertical: .5.h),
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.px),
                        color: AppColors.textFieldColor,
                      ),
                    ))
                    : Container(
                  margin: EdgeInsets.symmetric(vertical: .5.h),
                  padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 10.px),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.px), color: AppColors.textFieldColor),
                  child: Row(
                    children: [
                      Text(
                        "Paid",
                        style: CustomTextStyle.headingStyle2,
                      ),
                      const Expanded(child: SizedBox()),
                      Text(
                        todosController.todoBillModel.value!.billDetails.totalPaid.toString(),
                        style: CustomTextStyle.smallText.copyWith(
                          color: const Color(0xff79F966),
                        ),
                      ),
                    ],
                  ),
                ),
                todosController.loading.value
                    ? Shimmer.fromColors(
                    baseColor: AppColors.shimmerColor1,
                    highlightColor: AppColors.shimmerColor2,
                    child: Container(
                      height: 40.px,
                      margin: EdgeInsets.symmetric(vertical: .5.h),
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.px),
                        color: AppColors.textFieldColor,
                      ),
                    ))
                    : Container(
                  margin: EdgeInsets.symmetric(vertical: .5.h),
                  padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 10.px),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.px), color: AppColors.textFieldColor),
                  child: Row(
                    children: [
                      Text(
                        "Pending",
                        style: CustomTextStyle.headingStyle2,
                      ),
                      const Expanded(child: SizedBox()),
                      Text(todosController.todoBillModel.value!.billDetails.totalPending.toString(),
                          style: CustomTextStyle.smallText.copyWith(color: const Color(0xffFF881A))),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    if (!todosController.loading.value) ...[
                      if (todosController.todoBillModel.value!.billDetails.pendingUsers.isNotEmpty) ...[
                        getVerticalSpace(2.3.h),
                        Text(
                          'Pending Amount',
                          style: CustomTextStyle.headingStyle.copyWith(color: Colors.white),
                        ),
                        getVerticalSpace(1.h),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: todosController.todoBillModel.value!.billDetails.pendingUsers.length,
                          itemBuilder: (context, index) {
                            AllMember pendingMember = todosController.todoBillModel.value!.billDetails.pendingUsers[index];
                            return Obx(() {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: .5.h),
                                padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 7.px),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(13.px), color: AppColors.textFieldColor),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 2.4.h,
                                      backgroundColor: AppColors.mainColorBackground,
                                      backgroundImage: NetworkImage(pendingMember.profilePicture),
                                    ),
                                    getHorizentalSpace(.81.h),
                                    Expanded(
                                      child: RichText(
                                          text: TextSpan( children: [
                                            TextSpan(text: '${pendingMember.name}’s', style: CustomTextStyle.buttonText.copyWith(color: Colors.white)),
                                            TextSpan(
                                                text: ' ${todosController.todoBillModel.value!.billDetails.payablePerUser}\$',
                                                style: CustomTextStyle.buttonText.copyWith(color: const Color(0xffFF881A))),
                                            TextSpan(text: ' are pending', style: CustomTextStyle.buttonText.copyWith(color: Colors.white)),
                                          ])),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        selectedIndex = index;
                                        await todosController.payBill(
                                            load: true, circleId: widget.circleId, todoId: widget.todoId, memberId: pendingMember.memberId).then((value){
                                              if(value)
                                                {
                                                  todosController.getTodoBill(load: true, todoId: widget.todoId);
                                                }
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(horizontal: 1.5.h, vertical: .4.h),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.px),
                                            color: todosController.payingLoader.value && index == selectedIndex
                                                ? const Color(0xff00B332).withOpacity(0.5)
                                                : const Color(0xff00B332)),
                                        child: todosController.payingLoader.value && index == selectedIndex
                                            ? LoadingAnimationWidget.progressiveDots(color: Colors.white, size: 16)
                                            : Text(
                                          'Pay',
                                          style: CustomTextStyle.buttonText.copyWith(
                                              color: todosController.payingLoader.value && index == selectedIndex
                                                  ? Colors.white.withOpacity(0.5)
                                                  : Colors.white,
                                              fontSize: 10.px),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                          },
                        ),
                      ],
                      if (todosController.todoBillModel.value!.billDetails.paidUsers.isNotEmpty) ...[
                        getVerticalSpace(2.h),
                        Text(
                          'Paid Amount',
                          style: CustomTextStyle.headingStyle.copyWith(color: Colors.white),
                        ),
                        getVerticalSpace(1.h),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: todosController.todoBillModel.value!.billDetails.paidUsers.length,
                          itemBuilder: (context, index) {
                            AllMember paidMember = todosController.todoBillModel.value!.billDetails.paidUsers[index];
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: .5.h),
                              padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 7.px),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(13.px), color: AppColors.textFieldColor),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 2.4.h,
                                    backgroundColor: AppColors.mainColorBackground,
                                    backgroundImage: NetworkImage(paidMember.profilePicture),
                                  ),
                                  getHorizentalSpace(.81.h),
                                  Text('${paidMember.name} paid ${todosController.todoBillModel.value!.billDetails.payablePerUser}\$',
                                      style: CustomTextStyle.buttonText.copyWith(color: Colors.white)),
                                  const Expanded(child: SizedBox()),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(horizontal: 1.5.h, vertical: .4.h),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.px), color: const Color(0xff00B332).withOpacity(0.5)),
                                    child: Text(
                                      'Pay',
                                      style: CustomTextStyle.buttonText.copyWith(color: Colors.white.withOpacity(0.5), fontSize: 10.px),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                      if (todosController.todoBillModel.value!.billDetails.allMembers.isNotEmpty) ...[
                        getVerticalSpace(2.h),
                        Text(
                          'Added person',
                          style: CustomTextStyle.headingStyle.copyWith(color: Colors.white),
                        ),
                        getVerticalSpace(1.h),
                        SizedBox(
                          height: 4.h,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: todosController.todoBillModel.value!.billDetails.allMembers.length,
                            itemExtent: 5.h,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: .3.h),
                                decoration: BoxDecoration(border: Border.all(color: AppColors.secondaryColor), shape: BoxShape.circle),
                                child: CircleAvatar(
                                  radius: 10.h,
                                  backgroundColor: AppColors.mainColor,
                                  backgroundImage: NetworkImage(todosController.todoBillModel.value!.billDetails.allMembers[index].profilePicture),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                    if (todosController.loading.value) ...[
                      getVerticalSpace(2.3.h),
                      Text(
                        'Pending Amount',
                        style: CustomTextStyle.headingStyle.copyWith(color: Colors.white),
                      ),
                      getVerticalSpace(1.h),
                      Shimmer.fromColors(
                          baseColor: AppColors.shimmerColor1,
                          highlightColor: AppColors.shimmerColor2,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: 3,
                            itemExtent: 6.h,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: .5.h),
                                padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 7.px),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.px),
                                  color: AppColors.textFieldColor,
                                ),
                              );
                            },
                          )),
                      getVerticalSpace(2.3.h),
                      Text(
                        'Pending Amount',
                        style: CustomTextStyle.headingStyle.copyWith(color: Colors.white),
                      ),
                      getVerticalSpace(1.h),
                      Shimmer.fromColors(
                          baseColor: AppColors.shimmerColor1,
                          highlightColor: AppColors.shimmerColor2,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: 3,
                            itemExtent: 6.h,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: .5.h),
                                padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 7.px),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.px),
                                  color: AppColors.textFieldColor,
                                ),
                              );
                            },
                          )),
                      getVerticalSpace(2.h),
                      Text(
                        'Added person',
                        style: CustomTextStyle.headingStyle.copyWith(color: Colors.white),
                      ),
                      getVerticalSpace(1.h),
                      SizedBox(
                        height: 4.h,
                        child: Shimmer.fromColors(
                            baseColor: AppColors.shimmerColor1,
                            highlightColor: AppColors.shimmerColor2,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemExtent: 5.h,
                              itemBuilder: (context, index) {
                                return Container(
                                  alignment: Alignment.bottomCenter,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.shimmerColor1),
                                );
                              },
                            )),
                      )
                    ],
                    getVerticalSpace(2.h),
                    Text(
                      'Bill receipt',
                      style: CustomTextStyle.headingStyle.copyWith(color: Colors.white),
                    ),
                    getVerticalSpace(1.h),
                    if (!todosController.loading.value) ...[
                      SizedBox(
                        height: 4.h,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: todosController.todoBillModel.value!.billDetails.billReceiptImages.length,
                          itemExtent: 5.h,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: .5.h),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.px),
                                  color: AppColors.textFieldColor,
                                  image: DecorationImage(
                                      image: NetworkImage(todosController.todoBillModel.value!.billDetails.billReceiptImages[index]), fit: BoxFit.cover),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ],),),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
