import 'dart:developer';
import 'package:circleapp/controller/getx_controllers/auth_controller.dart';
import 'package:circleapp/controller/getx_controllers/circle_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/global_variables.dart';
import 'package:circleapp/controller/utils/shared_preferences.dart';
import 'package:circleapp/controller/utils/style/customTextStyle.dart';
import 'package:circleapp/models/circle_models/get_circle_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:circleapp/view/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'circle_detail_screen.dart';

class LoopScreen extends StatefulWidget {
  final int selectedIndex;
  const LoopScreen({super.key, required this.selectedIndex});

  @override
  State<LoopScreen> createState() => _LoopScreenState();
}

class _LoopScreenState extends State<LoopScreen> {
  late CircleController circleController;
  late AuthController authController;
  RxString token = "".obs;

  @override
  void initState() {
    circleController = Get.put(CircleController(context));
    authController = Get.put(AuthController(context));
    authController.getCurrentUser();
    circleController.getCircles(load: circleController.getCircleModel.value == null);
    token.value = MySharedPreferences.getString(userToken);
    log("token.value: ${token.value}");
    super.initState();
  }

  DateTime parseCustomDate(String date) {
    try {
      return DateTime.parse(date); // Parse ISO 8601 format
    } catch (e) {
      return DateTime.now().toUtc(); // Fallback to current UTC time
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.mainColorBackground,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.h),
          child: Column(
            children: [
              getVerticalSpace(7.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Welcome to Circle!",
                    style: CustomTextStyle.mediumTextExplore,
                  ),
                  authController.loading.value
                      ? Shimmer.fromColors(
                    baseColor: AppColors.shimmerColor1,
                    highlightColor: AppColors.shimmerColor2,
                    child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.bottomCenter,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                    ),
                  )
                      : GestureDetector(
                    onTap: () {
                      Get.to(() => const ProfileScreen());
                    },
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: authController.currentUserModel.value?.data.profilePicture.isNotEmpty == true
                          ? NetworkImage(authController.currentUserModel.value!.data.profilePicture)
                          : NetworkImage(userimagePlaceholder),
                      child: authController.currentUserModel.value?.data.profilePicture.isNotEmpty != true ? null : null,
                    ),
                  ),
                ],
              ),
              getVerticalSpace(2.h),
              Expanded(
                child: circleController.getCircleModel.value == null
                    ? Shimmer.fromColors(
                  baseColor: AppColors.shimmerColor1,
                  highlightColor: AppColors.shimmerColor2,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(10.px),
                        ),
                      );
                    },
                  ),
                )
                    : circleController.getCircleModel.value!.circles.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: circleController.getCircleModel.value!.circles.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext, index) {
                    Circle item = circleController.getCircleModel.value!.circles[index];
                    log("item: ${item.lastMessageTime}");
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => CircleDetails(
                          circleId: circleController.getCircleModel.value!.circles[index].id,
                          userProfileImage: authController.currentUserModel.value?.data.profilePicture ?? "",
                          circleName: circleController.getCircleModel.value!.circles[index].circleName,
                        ));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 1.5.h),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.textFieldColor,
                        ),
                        child: ListTile(
                          title: Text(
                            item.circleName,
                            style: CustomTextStyle.mediumTextTitle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            item.description,
                            style: CustomTextStyle.mediumTextSubtitle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: CircleAvatar(
                            radius: 28,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                item.circleImage,
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    circleImagePlaceholder,
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  );
                                },
                              ),
                            ),
                          ),
                          trailing: Text(
                            item.lastMessageTime.isNotEmpty
                                ? timeAgoSinceDate(parseCustomDate(item.lastMessageTime))
                                : "No Pinned Mess...",
                            style: CustomTextStyle.messageItemTime,
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
      );
    });
  }

  // Professional Empty State UI with Icon
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Placeholder Icon
          Container(
            padding: EdgeInsets.all(2.h),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondaryColor.withOpacity(0.2),
            ),
            child: Icon(
              Icons.group_outlined, // Material Design icon for groups/community
              size: 15.w,
              color: AppColors.secondaryColor.withOpacity(0.7),
            ),
          ),
          getVerticalSpace(2.h),
          // Title
          Text(
            "No Circles Yet",
            style: CustomTextStyle.headingStyle.copyWith(
              color: Colors.white,
              fontSize: 18.sp,
            ),
            textAlign: TextAlign.center,
          ),
          getVerticalSpace(1.h),
          // Description
          Text(
            "It looks like you haven't joined or created any circles. Start by creating a new circle to connect with friends!",
            style: CustomTextStyle.mediumTextSubtitle.copyWith(
              color: Colors.white.withOpacity(0.7),
              fontSize: 15.sp,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
          getVerticalSpace(3.h),

        ],
      ),
    );
  }

  String timeAgoSinceDate(DateTime dateTime) {
    final DateTime now = DateTime.now().toUtc();
    final Duration difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final int weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    }
  }

  Widget buildMessageItem(item) {
    return Text(
      item.lastMessageTime != null && item.lastMessageTime.isNotEmpty
          ? timeAgoSinceDate(parseCustomDate(item.lastMessageTime))
          : "No Pinned Message",
      style: CustomTextStyle.messageItemTime,
    );
  }
}