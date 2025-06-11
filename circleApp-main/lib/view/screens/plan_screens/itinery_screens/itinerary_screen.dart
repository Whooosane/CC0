import 'package:circleapp/controller/getx_controllers/itinerary_controller.dart';
import 'package:circleapp/controller/getx_controllers/picker_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/packages/flutter_calendar_week-2.0.0/lib/src/calendar_week.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:circleapp/view/screens/explore_section/share_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'create_itinirary.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  final _selectedDate = ValueNotifier<DateTime>(DateTime.now());
  late final ItineraryController itineraryController = Get.put(ItineraryController(context));
  late final PickerController pickerController = Get.put(PickerController());
  final calendarWeekController = CalendarWeekController();

  @override
  void initState() {
    super.initState();
    calendarWeekController.selectedDate = DateTime.now();
    itineraryController.getItineraries(load: true, dateTime: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return Scaffold(
      backgroundColor: AppColors.mainColorBackground,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 10.px),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final dateTime = await pickerController.selectDate(context, _selectedDate.value);
                    if (dateTime != null) {
                      _selectedDate.value = dateTime;
                      itineraryController.getItineraries(load: true, dateTime: dateTime);
                    }
                  },
                  child: ValueListenableBuilder<DateTime>(
                    valueListenable: _selectedDate,
                    builder: (context, value, _) => Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "${value.day}",
                          style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w400, color: Colors.white),
                        ),
                        getHorizentalSpace(10.px),
                        Text(
                          "${days[value.weekday - 1]}\n${months[value.month - 1]} ${value.year}",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                customButton(
                  onTap: () => Get.to(() => const CreateItinerary()),
                  backgroundColor: AppColors.secondaryColor,
                  height: 30.px,
                  width: 120.px,
                  title: "Create Itinerary",
                  titleColor: Colors.black,
                  borderColor: Colors.transparent,
                ),
              ],
            ),
          ),
          weeklyCalender(
            calendarWeekController,
                (dateTime) {
              _selectedDate.value = dateTime;
              itineraryController.getItineraries(load: true, dateTime: dateTime);
            },
                (_) {},
          ),
          Expanded(
            child: Obx(() => itineraryController.loading.value
                ? _buildShimmerList()
                : itineraryController.itineraries.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_note, size: 12.h, color: AppColors.secondaryColor),
                  getVerticalSpace(2.h),
                  Text(
                    'No Itineraries Found',
                    style: CustomTextStyle.headingStyle.copyWith(fontSize: 16.px, color: Colors.white),
                  ),
                  getVerticalSpace(1.h),
                  Text(
                    'No itineraries for ${_selectedDate.value.day} ${months[_selectedDate.value.month - 1]} ${_selectedDate.value.year}',
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
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              itemCount: itineraryController.itineraries.length,
              itemBuilder: (context, index) {
                final itinerary = itineraryController.itineraries[index];
                return Column(
                  children: [
                    if (index == 0) Divider(color: AppColors.hintTextColor),
                    GestureDetector(
                      onTap: () => Get.to(() =>  ShareGroupScreen(
                        titleKey: "itineraryId",
                      titleId: itinerary.id,)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(radius: .6.h, backgroundColor: Colors.white),
                                getHorizentalSpace(.5.h),
                                Text(
                                  itinerary.about,
                                  style: CustomTextStyle.buttonText.copyWith(color: Colors.white),
                                ),
                                const Spacer(),
                                Text(
                                  itinerary.time,
                                  style: CustomTextStyle.buttonText.copyWith(color: Colors.white),
                                ),
                              ],
                            ),getVerticalSpace(0.5.h),
                            Row(
                              children: [
                                getHorizentalSpace(2.h),
                                Text(
                                  itinerary.name,
                                  style: CustomTextStyle.headingStyle.copyWith(color: AppColors.secondaryColor),
                                ),
                                const Spacer(),
                                SvgPicture.asset("assets/png/share.svg",height: 3.h,),
                              ],
                            ),
                            getVerticalSpace(.6.h),
                            Divider(color: AppColors.secondaryColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() => ListView.builder(
    padding: EdgeInsets.symmetric(horizontal: 5.w),
    itemCount: 15,
    itemBuilder: (context, index) => Shimmer.fromColors(
      baseColor: AppColors.shimmerColor1,
      highlightColor: AppColors.shimmerColor2,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 10.h,
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(10.px),
        ),
      ),
    ),
  );

}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) => _getMeetingData(index).from;

  @override
  DateTime getEndTime(int index) => _getMeetingData(index).to;

  @override
  String getSubject(int index) => _getMeetingData(index).eventName;

  @override
  Color getColor(int index) => _getMeetingData(index).background;

  @override
  bool isAllDay(int index) => _getMeetingData(index).isAllDay;

  Meeting _getMeetingData(int index) {
    final meeting = appointments![index] as Meeting;
    return meeting;
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