import 'package:circleapp/controller/getx_controllers/auth_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/controller/utils/validation.dart';
import 'package:circleapp/view/custom_widget/custom_loading_button.dart';
import 'package:circleapp/view/custom_widget/custom_text_field.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late AuthController authController;
  RxBool hidePassword = false.obs;

  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColorBackground,
      body: Obx(() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 9.h),
              Image.asset("assets/png/loginScreen.png", height: 272.px, width: 272.px),
              SizedBox(height: 5.h),
              Text("Create Account", style: CustomTextStyle.mediumTextL),
              SizedBox(height: 0.8.h),
              Text("Please enter the required details", style: CustomTextStyle.mediumTextS1),
              SizedBox(height: 4.h),
              _buildTextField(
                label: "Name",
                controller: authController.userNameTextController,
                hint: "Lita han",
                icon: "assets/svg/profile.svg",
              ),
              SizedBox(height: 2.5.h),
              _buildTextField(
                label: "Email",
                controller: authController.emailTextController,
                hint: "Litahan12@gmail.com",
                icon: "assets/svg/email.svg",
              ),
              SizedBox(height: 2.5.h),
              _buildTextField(
                label: "Mobile Number",
                controller: authController.phoneNumberController,
                hint: "+00 123321 456",
                icon: "assets/svg/Mobile.svg",
                phoneKeyboard: true,
              ),
              SizedBox(height: 2.5.h),
              _buildTextField(
                label: "Password",
                controller: authController.passwordTextController,
                hint: "**********",
                icon: "assets/svg/lock.svg",
                obscure: hidePassword.value,
                suffix: GestureDetector(
                  onTap: () => hidePassword.value = !hidePassword.value,
                  child: SvgPicture.asset("assets/svg/closeEye.svg"),
                ),
              ),
              SizedBox(height: 4.h),
              CustomLoadingButton(
                buttonText: "Sign Up",
                buttonColor: AppColors.mainColorYellow,
                loading: authController.isLoading,
                onPressed: () {
                  if (!authController.isLoading.value) {
                    final error = Validations.handleSingUpScreenError(
                      userNameTextController: authController.userNameTextController,
                      emailTextController: authController.emailTextController,
                      passwordTextController: authController.passwordTextController,
                      mobileNumberTextController: authController.phoneNumberController,
                    );
                    if (error.isNotEmpty) {
                      customScaffoldMessenger(error);
                    } else {
                      authController.signup(
                        load: true,
                        userName: authController.userNameTextController.text,
                        email: authController.emailTextController.text,
                        phoneNumber: authController.phoneNumberController.text,
                        password: authController.passwordTextController.text,
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?", style: CustomTextStyle.mediumTextBS),
                  SizedBox(width: 0.5.h),
                  InkWell(
                    onTap: Get.back,
                    child: Text("Log In", style: CustomTextStyle.mediumTextS1),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required String icon,
    bool obscure = false,
    bool phoneKeyboard = false,
    Widget? suffix,
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
          obscureText: obscure,
          phoneKeyboard: phoneKeyboard,
          prefixIcon: SvgPicture.asset(icon),
          suffixIcon: suffix,
        ),
      ],
    );
  }
}