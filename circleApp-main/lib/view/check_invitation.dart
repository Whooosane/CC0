import 'package:circleapp/view/screens/athentications/login_screen.dart';
import 'package:circleapp/view/screens/bottom_navigation_screen.dart';
import 'package:circleapp/view/screens/choose_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../controller/utils/app_colors.dart';
import '../controller/utils/customTextStyle.dart';
import '../controller/utils/preference_keys.dart';
import '../controller/utils/shared_preferences.dart';
import 'custom_widget/customwidgets.dart';

class CheckInvitationScreen extends StatefulWidget {
  const CheckInvitationScreen({super.key});

  @override
  State<CheckInvitationScreen> createState() => _CheckInvitationScreenState();
}

class _CheckInvitationScreenState extends State<CheckInvitationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColorBackground,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.h),
        child: Column(
          children: [
            SizedBox(
              height: 11.h,
            ),
            Image.asset("assets/png/check_invitation_illustration.png"),
            SizedBox(
              height: 6.h,
            ),
            Text(
              "Welcome",
              style: CustomTextStyle.mediumTextL,
            ),
            SizedBox(
              height: 4.h,
            ),
            customButton(
              width: 80.w,
                onTap: () {
                  Get.to(()=> const ChooseImage());
                },
                backgroundColor: AppColors.mainColorYellow,
                borderColor: AppColors.primaryColor,
                title: 'Create New Circle',
                titleColor: Colors.black,
                height: 4.5.h),
            SizedBox(
              height: 1.h,
            ),
            customButton(
                width: 80.w,
                onTap: () {
                  Get.offAll(const BottomNavigationScreen());
                  MySharedPreferences.setBool(isLoggedInKey, true);
                },
                backgroundColor: AppColors.primaryColor,
                borderColor: AppColors.secondaryColor,
                title: 'Skip',
                titleColor: Colors.white,
                height: 4.5.h),
            getHorizentalSpace(15.px),
          ],
        ),
      ),
    );
  }
}
