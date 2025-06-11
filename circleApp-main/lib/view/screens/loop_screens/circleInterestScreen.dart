import 'package:circleapp/controller/getx_controllers/circle_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/controller/utils/shared_preferences.dart';
import 'package:circleapp/models/contact_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'addMembersScreen.dart';

class CircleInterest extends StatefulWidget {
  const CircleInterest({super.key});

  @override
  State<CircleInterest> createState() => _CircleInterestState();
}

class _CircleInterestState extends State<CircleInterest> {
  final myContacts = <ContactSelection>[].obs;
  late CircleController controller;
  final selectedIndexes = <int>[].obs;
  final interests = <String>[].obs;
  final userInterests = <String>[].obs;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CircleController(context));
    interests.addAll(['Photography', 'Shopping', 'Music', 'Movies', 'Fitness', 'Travelling', 'Sports', 'Video Games', 'Night Out', 'Art']);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchUserInterests(load: true).then((_) {
        if (controller.userInterestsModel.value != null) {
          interests.addAll(controller.userInterestsModel.value!.interests);
          interests.refresh();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primaryColor,
      body: Obx(
            () => Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 1.5.h),
          child: Column(
            children: [
              SizedBox(height: 6.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 2.h),
                  ),
                  SizedBox(width: 1.5.h),
                  Text('Circle interests', style: CustomTextStyle.headingStyle),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                'share what your group is interested in and activities you participate in to receive exclusive offers for your circle!',
                style: CustomTextStyle.hintText.copyWith(color: const Color(0xffF8F8F8)),
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: interests.isEmpty
                    ? _buildEmptyState(context)
                    : Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: interests.length,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 2.h,
                          mainAxisSpacing: 1.4.h,
                          childAspectRatio: 4,
                        ),
                        itemBuilder: (context, index) => Obx(
                              () => GestureDetector(
                            onTap: () {
                              selectedIndexes.contains(index) ? selectedIndexes.remove(index) : selectedIndexes.add(index);
                            },
                            child: customRadioButton(
                              title: interests[index],
                              borderColor: selectedIndexes.contains(index) ? AppColors.textFieldColor : AppColors.secondaryColor,
                              assetsImage: SvgPicture.asset(
                                  selectedIndexes.contains(index) ? 'assets/svg/selected.svg' : 'assets/svg/unselected.svg'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    _buildAddInterestButton(context),
                    SizedBox(height: 2.h),
                    customButton(
                      onTap: () {
                        if (selectedIndexes.isNotEmpty) {
                          Get.to(() => const AddMembers(), arguments: {
                            'text': Get.arguments['text'],
                            'description': Get.arguments['description'],
                            'type': Get.arguments['type'],
                            'imageUrl': Get.arguments['imageUrl'],
                            'circle_interests': selectedIndexes.map((index) => interests[index]).toList(),
                          });
                        } else {
                          customScaffoldMessenger("Please select at least one interest");
                        }
                      },
                      backgroundColor: AppColors.secondaryColor,
                      borderColor: AppColors.primaryColor,
                      title: 'Continue',
                      titleColor: Colors.black,
                      height: 5.h,
                    ),
                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/svg/empty_interests.svg', // Ensure you have an appropriate SVG asset
          height: 20.h,
          color: AppColors.secondaryColor,
        ),
        SizedBox(height: 2.h),
        Text(
          'No Interests Yet!',
          style: CustomTextStyle.headingStyle.copyWith(color: Colors.white),
        ),
        SizedBox(height: 1.h),
        Text(
          'Add interests to personalize your circle and unlock exclusive offers.',
          style: CustomTextStyle.hintText.copyWith(color: const Color(0xffF8F8F8)),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 3.h),
        GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (context) => interestsDialog(onLogout: (newInterest) {
              if (newInterest.isNotEmpty) {
                interests.add(newInterest);
                userInterests.add(newInterest);
                MySharedPreferences.setListString('user_interests', userInterests);
              }
            }),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: AppColors.textFieldColor,
              borderRadius: BorderRadius.circular(30.px),
            ),
            child: Text(
              'Add Your First Interest',
              style: CustomTextStyle.smallText.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddInterestButton(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => interestsDialog(onLogout: (newInterest) {
          if (newInterest.isNotEmpty) {
            interests.add(newInterest);
            userInterests.add(newInterest);
            MySharedPreferences.setListString('user_interests', userInterests);
          }
        }),
      ),
      child: Container(
        alignment: Alignment.center,
        height: 5.h,
        decoration: BoxDecoration(color: AppColors.textFieldColor, borderRadius: BorderRadius.circular(30.px)),
        child: Row(
          children: [
            SizedBox(width: 2.h),
            const Icon(Icons.add, color: Colors.white),
            SizedBox(width: 2.h),
            Text("Add Interest", style: CustomTextStyle.smallText),
          ],
        ),
      ),
    );
  }
}