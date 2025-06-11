import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controller/utils/app_colors.dart';

class CustomLoadingButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color? buttonColor;
  RxBool loading;

  CustomLoadingButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.buttonColor,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width, 6.h),
          backgroundColor: AppColors.secondaryColor,

          // Text color
        ),
        child: loading.value
            ? LoadingAnimationWidget.waveDots(color: AppColors.mainColorLogin, size: 35)
            : Text(buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.px,
                  color: AppColors.mainColorLogin,
                  fontFamily: "medium",
                )),
      );
    });
  }
}
