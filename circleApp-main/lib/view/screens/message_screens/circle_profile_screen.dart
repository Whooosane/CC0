import 'package:circleapp/controller/getx_controllers/circle_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/models/circle_models/circle_details_model.dart';
import 'package:circleapp/view/screens/bottom_navigation_screen.dart';
import 'package:circleapp/view/screens/plan_screens/all_members_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controller/utils/global_variables.dart';
import '../../../models/all_users_model.dart';
import '../../custom_widget/customwidgets.dart';
import 'circle_edit_screen.dart';

class CircleProfileScreen extends StatefulWidget {
  final String circleId;

  const CircleProfileScreen({super.key, required this.circleId});

  @override
  State<CircleProfileScreen> createState() => _CircleProfileScreenState();
}

class _CircleProfileScreenState extends State<CircleProfileScreen> {
  late CircleController circleController;
  RxList<Datum> selectedUsers = <Datum>[].obs;

  @override
  void initState() {
    circleController = Get.put(CircleController(context));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await circleController.getCircleById(
          load: circleController.circleDetailsModel.value == null || circleController.circleDetailsModel.value?.circle.id != widget.circleId,
          circleId: widget.circleId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.mainColorBackground,
        body: Column(
          children: [
            getVerticalSpace(8.h),
            Stack(
              children: [
                Center(
                  child: circleController.loading.value
                      ? Shimmer.fromColors(
                    baseColor: AppColors.shimmerColor1,
                    highlightColor: AppColors.shimmerColor2,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.symmetric(horizontal: 5.px),
                      width: 100.px,
                      height: 100.px,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.mainColor,
                      ),
                    ),
                  )
                      : ClipOval(
                    child: Image.network(
                      circleController.circleDetailsModel.value!.circle.circleImage,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          circleImagePlaceholder,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  top: 6,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(5.px),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: '',
                          onTap: () async {
                            selectedUsers = await Get.to(() => const AllMembersScreen(showAll: true));
                            if (selectedUsers.isNotEmpty) {
                              print("Selected Users: ${selectedUsers.length}");
                              circleController
                                  .addMembersToCircle(
                                  load: true, circleId: widget.circleId, memberIds: selectedUsers.map((datum) => datum.id).toList())
                                  .then(
                                    (value) {
                                  if (value) {
                                    for (var user in selectedUsers) {
                                      circleController.circleDetailsModel.value?.circle.members
                                          .add(Owner(id: user.id, name: user.name, profilePicture: user.profilePicture ?? ""));
                                    }
                                  }
                                },
                              );
                            }
                          },
                          child: Text(
                            'Add members',
                            style: CustomTextStyle.mediumTextM14,
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: '',
                          onTap: () {
                            Get.to(() => CircleEditScreen(circleController: circleController));
                          },
                          child: Text(
                            'Edit Circle',
                            style: CustomTextStyle.mediumTextM14,
                          ),
                        ),
                        // Add more items if needed
                      ];
                    },
                    color: AppColors.textFieldColor,
                  ),
                ),
              ],
            ),
            getVerticalSpace(1.h),
            Text(
              circleController.loading.value ? "" : circleController.circleDetailsModel.value!.circle.circleName,
              style: CustomTextStyle.mediumTextTitle,
            ),
            getVerticalSpace(0.5.h),
            Text(
              circleController.loading.value ? "" : "Group: ${circleController.circleDetailsModel.value!.circle.members.length} members",
              style: CustomTextStyle.mediumTextGroup,
            ),
            getVerticalSpace(2.2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                circleController.loading.value
                    ? Shimmer.fromColors(
                  baseColor: AppColors.shimmerColor1,
                  highlightColor: AppColors.shimmerColor2,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.symmetric(horizontal: 5.px),
                    width: 56.px,
                    height: 56.px,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.mainColor,
                    ),
                  ),
                )
                    : SvgPicture.asset("assets/svg/call.svg"),
                getHorizentalSpace(3.w),
                circleController.loading.value
                    ? Shimmer.fromColors(
                  baseColor: AppColors.shimmerColor1,
                  highlightColor: AppColors.shimmerColor2,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.symmetric(horizontal: 5.px),
                    width: 56.px,
                    height: 56.px,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.mainColor,
                    ),
                  ),
                )
                    : SvgPicture.asset("assets/svg/video.svg"),
                getHorizentalSpace(3.w),
                circleController.loading.value
                    ? Shimmer.fromColors(
                  baseColor: AppColors.shimmerColor1,
                  highlightColor: AppColors.shimmerColor2,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.symmetric(horizontal: 5.px),
                    width: 56.px,
                    height: 56.px,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.mainColor,
                    ),
                  ),
                )
                    : GestureDetector(
                    onTap: (){
                      Get.offAll(()=> BottomNavigationScreen());
                    },
                    child: SvgPicture.asset("assets/svg/convas.svg")),
              ],
            ),
            getVerticalSpace(3.h),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Circle name",
                        style: CustomTextStyle.mediumTextSubtitle,
                      ),
                      Text(
                        circleController.loading.value ? "" : circleController.circleDetailsModel.value!.circle.circleName,
                        style: CustomTextStyle.mediumTextM14,
                      ),
                      Divider(
                        color: Colors.white.withOpacity(0.2),
                      ),
                      Text(
                        "description",
                        style: CustomTextStyle.mediumTextSubtitle,
                      ),
                      Text(
                        circleController.loading.value ? "" : circleController.circleDetailsModel.value!.circle.description,
                        style: TextStyle(fontSize: 10.px, fontWeight: FontWeight.w400, fontFamily: "medium", color: Colors.white.withOpacity(0.6)),
                      ),
                      Divider(
                        color: Colors.white.withOpacity(0.2),
                      ),
                      Text(
                        "Circle type",
                        style: CustomTextStyle.mediumTextSubtitle,
                      ),
                      Text(
                        circleController.loading.value ? "" : circleController.circleDetailsModel.value!.circle.type,
                        style: CustomTextStyle.mediumTextM14,
                      ),
                      Divider(
                        color: Colors.white.withOpacity(0.2),
                      ),
                      Text(
                        "Interests",
                        style: CustomTextStyle.mediumTextSubtitle,
                      ),
                      Text(
                        circleController.loading.value ? "" : circleController.circleDetailsModel.value!.circle.interest,
                        style: CustomTextStyle.mediumTextM14,
                      ),
                      Divider(
                        color: Colors.white.withOpacity(0.2),
                      ),
                      Text(
                        "Group members",
                        style: CustomTextStyle.mediumTextSubtitle,
                      ),
                      circleController.addMembersLoading.value || circleController.loading.value
                          ? SizedBox(
                        height: 250.px,
                        child: Shimmer.fromColors(
                          baseColor: AppColors.shimmerColor1,
                          highlightColor: AppColors.shimmerColor2,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: 4,
                            itemExtent: 8.h,
                            itemBuilder: (context, index) {
                              return Align(
                                alignment: Alignment.centerLeft, // Align items to the left
                                child: Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: Container(
                                    width: 50.px, // Set a specific width if needed
                                    height: 50.px, // Set a specific height if needed
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                          : ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: circleController.circleDetailsModel.value!.circle.members.length,
                          itemBuilder: (context, index) {
                            Owner ownerMember = circleController.circleDetailsModel.value!.circle.members[index];
                            return Padding(
                              padding: EdgeInsets.only(top: 1.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      ownerMember.profilePicture,
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.network(
                                          circleImagePlaceholder,
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 40,
                                        );
                                      },
                                    ),
                                  ),
                                  getHorizentalSpace(2.w),
                                  Text(
                                    ownerMember.name,
                                    style: CustomTextStyle.mediumTextTime,
                                  )
                                ],
                              ),
                            );
                          }),
                      getVerticalSpace(3.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}