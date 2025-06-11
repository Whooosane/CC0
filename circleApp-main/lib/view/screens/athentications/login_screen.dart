import 'package:circleapp/controller/api/auth_apis.dart';
import 'package:circleapp/controller/getx_controllers/auth_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/controller/utils/validation.dart';
import 'package:circleapp/view/custom_widget/custom_loading_button.dart';
import 'package:circleapp/view/custom_widget/custom_text_field.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:circleapp/view/screens/athentications/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'forget_password.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthController authController;
  late AuthApis authApis;
  RxBool hidePassword = false.obs;

  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController(context));
    authApis = AuthApis(context);
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
              Text("Welcome Back!", style: CustomTextStyle.mediumTextL),
              SizedBox(height: 0.8.h),
              Text("Please enter the required details", style: CustomTextStyle.mediumTextS1),
              SizedBox(height: 4.h),
              _buildTextField(
                label: "Email",
                controller: authController.loginEmailTextController,
                hint: "Litahan12@gmail.com",
                icon: "assets/svg/email.svg",
              ),
              SizedBox(height: 1.5.h),
              _buildTextField(
                label: "Password",
                controller: authController.loginPasswordTextController,
                hint: "**********",
                icon: "assets/svg/lock.svg",
                obscure: hidePassword.value,
                suffix: GestureDetector(
                  onTap: () => hidePassword.value = !hidePassword.value,
                  child: SvgPicture.asset("assets/svg/closeEye.svg"),
                ),
              ),
              SizedBox(height: 0.5.h),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Get.to(() => const ForgetScreen()),
                  child: Text("Forgot Password?", style: CustomTextStyle.mediumTextS1),
                ),
              ),
              SizedBox(height: 2.h),
              CustomLoadingButton(
                buttonText: "Log In",
                buttonColor: AppColors.mainColorYellow,
                loading: authController.loginLoading,
                onPressed: () {
                  if (!authController.loginLoading.value) {
                    final error = Validations.handleLoginScreenError(
                      emailTextController: authController.loginEmailTextController,
                      passwordTextController: authController.loginPasswordTextController,
                    );
                    if (error.isNotEmpty) {
                      customScaffoldMessenger(error);
                    } else {
                      authController.loginApi(
                        authController.loginEmailTextController.text,
                        authController.loginPasswordTextController.text,
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 1.4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?", style: CustomTextStyle.mediumTextBS),
                  SizedBox(width: 0.5.h),
                  InkWell(
                    onTap: () => Get.to(() => const SignUpScreen()),
                    child: Text("Create Account", style: CustomTextStyle.mediumTextS1),
                  ),
                ],
              ),
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
          prefixIcon: SvgPicture.asset(icon),
          suffixIcon: suffix,
        ),
      ],
    );
  }
}