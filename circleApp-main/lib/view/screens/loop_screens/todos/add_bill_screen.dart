import 'dart:io';

import 'package:circleapp/controller/getx_controllers/picker_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/models/add_bill_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../custom_widget/customwidgets.dart';

class AddBills extends StatefulWidget {
  const AddBills({super.key});

  @override
  State<AddBills> createState() => _AddBillsState();
}

class _AddBillsState extends State<AddBills> {
  RxList<File?> todoImages = <File>[].obs;
  late PickerController pickerController;
  TextEditingController titleTextController = TextEditingController();
  TextEditingController billTextController = TextEditingController();

  @override
  void initState() {
    pickerController = Get.put(PickerController());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              getVerticalSpace(6.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.5.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 2.h,
                        ),
                      ),
                    ),
                    getHorizentalSpace(1.5.h),
                    Text(
                      'Add Bill',
                      style: CustomTextStyle.headingStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getVerticalSpace(3.h),
                    Text(
                      'Title',
                      style: CustomTextStyle.smallText.copyWith(color: Colors.white),
                    ),
                    getVerticalSpace(.4.h),
                    customTextFormField(titleTextController, 'Winter trip Plan', isObsecure: false),
                    getVerticalSpace(3.h),
                    Text(
                      'Total Bill (\$)',
                      style: CustomTextStyle.smallText.copyWith(color: Colors.white),
                    ),
                    getVerticalSpace(.4.h),
                    customTextFormField(
                      billTextController,
                      '2500',
                      isObsecure: false,
                    ),
                    getVerticalSpace(3.h),
                    Text('Upload bill receipt', style: CustomTextStyle.headingStyle),
                    getVerticalSpace(.6.h),
                    Text('you can add multiple bill receipt.', style: CustomTextStyle.hintText),
                    getVerticalSpace(1.h),
                    GestureDetector(
                        onTap: () async {
                          todoImages.add(await pickerController.pickImage());
                        },
                        child: Image.asset("assets/png/chooseImage.png")),
                    getVerticalSpace(1.5.h),
                    if (todoImages.isNotEmpty) ...[
                      SizedBox(
                        height: 8.2.h,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: todoImages.length,
                          itemExtent: 11.h,
                          itemBuilder: (context, index) {
                            return Obx(
                                  () => Padding(
                                  padding: EdgeInsets.symmetric(horizontal: .3.h),
                                  child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.px), color: AppColors.textFieldColor),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15.px),
                                          child: Image.file(
                                            todoImages[index]!,
                                            fit: BoxFit.cover,
                                          )))),
                            );
                          },
                        ),
                      ),
                    ],
                    getVerticalSpace(6.3.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.5.h),
                      child: customButton(
                          onTap: () {
                            if (titleTextController.text.isEmpty) {
                              customScaffoldMessenger( "Add title");
                            } else if (billTextController.text.isEmpty) {
                              customScaffoldMessenger( "Add bill value");
                            } else if (todoImages.isEmpty) {
                              customScaffoldMessenger( "Add bill receipt");
                            } else {
                              Get.back(result: AddBillsModel(title: titleTextController.text, billAmount: billTextController.text, todoImages: todoImages));
                            }
                          },
                          backgroundColor: AppColors.secondaryColor,
                          borderColor: AppColors.primaryColor,
                          title: 'Done',
                          titleColor: Colors.black,
                          height: 4.5.h),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    );
  }
}