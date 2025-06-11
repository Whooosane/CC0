import 'dart:developer';
import 'package:circleapp/controller/api/auth_apis.dart';
import 'package:circleapp/controller/getx_controllers/auth_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/controller/utils/validation.dart';
import 'package:circleapp/view/custom_widget/custom_loading_button.dart';
import 'package:circleapp/view/custom_widget/custom_text_field.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ResetPasswordScreen> {
  late AuthController authController;
  late AuthApis authApis;
  final emailTextController = TextEditingController();
  final newPasswordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final otpTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController(context));
    authApis = AuthApis(context);
  }

  @override
  Widget build(BuildContext context) {
    final phoneNumber = Get.arguments['phoneNumber'] as String;
    return Scaffold(
      backgroundColor: AppColors.mainColorBackground,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 9.h),
              Image.asset("assets/png/forgetScreen.png", height: 272.px, width: 272.px),
              SizedBox(height: 5.h),
              Text("Reset Password", style: CustomTextStyle.mediumTextL),
              SizedBox(height: 0.8.h),
              Text("Please enter the required details", style: CustomTextStyle.mediumTextS1),
              SizedBox(height: 4.h),
              _buildOtpField(),
              SizedBox(height: 2.h),
              _buildTextField(
                label: "New Password",
                controller: newPasswordTextController,
                hint: "**********",
                icon: "assets/svg/lock.svg",
              ),
              SizedBox(height: 2.h),
              _buildTextField(
                label: "Confirm Password",
                controller: confirmPasswordTextController,
                hint: "**********",
                icon: "assets/svg/lock.svg",
              ),
              SizedBox(height: 4.h),
              CustomLoadingButton(
                buttonText: "Done",
                buttonColor: AppColors.mainColorYellow,
                loading: authController.isLoading,
                onPressed: () {
                  if (!authController.isLoading.value) {
                    final error = Validations.handleResetPasswordScreenError(
                      otp: otpTextController,
                      password: newPasswordTextController,
                      confirmPassword: confirmPasswordTextController,
                    );
                    if (error.isNotEmpty) {
                      customScaffoldMessenger(error);
                    } else {
                      authController.resetPasswordApi(
                        phoneNumber,
                        otpTextController.text,
                        confirmPasswordTextController.text,
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required String icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontFamily: "medium",
            fontSize: 10.px,
          ),
        ),
        SizedBox(height: 0.4.h),
        CustomTextField(
          controller: controller,
          hintText: hint,
          prefixIcon: SvgPicture.asset(icon),
        ),
      ],
    );
  }

  Widget _buildOtpField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Otp",
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontFamily: "medium",
            fontSize: 12.px,
          ),
        ),
        SizedBox(height: 0.4.h),
        PinCodeTextField(
          appContext: context,
          length: 6,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          cursorColor: Colors.white,
          textStyle: const TextStyle(color: Colors.white),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            fieldHeight: 52,
            fieldWidth: 52,
            inactiveColor: Colors.grey,
            selectedColor: AppColors.secondaryColor,
            activeColor: AppColors.secondaryColor,
            borderWidth: 0,
            activeBorderWidth: 1,
            inactiveBorderWidth: 1,
            selectedBorderWidth: 1,
          ),
          animationDuration: const Duration(milliseconds: 200),
          onCompleted: (v) => otpTextController.text = v,
          onChanged: (value) => log(value),
          beforeTextPaste: (text) {
            log("Allowing to paste $text");
            return true;
          },
        ),
      ],
    );
  }
}