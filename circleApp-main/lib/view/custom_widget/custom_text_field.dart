import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controller/utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final bool? phoneKeyboard;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.obscureText = false,
    this.phoneKeyboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        color: AppColors.mainColor,
      ),
      child: TextFormField(
        keyboardType: phoneKeyboard == true ? TextInputType.phone : null,
        controller: controller,
        style: CustomTextStyle.hintText.copyWith(color: Colors.white),
        // controller: controller,
        obscureText: obscureText,
        cursorColor: Colors.white, // Replace with your AppColors.mainColor
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 10.px, fontFamily: "medium", color: Colors.white),
          contentPadding: EdgeInsets.all(10),
          prefixIcon: Transform.scale(
            scale: 0.4,
            child: prefixIcon,
          ),
          suffixIcon: Transform.scale(
            scale: 0.4,
            child: suffixIcon,
          ),
          // isDense: true,

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(36),
            borderSide: BorderSide(color: AppColors.mainColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(36),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(36),
            borderSide: BorderSide(color: AppColors.mainColor),
          ),
        ),
      ),
    );
  }
}




//second textformfield
class CustomTextField1 extends StatelessWidget {
  final String hintText;

  final Widget? suffixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final bool? phoneKeyboard;

  const CustomTextField1({
    Key? key,
    required this.hintText,

    this.suffixIcon,
    this.controller,
    this.obscureText = false,
    this.phoneKeyboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        color: AppColors.mainColor,
      ),
      child: TextFormField(
       keyboardType: TextInputType.number,
        controller: controller,
        style: CustomTextStyle.hintText.copyWith(color: Colors.white),
        // controller: controller,
        obscureText: obscureText,
        cursorColor: Colors.white, // Replace with your AppColors.mainColor
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 10.px, fontFamily: "medium", color: Colors.white),
          contentPadding: EdgeInsets.all(10),
          suffixIcon: Transform.scale(
            scale: 0.4,
            child: suffixIcon,
          ),
          // isDense: true,

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(36),
            borderSide: BorderSide(color: AppColors.mainColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(36),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(36),
            borderSide: BorderSide(color: AppColors.mainColor),
          ),
        ),
      ),
    );
  }
}
