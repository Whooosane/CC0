import 'package:circleapp/controller/getx_controllers/chat_socket_controller.dart';
import 'package:circleapp/view/screens/explore_section/explore_screen.dart';
import 'package:circleapp/view/screens/plan_screens/selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controller/utils/app_colors.dart';
import '../../controller/utils/global_variables.dart';
import '../../controller/utils/preference_keys.dart';
import '../../controller/utils/shared_preferences.dart';
import 'loop_screens/loop_screen.dart';
import 'message_screens/messages_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({
    super.key,
  });

  @override
  BottomNavigationScreenState createState() => BottomNavigationScreenState();
}

class BottomNavigationScreenState extends State<BottomNavigationScreen> {
  RxList<String> chatList = <String>[].obs;
  RxList<int> pinList = <int>[].obs;
  RxInt selectedIndex = 0.obs;

  RxString messageLength = ''.obs;
  final TextEditingController chatController = TextEditingController();
  RxInt currentIndex = 0.obs;
  RxInt colorIndex = 0.obs;

  @override
  void initState() {
    userToken = MySharedPreferences.getString(userTokenKey);
    Get.put(ChatSocketService()).connect(userToken);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Obx(
      () => Scaffold(
        backgroundColor: const Color(0xff343434),
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 3.h, vertical: 1.2.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex.value,
              backgroundColor: const Color(0xff2F2F2F),
              selectedItemColor: AppColors.mainColorYellow,
              unselectedItemColor: Colors.white,
              selectedLabelStyle: textTheme.bodySmall?.copyWith(fontSize: 13.sp),
              unselectedLabelStyle: textTheme.bodySmall?.copyWith(fontSize: 13.sp),
              onTap: (value) {
                // Respond to item press.
                currentIndex.value = value;
                colorIndex.value = value;
              },
              items: [
                BottomNavigationBarItem(
                    label: "Loop",
                    backgroundColor: Colors.white,
                    icon: SvgPicture.asset(
                      "assets/svg/loop.svg",
                      colorFilter: ColorFilter.mode(
                        colorIndex.value == 0 ? AppColors.mainColorYellow : Colors.white,
                        BlendMode.srcIn,
                      ),
                      height: 16.5,
                      width: 16,
                    )),
                BottomNavigationBarItem(
                    label: "Messages",
                    backgroundColor: Colors.white,
                    icon: SvgPicture.asset(
                      "assets/svg/message.svg",
                      colorFilter: ColorFilter.mode(
                        colorIndex.value == 1 ? AppColors.mainColorYellow : Colors.white,
                        BlendMode.srcIn,
                      ),
                    )),
                BottomNavigationBarItem(
                    label: "Plans",
                    backgroundColor: Colors.white,
                    icon: SvgPicture.asset(
                      "assets/svg/calender.svg",
                      colorFilter: ColorFilter.mode(
                        colorIndex.value == 2 ? AppColors.mainColorYellow : Colors.white,
                        BlendMode.srcIn,
                      ),
                      // color: colorIndex.value == 2 ? AppColors.mainColorYellow : Colors.white,
                    )),
                BottomNavigationBarItem(
                    label: "Explore",
                    backgroundColor: Colors.white,
                    icon: SvgPicture.asset(
                      "assets/svg/Explore.svg",
                      colorFilter: ColorFilter.mode(
                        colorIndex.value == 3 ? AppColors.mainColorYellow : Colors.white,
                        BlendMode.srcIn,
                      ),
                    )),
              ],
            ),
          ),
        ),
        body: Obx(
          () => currentIndex.value == 0
              ? LoopScreen(selectedIndex: 0)
              : currentIndex.value == 1
                  ? const MessagesScreen()
                  : currentIndex.value == 2
                      ? const SelectionScreen()
                      : currentIndex.value == 3
                          ? const ExploreScreen()
                          : const SizedBox(),
        ),
      ),
    );
  }
}
