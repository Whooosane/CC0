import 'dart:developer';
import 'package:circleapp/controller/getx_controllers/circle_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'circleInterestScreen.dart';
class CreateCircle extends StatefulWidget {
  final String? imageUrl;
  const CreateCircle({super.key,this.imageUrl});

  @override
  State<CreateCircle> createState() => _CreateCircleState();
}

class _CreateCircleState extends State<CreateCircle> {
  late CircleController controller;
  final selectedIndex = 0.obs;
  final backButton = false.obs;
  final nextButton = true.obs;
  final circleName = ['Friend', 'Family', 'Organization', 'Mix'].obs;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CircleController(context));
    log("Get.arguments['imageUrl'] :${widget.imageUrl}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        title: Text('Create Circle', style: CustomTextStyle.headingStyle),
        leading: Padding(
          padding: EdgeInsets.only(left: 1.5.h),
          child: GestureDetector(
            onTap: Get.back,
            child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 2.h),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Circle name', style: CustomTextStyle.smallText),
            SizedBox(height: .8.h),
            customTextFormField(controller.circleNameTextController, 'Hiking Plan', isObsecure: false),
            SizedBox(height: 1.h),
            Text('Description', style: CustomTextStyle.smallText),
            SizedBox(height: .8.h),
            customTextFormField(
              controller.circleDescriptionTextController,
              'Lorem ipsum dolor sit amet...',
              isObsecure: false,
              maxLine: 5,
              borderRadius: BorderRadius.circular(30.px),
            ),
            SizedBox(height: 2.5.h),
            Text('Type of circle', style: CustomTextStyle.headingStyle),
            SizedBox(height: .6.h),
            GridView.builder(
              itemCount: 4,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2.h,
                mainAxisSpacing: 1.4.h,
                childAspectRatio: 4,
              ),
              itemBuilder: (context, index) => Obx(
                    () => GestureDetector(
                  onTap: () => selectedIndex.value = index,
                  child: customRadioButton(
                    title: circleName[index],
                    borderColor: selectedIndex.value == index ? AppColors.textFieldColor : AppColors.secondaryColor,
                    assetsImage: SvgPicture.asset(selectedIndex.value == index ? 'assets/svg/selected.svg' : 'assets/svg/unselected.svg'),
                  ),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Obx(
                  () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(width: 3.h),
                  Expanded(
                    child: customButton(
                      onTap: () {
                        backButton.toggle();
                        nextButton.value = !backButton.value;
                        Get.back();
                      },
                      backgroundColor: backButton.value ? AppColors.secondaryColor : AppColors.primaryColor,
                      borderColor: backButton.value ? AppColors.primaryColor : AppColors.secondaryColor,
                      title: 'Back',
                      titleColor: backButton.value ? Colors.black : Colors.white,
                      width: 16.2.h,
                      height: 4.5.h,
                    ),
                  ),
                  SizedBox(width: 1.h),
                  Expanded(
                    child: customButton(
                      onTap: () async {

                        if (controller.circleNameTextController.text.isEmpty) {
                          customScaffoldMessenger('please enter the circle name');
                        } else if (controller.circleDescriptionTextController.text.isEmpty) {
                          customScaffoldMessenger('please enter the circle description');
                        } else {
                          // Check if Get.arguments is not null before accessing
                          if (Get.arguments != null) {
                                    } else {
                            print("No arguments passed to CreateCircle");
                          }

                          Get.to(const CircleInterest(), arguments: {
                            'text': controller.circleNameTextController.text,
                            'description': controller.circleDescriptionTextController.text,
                            'type': circleName[selectedIndex.value],
                            'imageUrl': widget.imageUrl,
                          });}

                      },
                      backgroundColor: nextButton.value ? AppColors.secondaryColor : AppColors.primaryColor,
                      borderColor: nextButton.value ? AppColors.primaryColor : AppColors.secondaryColor,
                      title: 'Next',
                      titleColor: nextButton.value ? Colors.black : Colors.white,
                      width: 16.2.h,
                      height: 4.5.h,
                    ),
                  ),
                  SizedBox(width: 3.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}