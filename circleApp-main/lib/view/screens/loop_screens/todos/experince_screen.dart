import 'package:circleapp/controller/getx_controllers/circle_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class ExperienceScreen extends StatefulWidget {
  final String circleId;

  const ExperienceScreen({super.key, required this.circleId});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  late CircleController circleController;

  @override
  void initState() {
    super.initState();
    circleController = Get.put(CircleController(context));
    circleController.getExperienceController(load: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
            children: [

              Expanded(
                child: Obx(
                      () => SingleChildScrollView(
                        padding: EdgeInsets.zero,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upcoming Plans",
                          style: CustomTextStyle.mediumTextM14,
                        ),
                        SizedBox(height: 3.px),
                        circleController.loading.value
                            ? _buildShimmerList(3)
                            : circleController.getExperienceModel.value == null ||
                            circleController.getExperienceModel.value!.data.bookedOffers.isEmpty
                            ? _buildEmptyState(
                          "No upcoming plans yet.",
                          "Explore offers to book your next experience!",
                        )
                            : _buildBookedPlansList(),
                        SizedBox(height: 15.px),
                        Text(
                          "Saved Plans",
                          style: CustomTextStyle.mediumTextM14,
                        ),
                        SizedBox(height: 6.px),
                        circleController.loading.value
                            ? _buildShimmerList(3)
                            : circleController.getExperienceModel.value == null ||
                            circleController.getExperienceModel.value!.data.savedOffers.isEmpty
                            ? _buildEmptyState(
                          "No saved plans yet.",
                          "Save offers to plan your future experiences!",
                        )
                            : _buildSavedPlansList(),
                        SizedBox(height: 20.px),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookedPlansList() {
    final bookedOffers = circleController.getExperienceModel.value!.data.bookedOffers;
    return Column(
      children: List.generate(
        bookedOffers.length,
            (index) {
          final offer = bookedOffers[index];
          return Container(
            margin: EdgeInsets.only(top: 10.px),
            padding: EdgeInsets.symmetric(horizontal: 2.2.h, vertical: 2.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.textFieldColor,
            ),
            child: experiencePlanCard(
              title: offer.title,
              description: offer.description,
              interest: offer.interest,
              price: offer.price,
              startingDate: offer.startingDate,
              numberOfPeople: offer.numberOfPeople,
              imageUrls: offer.imageUrls,
              showShare: true,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSavedPlansList() {
    final savedOffers = circleController.getExperienceModel.value!.data.savedOffers;
    return Column(
      children: List.generate(
        savedOffers.length,
            (index) {
          final offer = savedOffers[index];
          return Container(
            margin: EdgeInsets.only(top: 10.px),
            padding: EdgeInsets.symmetric(horizontal: 2.2.h, vertical: 2.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.textFieldColor,
            ),
            child: offerCard(
              title: offer.title,
              titleId: offer.id,
              description: offer.description,
              interest: offer.interest,
              price: offer.price,
              startingDate: offer.startingDate,
              numberOfPeople: offer.numberOfPeople,
              imageUrls: offer.imageUrls,
              showShare: true,
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerList(int count) {
    return Column(
      children: List.generate(
        count,
            (index) => Container(
          margin: EdgeInsets.only(top: 10.px),
          padding: EdgeInsets.symmetric(horizontal: 2.2.h, vertical: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.textFieldColor,
          ),
          child: Shimmer.fromColors(
            baseColor: AppColors.textFieldColor.withOpacity(0.6),
            highlightColor: AppColors.textFieldColor.withOpacity(0.2),
            child: Container(
              height: 100.px,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Container(
      height: 30.h,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 50.px,
            color: Colors.white.withOpacity(0.5),
          ),
          SizedBox(height: 15.px),
          Text(
            title,
            style: CustomTextStyle.mediumTextM14.copyWith(
              color: Colors.white,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.px),
          Text(
            subtitle,
            style: CustomTextStyle.smallText.copyWith(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.px),
          GestureDetector(
            onTap: () {
              customScaffoldMessenger("Explore offers coming soon!");
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: AppColors.mainColorYellow),
              ),
              child: Text(
                "Explore Offers",
                style: CustomTextStyle.mediumTextYellow.copyWith(fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}