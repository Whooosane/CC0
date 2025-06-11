import 'dart:developer';
import 'package:circleapp/controller/getx_controllers/itinerary_controller.dart';
import 'package:circleapp/controller/getx_controllers/picker_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/common_methods.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateItinerary extends StatefulWidget {
  const CreateItinerary({super.key});

  @override
  State<CreateItinerary> createState() => _CreateItineraryState();
}

class _CreateItineraryState extends State<CreateItinerary> {
  final itineraryNameController = TextEditingController();
  final aboutItineraryController = TextEditingController();
  final errorMessage = ''.obs;
  late final ItineraryController itineraryController = Get.put(ItineraryController(context));
  String date = "";
  String time = "";

  @override
  Widget build(BuildContext context) {
    final pickerController = Get.put(PickerController());

    return Obx(() => Scaffold(
      backgroundColor: AppColors.mainColorBackground,
      body: errorMessage.value.contains('required') && !itineraryController.loading.value
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 12.h, color: AppColors.secondaryColor),
            getVerticalSpace(2.h),
            Text(
              'Create an Itinerary',
              style: CustomTextStyle.headingStyle.copyWith(fontSize: 16.px, color: Colors.white),
            ),
            getVerticalSpace(1.h),
            Text(
              'Fill in the details to plan your itinerary.',
              style: CustomTextStyle.hintText.copyWith(
                fontSize: 12.px,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.3.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getVerticalSpace(6.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 2.h),
                  ),
                  getHorizentalSpace(1.5.h),
                  Text('Create Itinerary', style: CustomTextStyle.headingStyle),
                  const Spacer(),
                ],
              ),
              getVerticalSpace(2.9.h),
              _buildTextFieldLabel('Itinerary name*'),
              getVerticalSpace(.5.h),
              customTextFormField(itineraryNameController, 'Breakfast in SOHO',isObsecure: false),
              getVerticalSpace(1.h),
              if (errorMessage.value.contains('name'))
                Text(errorMessage.value, style: TextStyle(color: Colors.red, fontSize: 10.px)),
              getVerticalSpace(2.h),
              _buildTextFieldLabel('About itinerary*'),
              getVerticalSpace(.5.h),
              customTextFormField(
                aboutItineraryController,
                'Type the note here...',
                isObsecure: false,
                borderRadius: BorderRadius.circular(20.px),
                maxLine: 3,
              ),
              getVerticalSpace(1.h),
              if (errorMessage.value.contains('About'))
                Text(errorMessage.value, style: TextStyle(color: Colors.red, fontSize: 10.px)),
              getVerticalSpace(2.h),
              _buildDateTimeField(
                hint: pickerController.formatedDate.value,
                icon: Icons.date_range_rounded,
                onTap: () async {
                  final selectedDate = await pickerController.selectDate(context, DateTime.now());
                  if (selectedDate != null) date = getFormattedDate(selectedDate);
                },
              ),
              getVerticalSpace(1.h),
              if (errorMessage.value.contains('Date'))
                Text(errorMessage.value, style: TextStyle(color: Colors.red, fontSize: 10.px)),
              getVerticalSpace(2.h),
              _buildDateTimeField(
                hint: pickerController.formatedTime.value,
                icon: Icons.access_time,
                onTap: () async {
                  final selectedTime = await pickerController.selectTime(context);
                  if (selectedTime != null) {
                    time = getFormattedTime(selectedTime);
                    log("Time: $time");
                  }
                },
              ),
              getVerticalSpace(1.h),
              if (errorMessage.value.contains('Time'))
                Text(errorMessage.value, style: TextStyle(color: Colors.red, fontSize: 10.px)),
              getVerticalSpace(5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.3.h),
                child: customLoadingButton(
                  onTap: _validateAndSubmit,
                  backgroundColor: AppColors.secondaryColor,
                  borderColor: AppColors.primaryColor,
                  title: 'Create Itinerary',
                  titleColor: Colors.black,
                  height: 4.5.h,
                  loading: itineraryController.loading,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildTextFieldLabel(String text) => Text(
    text,
    style: CustomTextStyle.buttonText.copyWith(fontSize: 10.px),
  );

  Widget _buildDateTimeField({required String hint, required IconData icon, required Function() onTap}) => TextField(
    onTap: onTap,
    readOnly: true,
    style: CustomTextStyle.hintText.copyWith(color: Colors.white),
    cursorColor: Colors.white,
    decoration: InputDecoration(
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 1.h),
        child: Icon(icon, color: AppColors.secondaryColor),
      ),
      contentPadding: EdgeInsets.only(left: 1.h, top: 2.h),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.px)),
      fillColor: AppColors.textFieldColor,
      filled: true,
      hintStyle: CustomTextStyle.hintText,
      hintText: hint,
      isCollapsed: true,
    ),
  );

  void _validateAndSubmit() {
    final name = itineraryNameController.text.trim();
    final about = aboutItineraryController.text.trim();
    final now = DateTime.now();

    if (name.isEmpty) {
      errorMessage.value = 'Itinerary name is required';
    } else if (name.length < 3) {
      errorMessage.value = 'Itinerary name must be at least 3 characters';
    } else if (name.length > 50) {
      errorMessage.value = 'Itinerary name cannot exceed 50 characters';
    } else if (about.isEmpty) {
      errorMessage.value = 'About itinerary is required';
    } else if (about.length < 10) {
      errorMessage.value = 'About itinerary must be at least 10 characters';
    } else if (about.length > 200) {
      errorMessage.value = 'About itinerary cannot exceed 200 characters';
    } else if (date.isEmpty) {
      errorMessage.value = 'Date is required';
    } else if (DateTime.parse(date).isBefore(DateTime(now.year, now.month, now.day))) {
      errorMessage.value = 'Date cannot be in the past';
    } else if (time.isEmpty) {
      errorMessage.value = 'Time is required';
    } else {
      errorMessage.value = '';
      itineraryController
          .createItinerary(
        load: true,
        name: name,
        about: about,
        date: date,
        time: time,
      )
          .then((success) => success ? Get.back() : null);
    }
  }
}