import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
Widget commonShimmer({required double height, required double width}) {
  return Shimmer.fromColors(
      baseColor: AppColors.shimmerColor1,
      highlightColor: AppColors.shimmerColor2,
      child: Container(
        alignment: Alignment.bottomCenter,
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(10.px),
        ),
      ));
}
