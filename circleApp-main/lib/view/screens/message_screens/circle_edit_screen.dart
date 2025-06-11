import 'dart:io';

import 'package:circleapp/controller/getx_controllers/circle_controller.dart';
import 'package:circleapp/controller/utils/style/customTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/getx_controllers/picker_controller.dart';
import '../../../controller/utils/app_colors.dart';
import '../../custom_widget/customwidgets.dart';

class CircleEditScreen extends StatefulWidget {
  final CircleController circleController;

  const CircleEditScreen({super.key, required this.circleController});

  @override
  State<CircleEditScreen> createState() => _CircleEditScreenState();
}

class _CircleEditScreenState extends State<CircleEditScreen> {
  late CircleController circleController;
  final PickerController imagePickerController = Get.put(PickerController());
  TextEditingController circleNameController = TextEditingController();
  Rxn<File?> updatedImage = Rxn<File?>();

  @override
  void initState() {
    circleNameController.text = widget.circleController.circleDetailsModel.value!.circle.circleName;
    circleController = Get.put(CircleController(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return Scaffold(
          backgroundColor: AppColors.mainColorBackground,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getVerticalSpace(8.h),
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
                          size: 20.px,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Edit Circle',
                      style: CustomTextStyle.headingStyle,
                    ),
                    const Spacer(),
                  ],
                ),
                getVerticalSpace(3.h),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      imagePickerController.pickImageWithFile(updatedImage);
                    },
                    child: Stack(
                      children: [
                        updatedImage.value != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(
                                  updatedImage.value!,
                                ),
                                radius: 60,
                              )
                            : CircleAvatar(
                                    backgroundImage: NetworkImage(widget.circleController.circleDetailsModel.value!.circle.circleImage),
                                    radius: 60,
                                  ),
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: AppColors.mainColorBackground),
                            child: Transform.scale(
                                scale: 0.6,
                                child: SvgPicture.asset(
                                  "assets/svg/profileCamera.svg",
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                getVerticalSpace(3.h),
                Text(
                  "Circle name",
                  style: CustomTextStyle.mediumTextS1,
                ),
                getVerticalSpace(1.h),
                TextFormField(
                  style: TextStyle(color: Colors.white, fontSize: 12.px),
                  controller: circleNameController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.textFieldColor,
                      contentPadding: const EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: AppColors.textFieldColor,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: AppColors.textFieldColor,
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: AppColors.textFieldColor,
                          ))),
                ),
                const Spacer(),
                customLoadingButton(
                    loading: circleController.loading,
                    onTap: () async {
                      if (updatedImage.value != null) {
                        String url = await circleController.uploadCircleImage(updatedImage.value!) ?? "";
                        circleController.circleDetailsModel.value!.circle.circleImage = url;
                      }

                      await circleController
                          .updateCircle(
                              load: true,
                              circleId: circleController.circleDetailsModel.value!.circle.id,
                              circleName: circleNameController.text,
                              circleImage: circleController.circleDetailsModel.value!.circle.circleImage)
                          .then(
                        (value) {
                          if (value) {
                            circleController.circleDetailsModel.value!.circle.circleName = circleNameController.text;
                            Get.back();
                          }
                        },
                      );
                    },
                    backgroundColor: AppColors.secondaryColor,
                    borderColor: AppColors.primaryColor,
                    title: 'Done',
                    titleColor: Colors.black,
                    height: 4.5.h),
                getVerticalSpace(30.px),
              ],
            ),
          ),
        );
      }
    );
  }
}
