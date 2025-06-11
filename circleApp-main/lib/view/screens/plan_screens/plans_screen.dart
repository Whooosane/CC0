import 'package:circleapp/controller/getx_controllers/plan_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/common_methods.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/models/explore-model.dart';
import 'package:circleapp/models/plan_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:circleapp/view/screens/explore_section/share_group.dart';
import 'package:circleapp/view/screens/plan_screens/plan_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'addNewPlanScreen.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  late PlanController planController;
  final List<ExploreModel> data = [
    ExploreModel(
        birdOffer: "Imagine Dragon’s Concert",
        totalPrice: "\$2500",
        date: "1/2/2024",
        concertName: "Imagine Dragon’s Concert",
        discription:
        "Lorem ipsum dolor sit amet consectetur. Eget aliquam suspendisse ultrices a mattis vitae. Adipiscing id vestibulum ultrices lorem. Nibh dignissim bibendum a Adipi.",
        location: "13th Street. 47 W 13th St, New York, NY 10011,USA. 20 Cooper Square.",
        interest: "Music",
        images: [
          "assets/png/png4.png",
          "assets/png/png3.png",
          "assets/png/png2.png",
          "assets/png/png1.png"
        ], offerFor: ''),
    ExploreModel(
        birdOffer: "Art Gallery",
        totalPrice: "\$2500",
        date: "1/2/2024",
        concertName: "Imagine Dragon’s Concert",
        discription:
        "Lorem ipsum dolor sit amet consectetur. Eget aliquam suspendisse ultrices a mattis vitae. Adipiscing id vestibulum ultrices lorem. Nibh dignissim bibendum aAdipi.",
        location: "13th Street. 47 W 13th St, New York, NY 10011,USA. 20 Cooper Square.",
        interest: "Music",
        images: [
          "assets/png/png4.png",
          "assets/png/png3.png",
          "assets/png/png2.png",
          "assets/png/png1.png"
        ], offerFor: ''),
    ExploreModel(
        birdOffer: "Early Bird Offer",
        totalPrice: "\$2500",
        date: "1/2/2024",
        concertName: "Imagine Dragon’s Concert",
        discription:
        "Lorem ipsum dolor sit amet consectetur. Eget aliquam suspendisse ultrices a mattis vitae. Adipiscing id vestibulum ultrices lorem. Nibh dignissim bibendum aAdipi.",
        location: "13th Street. 47 W 13th St, New York, NY 10011,USA. 20 Cooper Square.",
        interest: "Music",
        images: [
          "assets/png/png4.png",
          "assets/png/png3.png",
          "assets/png/png2.png",
          "assets/png/png1.png"
        ], offerFor: '')
  ];
  final List<String> imageUrls = [
    "assets/png/png4.png",
    "assets/png/png3.png",
    "assets/png/png2.png",
    "assets/png/png1.png"
  ];
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier<DateTime>(DateTime.now());

  @override
  void initState() {
    planController = Get.put(PlanController(context));
    planController.getPlans(load: planController.plans.isEmpty, dateTime: DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return Scaffold(
          body: Column(
            children: [
              SfCalendar(
                backgroundColor: Colors.white,
                viewHeaderStyle: const ViewHeaderStyle(backgroundColor: Colors.grey),
                todayHighlightColor: AppColors.mainColorYellow,
                todayTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                view: CalendarView.month,
                onSelectionChanged: (value) {
                  _selectedDate.value = value.date!;
                  planController.getPlans(load: true, dateTime: _selectedDate.value);
                },
              ),
              getVerticalSpace(1.5.h),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,// Added height constraint
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xff343434),
                    ),
                    color: AppColors.mainColorBackground,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.w),
                        child: Row(
                          children: [
                            Text(
                              "Plans",
                              style: CustomTextStyle.mediumTextM14,
                            ),
                            getHorizentalSpace(10.px),
                            GestureDetector(
                                onTap: () {
                                  Get.to(() => const AddNewPlan());
                                },
                                child: customTextButton2(bgColor: const Color(0xffFFC491), title: 'Add New Plan', btnTextColor: const Color(0xff323232))),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => PlansDetails(dateTime: _selectedDate.value,));
                              },
                              child: Text(
                                "See Details",
                                style: CustomTextStyle.mediumTextTab,
                              ),
                            ),
                          ],
                        ),
                      ),
                      getVerticalSpace(2.5.h),
                      Expanded(
                        child: planController.loading.value ? ListView.builder(
                            itemCount: 8,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                baseColor: AppColors.shimmerColor1,
                                highlightColor: AppColors.shimmerColor2,
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  alignment: Alignment.bottomCenter,
                                  height: 180.px,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius: BorderRadius.circular(20.px),
                                  ),
                                ),
                              );
                            }) : planController.plans.isEmpty
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("No Plans found on",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                )),
                            Text("${_selectedDate.value.day} ${["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][_selectedDate.value.month - 1]} ${_selectedDate.value.year}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ))
                          ],
                        )
                            : ListView.builder(
                            itemCount: planController.plans.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              Plan plan = planController.plans[index];
                              return Container(
                                margin: const EdgeInsets.all(10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.2.h, vertical: 2.h),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.textFieldColor),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(radius: .6.h, backgroundColor: Color(colorCodeToInt(eventColors[plan.eventType.color] ?? "blue"))),
                                        getHorizentalSpace(5.px),
                                        Text(
                                          plan.name,
                                          style: CustomTextStyle.mediumTextM14,
                                        ),
                                        const Expanded(child: SizedBox()),
                                        Text(
                                          getFormattedDate(plan.date),
                                          style: TextStyle(
                                              color:
                                              Colors.white.withOpacity(0.5),
                                              fontSize: 11.px,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "medium"),
                                        ),
                                      ],
                                    ),
                                    getVerticalSpace(.5.h),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        plan.description,
                                        style: TextStyle(
                                            color:
                                            Colors.white.withOpacity(0.5),
                                            fontSize: 10.px,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "medium"),
                                      ),
                                    ),
                                    getVerticalSpace(1.h),
                                    Row(mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset("assets/svg/Location.svg"),
                                        getHorizentalSpace(1.w),
                                        Expanded(
                                          child: Text(
                                            plan.location,
                                            style:  TextStyle(
                                                color:
                                                Colors.white.withOpacity(0.5),
                                                fontSize: 8.px,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "medium"),
                                          ),
                                        ),
                                      ],
                                    ),

                                    getVerticalSpace(1.2.h),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Added members",
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(0.7), fontSize: 11.px, fontWeight: FontWeight.w400, fontFamily: "medium"),
                                      ),
                                    ),
                                    getVerticalSpace(1.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: SizedBox(
                                              height: 27,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: plan.members.length,
                                                  itemBuilder: (BuildContext, index) {
                                                    return Container(
                                                      margin: const EdgeInsets.symmetric(horizontal: 2),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(50.0),
                                                        child: plan.members[index].profilePicture != null ? Image.network(
                                                          fit: BoxFit.fill,
                                                          plan.members[index].profilePicture!,
                                                          width: 27,
                                                        ) : Image.asset('assets/png/userplacholder.png'),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            getHorizentalSpace(1.w),
                                            GestureDetector(onTap:() {
                                              Get.to(()=> ShareGroupScreen(titleKey: "planId",
                                              titleId:plan.id,));
                                            },
                                                child: SvgPicture.asset("assets/svg/shareButton.svg")),
                                            getHorizentalSpace(2.w),
                                            Container(
                                                height: 3.h,
                                                width: 22.w,
                                                decoration: BoxDecoration(
                                                  color: AppColors.mainColorYellow,
                                                    borderRadius: BorderRadius.circular(30), border: Border.all(color: AppColors.mainColorYellow)),
                                                child: Center(
                                                    child: Text(
                                                      "Booked",
                                                      style: CustomTextStyle.buttonDark,
                                                    )))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}
