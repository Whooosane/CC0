import 'package:circleapp/view/screens/plan_screens/plans_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/socket_service.dart';
import '../../../controller/utils/app_colors.dart';
import '../../../controller/utils/customTextStyle.dart';
import 'itinery_screens/itinerary_screen.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff343434),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            SizedBox(height: 5.h),
            // Tab bar
            TabBar(
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 2.0,
                  color: AppColors.mainColorYellow,
                ),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: CustomTextStyle.mediumTextTab,
              unselectedLabelColor: AppColors.mainColorOffWhite.withOpacity(0.5),
              dividerColor: AppColors.mainColorOffWhite.withOpacity(0.5),
              tabs: const [
                Tab(text: "Plans"),
                Tab(text: "Itineraries"),
              ],
            ),
            const Expanded(
              // Content for tabs
              child: TabBarView(
                children: [
                  // Content for Tab 1
                  PlansScreen(),
                  // Content for Tab 2
                  ItineraryScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
