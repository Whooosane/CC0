import 'dart:developer';
import 'package:circleapp/controller/getx_controllers/circle_controller.dart';
import 'package:circleapp/controller/getx_controllers/share_in_group_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/controller/utils/preference_keys.dart';
import 'package:circleapp/controller/utils/shared_preferences.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class ShareGroupScreen extends StatefulWidget {
  final String titleKey;
  final String titleId;
  const ShareGroupScreen({super.key, required this.titleKey, required this.titleId});

  @override
  State<ShareGroupScreen> createState() => _ShareGroupScreenState();
}

class _ShareGroupScreenState extends State<ShareGroupScreen> {
  late final CircleController circleController = Get.put(CircleController(context));
  final ShareInGroupController shareInGroupController = Get.put(ShareInGroupController());
  final RxList<String> selectedCircles = <String>[].obs;
  final RxString token = "".obs;

  @override
  void initState() {
    super.initState();
    token.value = MySharedPreferences.getString(userTokenKey);
    circleController.getCircles(load: circleController.getCircleModel.value == null);
  }

  // Show loading dialog
  void _showLoadingDialog() {
    Get.dialog(
      Center(
        child: Container(
          padding: EdgeInsets.all(3.h),
          decoration: BoxDecoration(
            color: AppColors.textFieldColor,
            borderRadius: BorderRadius.circular(12.px),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainColorYellow),
              ),
              SizedBox(height: 2.h),
              Text(
                "Sharing to groups...",
                style: CustomTextStyle.mediumTextTitle.copyWith(
                  fontSize: 16.px,
                  color: AppColors.mainColorOffWhite,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none, // Explicitly remove underline
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }
  // Handle share action with feedback
  void _handleShare() async {
    if (selectedCircles.isEmpty) {
      Get.snackbar(
        'No Groups Selected',
        'Please select at least one group to share.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.textFieldColor,
        colorText: Colors.white,
        margin: EdgeInsets.all(2.h),
        borderRadius: 12.px,
      );
      return;
    }

    _showLoadingDialog();
    String type;
    if (widget.titleKey == "offerId") {
      type = "offer";
    } else if (widget.titleKey == "planId") {
      type = "plan";
    } else {
      type = "itinerary";
    }

    try {
      await shareInGroupController.shareInGroupController(
        circleIds: selectedCircles,
        itineraryId: widget.titleId,
        type: type,
        token: token.value,
        itemIdKey: widget.titleKey,
      );

      Get.back(); // Close loading dialog
      Get.snackbar(
        'Success',
        'Successfully shared to ${selectedCircles.length} group${selectedCircles.length > 1 ? 's' : ''}!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.mainColorYellow,
        colorText: Colors.black,
        margin: EdgeInsets.all(2.h),
        borderRadius: 12.px,
        duration: const Duration(seconds: 2),
      );
      Get.back(); // Navigate back to previous screen
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to share. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: EdgeInsets.all(2.h),
        borderRadius: 12.px,
      );
      log("Share error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.mainColorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.mainColorBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Share",
          style: CustomTextStyle.headingStyle.copyWith(fontSize: 18.px, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h, ),
            child: GestureDetector(
              onTap: _handleShare,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  border: Border.all(color:  AppColors.mainColorYellow),
                  borderRadius: BorderRadius.circular(20.px),
                ),
                child: Text(
                  "Done",
                  style: CustomTextStyle.mediumTextDone.copyWith(
                    color: Colors.white,
                    fontSize: 14.px,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVerticalSpace(2.h),
            Text(
              "Select groups you want to share in",
              style: CustomTextStyle.hintText.copyWith(
                color: AppColors.mainColorOffWhite.withOpacity(0.6),
                fontSize: 14.px,
                fontWeight: FontWeight.w400,
              ),
            ),
            getVerticalSpace(2.h),
            Expanded(
              child: circleController.loading.value
                  ? _buildShimmerList()
                  : circleController.getCircleModel.value?.circles.isEmpty ?? true
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: circleController.getCircleModel.value!.circles.length,
                itemBuilder: (context, index) {
                  final circle = circleController.getCircleModel.value!.circles[index];
                  return Obx(() => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(bottom: 1.5.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.px),
                      color: selectedCircles.contains(circle.id)
                          ? AppColors.textFieldColor.withOpacity(0.8)
                          : AppColors.textFieldColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      onTap: () {
                        if (selectedCircles.contains(circle.id)) {
                          selectedCircles.remove(circle.id);
                        } else {
                          selectedCircles.add(circle.id);
                        }
                        selectedCircles.refresh();
                        log("Selected circles: $selectedCircles");
                      },
                      contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                      title: Text(
                        circle.circleName,
                        style: CustomTextStyle.mediumTextTitle.copyWith(fontSize: 16.px),
                      ),
                      subtitle: Text(
                        circle.lastMessage.isEmpty ? "No recent messages" : circle.lastMessage,
                        style: CustomTextStyle.mediumTextSubtitle.copyWith(
                          fontSize: 12.px,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: CircleAvatar(
                        radius: 24.px,
                        backgroundColor: AppColors.textFieldColor,
                        backgroundImage: circle.circleImage.isNotEmpty
                            ? NetworkImage(circle.circleImage)
                            : const AssetImage("assets/png/Avatar1.jpg") as ImageProvider,
                      ),
                      trailing: Container(
                        height: 24.px,
                        width: 24.px,
                        decoration: BoxDecoration(
                          color: selectedCircles.contains(circle.id)
                              ? AppColors.mainColorYellow
                              : AppColors.textFieldColor,
                          borderRadius: BorderRadius.circular(12.px),
                          border: Border.all(
                            color: AppColors.mainColorYellow,
                            width: 1.5,
                          ),
                        ),
                        child: selectedCircles.contains(circle.id)
                            ? const Icon(Icons.check, size: 14, color: Colors.black)
                            : null,
                      ),
                    ),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildShimmerList() => ListView.builder(
    padding: EdgeInsets.zero,
    itemCount: 8,
    itemBuilder: (context, index) => Shimmer.fromColors(
      baseColor: AppColors.shimmerColor1,
      highlightColor: AppColors.shimmerColor2,
      child: Container(
        margin: EdgeInsets.only(bottom: 1.5.h),
        height: 8.h,
        decoration: BoxDecoration(
          color: AppColors.textFieldColor,
          borderRadius: BorderRadius.circular(12.px),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.group_outlined,
          size: 15.h,
          color: AppColors.secondaryColor.withOpacity(0.7),
        ),
        getVerticalSpace(2.h),
        Text(
          'No Circles Available',
          style: CustomTextStyle.headingStyle.copyWith(
            fontSize: 18.px,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        getVerticalSpace(1.h),
        Text(
          'Create or join a circle to start sharing with groups.',
          style: CustomTextStyle.hintText.copyWith(
            fontSize: 14.px,
            color: Colors.white.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
        getVerticalSpace(2.h),
        GestureDetector(
          onTap: () => circleController.getCircles(load: true),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 1.2.h),
            decoration: BoxDecoration(
              color: AppColors.mainColorYellow,
              borderRadius: BorderRadius.circular(25.px),
            ),
            child: Text(
              'Refresh',
              style: CustomTextStyle.mediumTextDone.copyWith(
                color: Colors.black,
                fontSize: 14.px,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}