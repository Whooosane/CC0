
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/common_methods.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/controller/utils/shared_preferences.dart';
import 'package:circleapp/main.dart';
import 'package:circleapp/packages/flutter_calendar_week-2.0.0/lib/src/calendar_week.dart';
import 'package:circleapp/view/screens/athentications/login_screen.dart';
import 'package:circleapp/view/screens/explore_section/share_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
Widget customTextFormField(TextEditingController? controller, String? hintText,
    {TextInputType? keyboardType,
    Widget? prefixIcon,
    final ValueChanged<String>? onChanged,
    Icon? icon,
    Widget? sufixIcon,
    Color? iconColor,
    String? lableText,
    int? maxLine,
    BorderRadius? borderRadius,
    TextStyle? lableStyle,
    required bool isObsecure,
    EdgeInsets? contentPading,
    Color? hintTextColor,
      Color? borderColor,
    bool readOnly = false,
    Callback? isTap}) {
  return TextFormField(
    maxLines: maxLine,
    onChanged: onChanged,
    cursorHeight: 2.h,
    obscureText: isObsecure,
    controller: controller,
    style: CustomTextStyle.hintText,
    cursorColor: Colors.white,
    keyboardType: keyboardType,
    readOnly: readOnly,
    onTap: isTap,
    decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(30.px), borderSide: BorderSide(color: borderColor ?? AppColors.textFieldColor)),
        filled: true,
        contentPadding: contentPading ?? EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
        // Adjust vertical padding
        isCollapsed: true,
        border: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(30.px), borderSide: BorderSide(color: borderColor ?? AppColors.textFieldColor)),
        fillColor: AppColors.textFieldColor,
        prefixIcon: prefixIcon,
        suffixIcon: sufixIcon,
        hintText: hintText,
        hintStyle: CustomTextStyle.hintText,
        labelText: lableText,
        labelStyle: lableStyle),
  );
}

Widget getVerticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

Widget getHorizentalSpace(double width) {
  return SizedBox(
    width: width,
  );
}

Widget customRadioButton({String? title, Color? borderColor, SvgPicture? assetsImage}) {
  return Container(
    alignment: Alignment.center,
    height: 4.2.h,
    decoration: BoxDecoration(color: AppColors.textFieldColor, borderRadius: BorderRadius.circular(30.px)),
    child: Row(
      children: [
        getHorizentalSpace(2.h),
        Container(
          height: 1.8.h,
          width: 1.8.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor!),
          ),
          child: assetsImage,
        ),
        getHorizentalSpace(2.h),
        Text(
          title!,
          style: CustomTextStyle.smallText,
        ),
      ],
    ),
  );
}

Widget customButton({String? title, Color? backgroundColor, double? height, Callback? onTap, Color? borderColor, double? width, Color? titleColor}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.px),
        color: backgroundColor,
        border: Border.all(color: borderColor!),
      ),
      child: Text(
        title!,
        style: CustomTextStyle.buttonText.copyWith(color: titleColor),
      ),
    ),
  );
}

Widget customLoadingButton(
    {String? title,
    Color? backgroundColor,
    double? height,
    Callback? onTap,
    Color? borderColor,
    double? width,
    Color? titleColor,
    required RxBool loading}) {
  return Obx(() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.px),
          color: backgroundColor,
          border: Border.all(color: borderColor!),
        ),
        child: loading.value
            ? LoadingAnimationWidget.waveDots(color: AppColors.mainColorLogin, size: 35)
            : Text(
                title!,
                style: CustomTextStyle.buttonText.copyWith(color: titleColor),
              ),
      ),
    );
  });
}

Widget customTextButton1({String? title, double? horizentalPadding, double? verticalPadding, Color? bgColor}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: horizentalPadding ?? .7.h, vertical: verticalPadding ?? .1.h),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.px), color: bgColor ?? AppColors.mainColor, border: Border.all(color: AppColors.secondaryColor)),
    child: Row(
      children: [
        Icon(
          Icons.add,
          color: AppColors.secondaryColor,
          size: 2.h,
        ),
        getHorizentalSpace(.2.h),
        Text(
          title ?? 'Add',
          style: CustomTextStyle.smallText.copyWith(color: AppColors.secondaryColor, fontSize: 12.px),
        )
      ],
    ),
  );
}

Widget customTextButton2({String? title, Color? bgColor, Color? btnTextColor, double? horizentalPadding, verticalPadding}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: horizentalPadding ?? .8.h, vertical: verticalPadding ?? .3.h),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.px), color: bgColor ?? AppColors.mainColor, border: Border.all(color: AppColors.secondaryColor)),
    child: Row(
      children: [
        getHorizentalSpace(.2.h),
        Text(
          title ?? "View Detail",
          style: CustomTextStyle.smallText.copyWith(color: btnTextColor ?? AppColors.secondaryColor, fontSize: 10.px),
        )
      ],
    ),
  );
}

customScaffoldMessenger(String text) {
  WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 14.sp,
                ),
              ),
              backgroundColor: AppColors.primaryColor,
              duration: const Duration(seconds: 2),
            ),
          );
    },
  );
}

Widget weeklyCalender(CalendarWeekController calendarWeekController, Function(DateTime dateTime) press, Function(DateTime dateTime) longPressed) {
  return CalendarWeek(
    controller: calendarWeekController,
    minDate: DateTime.now().add(
      const Duration(days: -365),
    ),
    maxDate: DateTime.now().add(
      const Duration(days: 365),
    ),
    onDatePressed: (DateTime datetime) {
      press(datetime);
    },
    onDateLongPressed: (DateTime datetime) {
      longPressed(datetime);
    },
    todayDateStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 11),
    todayBackgroundColor: AppColors.mainColorBackground,
    dayOfWeekStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 11),
    dateStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 11),
    pressedDateBackgroundColor: AppColors.secondaryColor,
    pressedDateStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 11),
    dateBackgroundColor: Colors.transparent,
    backgroundColor: AppColors.mainColorBackground,
    dayOfWeek: const ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'],
    weekendsStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 11),
    showMonth: false,
  );
}

Widget logoutDialog() {
  return AlertDialog(
    backgroundColor: AppColors.textFieldColor,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Logout',
          style: CustomTextStyle.mediumTextM14,
        ),
      ],
    ),
    actions: <Widget>[
      Row(
        children: [
          Expanded(
            child: customButton(
                onTap: () {
                  Get.back();
                },
                backgroundColor: AppColors.primaryColor,
                borderColor: AppColors.secondaryColor,
                title: 'Back',
                titleColor: Colors.white,
                height: 4.5.h),
          ),
          getHorizentalSpace(15.px),
          Expanded(
            child: customButton(
                onTap: () {
                  MySharedPreferences.removeAll();
                  Get.offAll(() => const LoginScreen());
                },
                backgroundColor: AppColors.secondaryColor,
                borderColor: AppColors.primaryColor,
                title: 'Logout',
                titleColor: Colors.black,
                height: 4.5.h),
          )
        ],
      )
    ],
  );
}

Widget storyDialog({
  required VoidCallback onCameraSelected, // Callback for Camera selection
  required VoidCallback onGallerySelected, // Callback for Gallery selection
}) {
  return AlertDialog(
    backgroundColor: AppColors.textFieldColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Pick image from',
            style: CustomTextStyle.mediumTextM14,
          ),
        ],
      ),
    actions: <Widget>[
      Row(
        children: [
          Expanded(
            child: customButton(
              onTap: () {
                onCameraSelected(); // Trigger Camera callback
                Get.back(); // Close the dialog
              },
              backgroundColor: AppColors.secondaryColor,
              borderColor: AppColors.primaryColor,
              title: 'Camera',
              titleColor: Colors.black,
              height: 4.5.h,
            ),
          ),
          getHorizentalSpace(15.px),
          Expanded(
            child: customButton(
              onTap: () {
                onGallerySelected();
                Get.back();
              },
              backgroundColor: AppColors.secondaryColor,
              borderColor: AppColors.primaryColor,
              title: 'Gallery',
              titleColor: Colors.black,
              height: 4.5.h,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget interestsDialog({required Function(String) onLogout}) {
  TextEditingController interestController = TextEditingController();
  return AlertDialog(
    backgroundColor: AppColors.textFieldColor,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(child: SizedBox()),
        Text(
          'Add Interest',
          style: CustomTextStyle.mediumTextM14,
        ),
        const Expanded(child: SizedBox()),
        GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.cancel,
              color: Colors.white,
            ))
      ],
    ),
    actions: <Widget>[
      Column(
        children: [
          customTextFormField(interestController, "Interest", isObsecure: false, borderColor: AppColors.mainColorYellow),
          getVerticalSpace(10.px),
          customButton(
              width: 80.w,
              onTap: () {
                Get.back();
                onLogout(interestController.text);
              },
              backgroundColor: AppColors.mainColorYellow,
              borderColor: AppColors.secondaryColor,
              title: 'Add',
              titleColor: Colors.black,
              height: 4.5.h),
          getHorizentalSpace(15.px),
        ],
      )
    ],
  );
}


Widget offerCard({
  required String title,
  required String titleId,
  required String description,
  required String interest,
  required int price,
  required DateTime startingDate,
  required int numberOfPeople,
  required List<String> imageUrls,
  required bool showShare,
})
{
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: CustomTextStyle.mediumTextM14,
          ),
          const Expanded(child: SizedBox()),
          Text(
            "Total Price: ",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11.px,
              fontWeight: FontWeight.w400,
              fontFamily: "medium",
            ),
          ),
          Text(
            price.toString(),
            style: CustomTextStyle.mediumTextM,
          ),
        ],
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Text(
          getFormattedDate(startingDate),
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 11.px,
            fontWeight: FontWeight.w400,
            fontFamily: "medium",
          ),
        ),
      ),
      getVerticalSpace(.3.h),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          description,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 10.px,
            fontWeight: FontWeight.w400,
            fontFamily: "medium",
          ),
        ),
      ),
      getVerticalSpace(1.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Offer for:",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11.px,
              fontWeight: FontWeight.w400,
              fontFamily: "medium",
            ),
          ),
          getHorizentalSpace(1.w),
          Text(
            "${numberOfPeople.toString()} People",
            style: CustomTextStyle.mediumTextM,
          ),
        ],
      ),
      getVerticalSpace(1.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Interest:",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11.px,
              fontWeight: FontWeight.w400,
              fontFamily: "medium",
            ),
          ),
          getHorizentalSpace(1.w),
          Text(
            interest,
            style: CustomTextStyle.mediumTextM,
          ),
        ],
      ),
      getVerticalSpace(1.2.h),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "images",
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11.px,
            fontWeight: FontWeight.w400,
            fontFamily: "medium",
          ),
        ),
      ),
      getVerticalSpace(1.h),
      Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey[200],
                          child: CachedNetworkImage(
                            imageUrl: imageUrls[index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) {
                              return Shimmer.fromColors(
                                baseColor: AppColors.shimmerColor1,
                                highlightColor: AppColors.shimmerColor2,
                                child: Container(
                                  color: Colors.white,
                                ),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return const Icon(Icons.error, color: Colors.red);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getHorizentalSpace(1.w),
              showShare ? GestureDetector(onTap: () {
                Get.to(()=> ShareGroupScreen(titleKey: "offerId",titleId: titleId,));
              },
                child: SvgPicture.asset("assets/svg/shareButton.svg",height: 3.4.h,),) : const SizedBox(),
              getHorizentalSpace(2.w),
              Container(
                height: 3.4.h,
                width: 22.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.mainColorYellow),
                ),
                child: Center(
                  child: Text(
                    "View Details",
                    style: CustomTextStyle.mediumTextYellow,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
Widget experiencePlanCard({
  required String title,
  required String description,
  required String interest,
  required int price,
  required DateTime startingDate,
  required int numberOfPeople,
  required List<String> imageUrls,
  required bool showShare,
})
{
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: CustomTextStyle.mediumTextM14,
          ),
          const Expanded(child: SizedBox()),
          Text(
            "Total Price: ",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11.px,
              fontWeight: FontWeight.w400,
              fontFamily: "medium",
            ),
          ),
          Text(
            price.toString(),
            style: CustomTextStyle.mediumTextM,
          ),
        ],
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Text(
          getFormattedDate(startingDate),
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 11.px,
            fontWeight: FontWeight.w400,
            fontFamily: "medium",
          ),
        ),
      ),
      getVerticalSpace(.3.h),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          description,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 10.px,
            fontWeight: FontWeight.w400,
            fontFamily: "medium",
          ),
        ),
      ),
      getVerticalSpace(1.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Offer for:",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11.px,
              fontWeight: FontWeight.w400,
              fontFamily: "medium",
            ),
          ),
          getHorizentalSpace(1.w),
          Text(
            "${numberOfPeople.toString()} People",
            style: CustomTextStyle.mediumTextM,
          ),
        ],
      ),
      getVerticalSpace(1.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Interest:",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11.px,
              fontWeight: FontWeight.w400,
              fontFamily: "medium",
            ),
          ),
          getHorizentalSpace(1.w),
          Text(
            interest,
            style: CustomTextStyle.mediumTextM,
          ),
        ],
      ),
      getVerticalSpace(1.2.h),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "images",
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11.px,
            fontWeight: FontWeight.w400,
            fontFamily: "medium",
          ),
        ),
      ),
      getVerticalSpace(1.h),
      Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey[200],
                          child: CachedNetworkImage(
                            imageUrl: imageUrls[index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) {
                              return Shimmer.fromColors(
                                baseColor: AppColors.shimmerColor1,
                                highlightColor: AppColors.shimmerColor2,
                                child: Container(
                                  color: Colors.white,
                                ),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return const Icon(Icons.error, color: Colors.red);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getHorizentalSpace(1.w),
              Container(
                height: 3.4.h,
                width: 18.w,
                decoration: BoxDecoration(
                  color: AppColors.mainColorYellow,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Booked",
                    style: CustomTextStyle.mediumTextYellow.copyWith(color: AppColors.primaryColor,fontWeight: FontWeight.w700),
                  ),
                ),
              ), getVerticalSpace(1.h),
              Container(
                height: 3.4.h,
                width: 22.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.mainColorYellow),
                ),
                child: Center(
                  child: Text(
                    "View Details",
                    style: CustomTextStyle.mediumTextYellow,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
