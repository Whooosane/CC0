import 'package:circleapp/controller/getx_controllers/events_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/common_methods.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../custom_widget/customwidgets.dart';

class AddNewEvent extends StatelessWidget {
  const AddNewEvent({super.key});

  @override
  Widget build(BuildContext context) {
    RxList<int> colorsList = eventColors.values.map((colorCode) => colorCodeToInt(colorCode)).toList().obs;
    RxInt selectedColor = (-1).obs;
    EventController eventController = Get.put(EventController(context));
    final TextEditingController eventNameController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.mainColorBackground,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.3.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getVerticalSpace(6.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 2.h,
                    ),
                  ),
                  getHorizentalSpace(1.5.h),
                  Text(
                    'Add New Event',
                    style: CustomTextStyle.headingStyle,
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
              getVerticalSpace(2.9.h),
              Text(
                'Event name*',
                style: CustomTextStyle.buttonText.copyWith(fontSize: 10.px),
              ),
              getVerticalSpace(.5.h),
              customTextFormField(
                eventNameController,
                'Hangout',
                isObsecure: false,
              ),
              getVerticalSpace(3.h),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 1.2.h, vertical: 1.h),
                  decoration: BoxDecoration(color: AppColors.textFieldColor, borderRadius: BorderRadius.circular(20.px)),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Assign color',
                              style: CustomTextStyle.buttonText,
                            ),
                            Icon(
                              Icons.keyboard_arrow_up,
                              size: 3.2.h,
                              color: Colors.white,
                            )
                          ],
                        ),
                        getVerticalSpace(2.h),
                        SizedBox(
                          height: 3.h,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: colorsList.length,
                            itemExtent: 30,
                            itemBuilder: (context, index) {
                              return Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    selectedColor.value = index;
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selectedColor.value == index ? Colors.white : Colors.transparent,
                                        width: 3,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 25.px,
                                      backgroundColor: Color(colorsList[index]),
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              getVerticalSpace(5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.3.h),
            child: customLoadingButton(
                onTap: () {
                  if (eventNameController.text.isEmpty) {
                    Get.snackbar('Sorry', 'EventName Should not be Empty',
                        backgroundColor: Colors.white.withOpacity(0.5), colorText: AppColors.mainColorBackground);
                  } else if (selectedColor.value == -1) {
                    Get.snackbar('Sorry', 'Please select event color',
                        backgroundColor: Colors.white.withOpacity(0.5), colorText: AppColors.mainColorBackground);
                  } else {
                    eventController.createEvents(
                        load: true,
                        eventName: eventNameController.text,
                        color: eventColors.keys.elementAt(selectedColor.value)).then((value) {
                          if(value)
                            {
                              Get.back();
                              eventController.getEvents(load: true);
                            }
                        },);
                  }
                },
                backgroundColor: AppColors.secondaryColor,
                borderColor: AppColors.primaryColor,
                title: 'Done',
                titleColor: Colors.black,
                height: 4.5.h,
                loading: eventController.loading),
          ),
            ],
          ),
        ),
      ),
    );
  }
}
