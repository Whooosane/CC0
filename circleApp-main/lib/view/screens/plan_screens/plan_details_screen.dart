import 'package:circleapp/controller/getx_controllers/events_controller.dart';
import 'package:circleapp/controller/getx_controllers/plan_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/common_methods.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:circleapp/view/screens/explore_section/share_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
class PlansDetails extends StatefulWidget {
  final DateTime dateTime;

  const PlansDetails({super.key, required this.dateTime});

  @override
  State<PlansDetails> createState() => _PlansDetailsState();
}

class _PlansDetailsState extends State<PlansDetails> {
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier<DateTime>(DateTime.now());
  late final EventController eventController = Get.put(EventController(context));
  late final PlanController planController = Get.put(PlanController(context));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getPlansAndEvents());
  }

  Future<void> getPlansAndEvents() => Future.wait([
    planController.getPlans(load: planController.plans.isEmpty, dateTime: widget.dateTime),
    eventController.getEvents(load: eventController.events.isEmpty),
  ]);

  @override
  Widget build(BuildContext context) {
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    return Obx(() => Scaffold(
      backgroundColor: AppColors.mainColorBackground,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.3.h),
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
                Text('Plan details', style: CustomTextStyle.headingStyle),
                const Spacer(),
              ],
            ),
            getVerticalSpace(3.5.h),
            Text('Events', style: CustomTextStyle.headingStyle),
            getVerticalSpace(.4.h),
            SizedBox(
              height: 4.h,
              width: double.infinity, // Explicitly set width to screen width
              child: eventController.loading.value
                  ? ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: 3,
                itemBuilder: (context, index) => Shimmer.fromColors(
                  baseColor: AppColors.shimmerColor1,
                  highlightColor: AppColors.shimmerColor2,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.px),
                    width: 120.px,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(10.px),
                    ),
                  ),
                ),
              )
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: eventController.events.length,
                itemBuilder: (context, index) {
                  final event = eventController.events[index];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.px),
                    padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.px),
                      color: const Color(0xffFFFFFF).withOpacity(0.1),
                    ),
                    child: Row(
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
                  );
                },
              ),
            ),
            getVerticalSpace(2.5.h),
            Expanded(
              child: planController.loading.value
                  ? ListView.builder(
                itemCount: 8,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => Shimmer.fromColors(
                  baseColor: AppColors.shimmerColor1,
                  highlightColor: AppColors.shimmerColor2,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    height: 180.px,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(20.px),
                    ),
                  ),
                ),
              )
                  : planController.plans.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 12.h, color: AppColors.secondaryColor),
                    getVerticalSpace(2.h),
                    Text(
                      'No Plans Available',
                      style: CustomTextStyle.headingStyle.copyWith(
                        fontSize: 16.px,
                        color: Colors.white,
                      ),
                    ),
                    getVerticalSpace(1.h),
                    Text(
                      'No plans found for ${_selectedDate.value.day} ${months[_selectedDate.value.month - 1]} ${_selectedDate.value.year}',
                      style: CustomTextStyle.hintText.copyWith(
                        fontSize: 12.px,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: planController.plans.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final plan = planController.plans[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainColorYellow,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Dismissible(

                      key: ValueKey(plan.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        decoration: BoxDecoration(
                          color: AppColors.mainColorYellow,
                            borderRadius: BorderRadius.circular(20)
                        ),

                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => planController.deletePlan(plan.id, load: false),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.2.h, vertical: 2.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.textFieldColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(plan.name, style: CustomTextStyle.mediumTextM14),
                                const Spacer(),
                                Text(
                                  getFormattedDate(plan.date),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 11.px,
                                    fontFamily: "medium",
                                  ),
                                ),
                              ],
                            ),
                            getVerticalSpace(.5.h),
                            Text(
                              plan.description,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 10.px,
                                fontFamily: "medium",
                              ),
                            ),
                            getVerticalSpace(1.h),
                            Row(
                              children: [
                                SvgPicture.asset("assets/svg/Location.svg"),
                                getHorizentalSpace(1.w),
                                Expanded(
                                  child: Text(
                                    plan.location,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 8.px,
                                      fontFamily: "medium",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            getVerticalSpace(1.2.h),
                            Text(
                              "Added members",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 11.px,
                                fontFamily: "medium",
                              ),
                            ),
                            getVerticalSpace(1.h),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 27,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: plan.members.length,
                                      itemBuilder: (_, index) => Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 2),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Image.network(plan.members[index].profilePicture.toString(), width: 27, fit: BoxFit.fill),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                getHorizentalSpace(1.w),
                                GestureDetector(
                                  onTap: () => Get.to(() =>  ShareGroupScreen(titleKey: "planId",
                                  titleId: plan.id,)),
                                  child: SvgPicture.asset("assets/svg/shareButton.svg"),
                                ),
                                getHorizentalSpace(2.w),
                                Container(
                                  height: 3.h,
                                  width: 22.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColorYellow,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: AppColors.mainColorYellow),
                                  ),
                                  child: Center(child: Text("Booked", style: CustomTextStyle.buttonDark)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}