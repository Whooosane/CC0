import 'dart:io';
import 'package:circleapp/controller/api/auth_apis.dart';
import 'package:circleapp/controller/getx_controllers/circle_controller.dart';
import 'package:circleapp/controller/getx_controllers/picker_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/controller/utils/global_variables.dart';
import 'package:circleapp/controller/utils/preference_keys.dart';
import 'package:circleapp/controller/utils/shared_preferences.dart';
import 'package:circleapp/view/custom_widget/custom-button.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'loop_screens/createCircleScreen.dart';

class ChooseImage extends StatefulWidget {
  const ChooseImage({super.key});

  @override
  State<ChooseImage> createState() => _ChooseImageState();
}

class _ChooseImageState extends State<ChooseImage> {
  late CircleController controller;
  late AuthApis authApis;
  final backButton = false.obs;
  final nextButton = true.obs;

  @override
  void initState() {
    super.initState();
    userToken = MySharedPreferences.getString(userTokenKey);
    controller = Get.put(CircleController(context));
    authApis = AuthApis(context);
  }

  @override
  Widget build(BuildContext context) {
    final pickerController = Get.put(PickerController());
    return Scaffold(
      backgroundColor: AppColors.mainColorBackground,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.h),
        child: Obx(
              () => Column(
            children: [
              SizedBox(height: 11.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 2.h),
                  ),
                  const Spacer(),
                  Text("Select Circle Image", style: CustomTextStyle.mediumTextL),
                  const Spacer(),
                ],
              ),
              SizedBox(height: pickerController.pickedImage.value != null ? 4.h : 14.h),
              pickerController.pickedImage.value != null &&
                  File(pickerController.pickedImage.value!.path).existsSync()
                  ? Container(
                height: 46.6.h,
                decoration: BoxDecoration(
                  color: AppColors.textFieldColor,
                  borderRadius: BorderRadius.circular(20.px),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.px),
                  child: Image.file(
                    File(pickerController.pickedImage.value!.path),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          'Failed to load image',
                          style: TextStyle(color: Colors.red, fontSize: 16.sp),
                        ),
                      );
                    },
                  ),
                ),
              )
                  : Image.asset("assets/png/chooseImage.png"),
              SizedBox(height: 6.h),
              pickerController.pickedImage.value != null
                  ? Obx(
                    () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: 3.h),
                    Expanded(
                      child: customButton(
                        onTap: () {
                          if (!controller.loading.value) {
                            pickerController.pickedImage.value = null;
                          }
                        },
                        backgroundColor:
                        backButton.value ? AppColors.secondaryColor : AppColors.primaryColor,
                        borderColor:
                        backButton.value ? AppColors.primaryColor : AppColors.secondaryColor,
                        title: 'Back',
                        titleColor: backButton.value ? Colors.black : Colors.white,
                        width: 16.2.h,
                        height: 4.5.h,
                      ),
                    ),
                    SizedBox(width: 1.h),
                    Expanded(
                      child: customLoadingButton(
                        onTap: () {
                          if (pickerController.pickedImage.value == null ||
                              !File(pickerController.pickedImage.value!.path).existsSync()) {
                            customScaffoldMessenger("Please select a valid image");
                          } else {
                            Get.to(
                                CreateCircle(imageUrl: pickerController.pickedImage.value!.path));
                          }
                        },
                        backgroundColor:
                        nextButton.value ? AppColors.secondaryColor : AppColors.primaryColor,
                        borderColor:
                        nextButton.value ? AppColors.primaryColor : AppColors.secondaryColor,
                        title: 'Next',
                        titleColor: nextButton.value ? Colors.black : Colors.white,
                        width: 16.2.h,
                        height: 4.5.h,
                        loading: controller.loading,
                      ),
                    ),
                    SizedBox(width: 3.h),
                  ],
                ),
              )
                  : CustomButton(
                buttonText: "Choose Image",
                buttonColor: AppColors.mainColorYellow,
                onPressed: pickerController.pickImage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}