import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/utils/app_colors.dart';
import '../../custom_widget/customwidgets.dart';
import 'createCircleScreen.dart';

class ShowImage extends StatelessWidget {
  const ShowImage({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool backButton = false.obs;
    RxBool nextButton = true.obs;
    return Scaffold(
      backgroundColor: AppColors.mainColorBackground,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.h),
        child: Column(
          children: [
            SizedBox(
              height: 11.h,
            ),
            Center(
                child: Text(
              "Select your picture",
              style: CustomTextStyle.mediumTextL,
            )),
            SizedBox(
              height: 4.h,
            ),
            Container(
              height: 35.6.h,
              decoration: BoxDecoration(
                  color: AppColors.textFieldColor,
                  borderRadius: BorderRadius.circular(
                    10.px,
                  ),
                  image: const DecorationImage(
                      image: AssetImage(
                        'assets/png/image.png',
                      ),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              height: 6.h,
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  getHorizentalSpace(3.h),
                  Expanded(
                    child: customButton(
                        onTap: () {
                          if (backButton.value == false) {
                            backButton.value = true;
                            nextButton.value = false;
                          } else {
                            backButton.value = false;
                            nextButton.value = true;
                          }
                          Get.back();
                        },
                        backgroundColor: backButton.value == true ? AppColors.secondaryColor : AppColors.primaryColor,
                        borderColor: backButton.value == true ? AppColors.primaryColor : AppColors.secondaryColor,
                        title: 'Back',
                        titleColor: backButton.value == true ? Colors.black : Colors.white,
                        width: 16.2.h,
                        height: 4.5.h),
                  ),
                  getHorizentalSpace(1.h),
                  Expanded(
                    child: customButton(
                        onTap: () {
                          if (nextButton.value == false) {
                            nextButton.value = true;
                            backButton.value = false;
                          } else {
                            nextButton.value = false;
                            backButton.value = true;
                          }
                          Get.to(const CreateCircle());
                        },
                        backgroundColor: nextButton.value == true ? AppColors.secondaryColor : AppColors.primaryColor,
                        borderColor: nextButton.value == true ? AppColors.primaryColor : AppColors.secondaryColor,
                        title: 'Next',
                        titleColor: nextButton.value == true ? Colors.black : Colors.white,
                        width: 16.2.h,
                        height: 4.5.h),
                  ),
                  getHorizentalSpace(3.h)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
