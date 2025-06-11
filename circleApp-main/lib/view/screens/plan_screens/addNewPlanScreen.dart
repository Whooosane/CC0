import 'package:circleapp/controller/getx_controllers/events_controller.dart';
import 'package:circleapp/controller/getx_controllers/picker_controller.dart';
import 'package:circleapp/controller/getx_controllers/plan_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/common_methods.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/models/all_users_model.dart';
import 'package:circleapp/models/loop_models/event_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:circleapp/view/screens/plan_screens/add_new_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'all_members_screen.dart';
class AddNewPlan extends StatefulWidget {
  final String? circleId;
  const AddNewPlan({super.key, this.circleId});
  @override
  State<AddNewPlan> createState() => _AddNewPlanState();
 }
class _AddNewPlanState extends State<AddNewPlan> {
  RxString date = "".obs;
  RxInt selectedEvent = (-1).obs;
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  RxBool isExpand = false.obs;
  late PlanController planController;
  late EventController eventController;
  RxList<Datum> selectedUsers = <Datum>[].obs;
  @override
  void initState() {
    super.initState();
    eventController = Get.put(EventController(context));
    planController = Get.put(PlanController(context));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      eventController.getEvents(load: true);
    });
  }
  @override
  Widget build(BuildContext context) {
    final PickerController paymentController = Get.put(PickerController());
    return Obx(() {
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
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 2.h,
                        ),
                      ),
                    ),
                    getHorizentalSpace(1.5.h),
                    Text(
                      'Add New Plan',
                      style: CustomTextStyle.headingStyle,
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
                getVerticalSpace(2.9.h),
                Text(
                  'Plan name*',
                  style: CustomTextStyle.buttonText.copyWith(fontSize: 10.px),
                ),
                getVerticalSpace(.5.h),
                customTextFormField(
                  eventNameController,
                  'Imagine Dragon Concert',
                  isObsecure: false,
                ),
                getVerticalSpace(2.h),
                Text(
                  'Description',
                  style: CustomTextStyle.buttonText.copyWith(fontSize: 10.px),
                ),
                getVerticalSpace(.5.h),
                customTextFormField(
                  descriptionController,
                  'Type the note here...',
                  isObsecure: false,
                  keyboardType: TextInputType.text,
                  maxLine: 4,
                  borderRadius: BorderRadius.circular(20.px),
                ),
                getVerticalSpace(2.4.h),
                TextField(
                  onTap: () async {
                    date.value = getFormattedDate(await paymentController.selectDate(context, DateTime.now()));
                  },
                  readOnly: true,
                  style: CustomTextStyle.hintText.copyWith(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 1.h),
                      child: Icon(
                        Icons.date_range_rounded,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(left: 1.h, top: 2.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.px),
                    ),
                    fillColor: AppColors.textFieldColor,
                    filled: true,
                    hintStyle: CustomTextStyle.hintText,
                    hintText: date.value == "" ? "Date" : date.value,
                    isCollapsed: true,
                  ),
                ),
                getVerticalSpace(2.4.h),
                TextField(
                  style: CustomTextStyle.hintText.copyWith(color: Colors.white),
                  controller: locationController,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 1.h),
                      child: Icon(
                        Icons.location_on,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(left: 1.h, top: 2.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.px),
                    ),
                    fillColor: AppColors.textFieldColor,
                    filled: true,
                    hintStyle: CustomTextStyle.hintText,
                    hintText: 'Location',
                    isCollapsed: true,
                  ),
                ),
                getVerticalSpace(2.4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.px, vertical: 15.px),
                  decoration: BoxDecoration(
                    color: AppColors.textFieldColor,
                    borderRadius: BorderRadius.circular(20.px),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Event',
                            style: CustomTextStyle.buttonText,
                          ),
                          GestureDetector(
                            onTap: () {
                              isExpand.value = !isExpand.value;
                            },
                            child: Icon(
                              isExpand.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              size: 3.2.h,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      isExpand.value
                          ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: eventController.loading.value
                                ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: AppColors.shimmerColor1,
                                  highlightColor: AppColors.shimmerColor2,
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    height: 2.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.mainColor,
                                      borderRadius: BorderRadius.circular(10.px),
                                    ),
                                  ),
                                );
                              },
                            )
                                : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: eventController.events.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                Event event = eventController.events[index];
                                return Obx(() {
                                  return GestureDetector(
                                    onTap: () {
                                      selectedEvent.value = index;
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: .8.h),
                                      padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: selectedEvent.value == index ? Colors.white : Colors.transparent,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(30.px),
                                        color: const Color(0xffFFFFFF).withOpacity(0.1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: .6.h,
                                            backgroundColor: Color(colorCodeToInt(eventColors[event.color] ?? "blue")),
                                          ),
                                          getHorizentalSpace(.8.h),
                                          Text(
                                            event.name,
                                            style: CustomTextStyle.buttonText.copyWith(
                                              fontSize: 10.px,
                                              color: Color(colorCodeToInt(colorNameToCode(event.color))),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              },
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          eventController.loading.value
                              ? Shimmer.fromColors(
                            baseColor: AppColors.shimmerColor1,
                            highlightColor: AppColors.shimmerColor2,
                            child: Container(
                              height: 20.px,
                              width: 100.px,
                              alignment: Alignment.bottomCenter,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(10.px),
                              ),
                              child: const Text(""),
                            ),
                          )
                              : GestureDetector(
                            onTap: () {
                              Get.to(() => const AddNewEvent());
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: .5.h),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.secondaryColor),
                                borderRadius: BorderRadius.circular(50.px),
                              ),
                              child: Text(
                                '+ Add new',
                                style: CustomTextStyle.hintText.copyWith(color: AppColors.secondaryColor),
                              ),
                            ),
                          ),
                        ],
                      )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                getVerticalSpace(2.4.h),
                Text(
                  'Add people',
                  style: CustomTextStyle.buttonText.copyWith(fontSize: 14.px),
                ),
                getVerticalSpace(1.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 3.5.h,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedUsers.length,
                          itemExtent: 4.h,
                          itemBuilder: (context, index) {
                            final profilePicture = selectedUsers[index].profilePicture;
                            final isValidUrl = profilePicture != null &&
                                profilePicture.isNotEmpty &&
                                Uri.tryParse(profilePicture)?.hasAuthority == true;
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: .3.h),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.secondaryColor),
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 5.6.h,
                                backgroundColor: AppColors.mainColor,
                                backgroundImage: isValidUrl
                                    ? NetworkImage(profilePicture,scale: 1.0)
                                    :const  AssetImage('assets/png/members.png') as ImageProvider,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Get.to(() => const AllMembersScreen(showAll: true))?.then((value) {
                          if (value != null) {
                            selectedUsers.value = value;
                          }
                        });
                      },
                      child: customTextButton1(
                        title: 'Add Member',
                        horizentalPadding: 1.h,
                        verticalPadding: .5.h,
                        bgColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
                getVerticalSpace(2.4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Set Budget ',
                      style: CustomTextStyle.buttonText.copyWith(fontSize: 14.px),
                    ),
                  ],
                ),
                getVerticalSpace(1.h),
                customTextFormField(
                  budgetController,
                  'Enter Budget...',
                  isObsecure: false,
                  keyboardType: TextInputType.number,
                  maxLine: 1,
                  borderRadius: BorderRadius.circular(20.px),
                ),
                getVerticalSpace(4.8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.3.h),
                  child: customLoadingButton(
                    loading: planController.loading,
                    onTap: () async {
                      if (isValid(context)) {
                        List<String> memberIds = selectedUsers.map((member) => member.id).toList();
                        await planController
                            .createPlan(
                          load: true,
                          name: eventNameController.text,
                          description: descriptionController.text,
                          date: date.value,
                          location: locationController.text,
                          eventType: eventController.events[selectedEvent.value].id,
                          members: memberIds,
                          budget: int.parse(budgetController.text),
                        ).then((value) {
                          if (value) {
                            Get.back();
                          }
                        });
                      }
                    },
                    backgroundColor: AppColors.secondaryColor,
                    borderColor: AppColors.primaryColor,
                    title: 'Create Plan',
                    titleColor: Colors.black,
                    height: 4.5.h,
                  ),
                ),
                getVerticalSpace(20.px),
              ],
            ),
          ),
        ),
      );
    });
  }

  bool isValid(BuildContext context) {
    if (eventNameController.text.isEmpty) {
      customScaffoldMessenger("Event name cannot be empty");
      return false;
    }
    if (descriptionController.text.isEmpty) {
      customScaffoldMessenger("Description cannot be empty");
      return false;
    }
    if (date.value == "") {
      customScaffoldMessenger("Date cannot be empty");
      return false;
    }
    if (locationController.text.isEmpty) {
      customScaffoldMessenger("Location cannot be empty");
      return false;
    }
    if (selectedEvent.value == -1) {
      customScaffoldMessenger("No event selected");
      return false;
    }
    if (selectedUsers.isEmpty) {
      customScaffoldMessenger("Please add at least one member");
      return false;
    }
    if (budgetController.text.isEmpty) {
      customScaffoldMessenger("Budget cannot be empty");
      return false;
    }
    return true;
  }
}