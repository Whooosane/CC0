
import 'package:circleapp/controller/getx_controllers/circle_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/models/contact_model.dart';
import 'package:circleapp/view/custom_widget/custom_loading_button.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class AddMembers extends StatefulWidget {
  const AddMembers({super.key});

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  final contactsSelection = <ContactSelection>[].obs;
  late CircleController controller;

  @override
  void initState() {
    super.initState();
    print("DEBUG: Initializing AddMembersState");
    controller = Get.put(CircleController(context));
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    print("DEBUG: Fetching contacts");
    try {
      var value = await controller.getContacts();
      if (!mounted) return;
      if (value != null && value.isNotEmpty) {
        contactsSelection.assignAll(value);
        print("DEBUG: Loaded ${value.length} contacts");
      } else {
        customScaffoldMessenger("No contacts found in your phone");
        print("DEBUG: No contacts found");
      }
    } catch (e) {
      if (!mounted) return;
      customScaffoldMessenger("Failed to load contacts: $e");
      print("ERROR: Failed to load contacts: $e");
    }
  }

  @override
  void dispose() {
    print("DEBUG: Disposing AddMembersState");
    Get.delete<CircleController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Obx(
            () => SizedBox(
          height: Device.height,
          width: Device.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        print("DEBUG: Back button tapped");
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 2.h),
                      ),
                    ),
                    SizedBox(width: 1.5.h),
                    Text('Add Members', style: CustomTextStyle.headingStyle),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.h, bottom: 2.5.h),
                  child: Text(
                    'Select circle members from your contacts',
                    style: CustomTextStyle.hintText
                        .copyWith(color: const Color(0xffF8F8F8)),
                  ),
                ),
                Expanded(
                  child: controller.contactsLoading.value
                      ? _buildShimmerLoading()
                      : contactsSelection.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: contactsSelection.length,
                    itemBuilder: (context, index) => Obx(
                          () => Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: GestureDetector(
                          onTap: () {
                            print(
                                "DEBUG: Tapped contact: ${contactsSelection[index].contact.displayName}");
                            contactsSelection[index].isSelected =
                            !contactsSelection[index].isSelected;
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.5.h, vertical: .5.h),
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(30.px),
                              color: const Color(0xff313131),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 2.5.h,
                                  backgroundColor:
                                  AppColors.textFieldColor,
                                  backgroundImage: const AssetImage(
                                      'assets/png/members.png'),
                                ),
                                SizedBox(width: 1.h),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      contactsSelection[index]
                                          .contact
                                          .displayName,
                                      style: CustomTextStyle
                                          .headingStyle
                                          .copyWith(fontSize: 12.px),
                                    ),
                                    Text(
                                      contactsSelection[index]
                                          .contact
                                          .phones
                                          .isNotEmpty
                                          ? contactsSelection[index]
                                          .contact
                                          .phones
                                          .first
                                          .number
                                          : '(none)',
                                      style: CustomTextStyle.hintText
                                          .copyWith(
                                          color: Colors.white
                                              .withOpacity(0.49)),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    if (!contactsSelection[index]
                                        .isUser)
                                      Text(
                                        "Invite",
                                        style: CustomTextStyle.hintText
                                            .copyWith(
                                            color: Colors.white
                                                .withOpacity(
                                                0.49)),
                                      ),
                                    SizedBox(width: 4.w),
                                    Container(
                                      height: 2.h,
                                      width: 2.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: contactsSelection[
                                          index]
                                              .isSelected
                                              ? AppColors
                                              .textFieldColor
                                              : AppColors
                                              .secondaryColor,
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        contactsSelection[index]
                                            .isSelected
                                            ? 'assets/svg/selected.svg'
                                            : 'assets/svg/unselected.svg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                controller.contactsLoading.value?const SizedBox.shrink(): CustomLoadingButton(
                  onPressed: () async {
                    if (Get.arguments == null) {
                      customScaffoldMessenger('No arguments provided. Please try again.');
                      return;
                    }
                      // Print selected contacts for debugging
                      final selected = contactsSelection.where((e) => e.isSelected).toList();
                      for (var contact in selected) {
                        final name = contact.contact.displayName;
                        final phone = contact.contact.phones.isNotEmpty
                            ? contact.contact.phones.first.number
                            : '(no number)';
                        print("Name: $name | Phone: $phone");
                      }

                      // Safely access Get.arguments with fallbacks
                      final circleName = Get.arguments["text"]?.toString() ?? '';
                      final circleImage = Get.arguments["imageUrl"]?.toString() ?? '';
                      final description = Get.arguments["description"]?.toString() ?? '';
                      final type = Get.arguments["type"]?.toString() ?? 'Friend';
                      final circleInterests = (Get.arguments["circle_interests"] as List<dynamic>?)?.cast<String>() ?? [];

                      // Validate required fields
                      if (circleName.isEmpty) {
                        customScaffoldMessenger('Circle name is required.');
                        return;
                      }
                      if (circleImage.isEmpty) {
                        customScaffoldMessenger('Circle image is required.');
                        return;
                      }
                      if (description.isEmpty) {
                        customScaffoldMessenger('Description is required.');
                        return;
                      }

                      // Call createCircle API
                      await controller.createCircle(
                        load: true,
                        circleName: circleName,
                        circleImage: circleImage,
                        description: description,
                        type: type,
                        circleInterests: circleInterests,
                        contactsSelection: selected,
                      );


                  },
                  loading: controller.createCircleLoading,
                  buttonText: 'Done',
                ),
                SizedBox(height: 2.5.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    print("DEBUG: Showing shimmer loading");
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 15,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: AppColors.shimmerColor1,
        highlightColor: AppColors.shimmerColor2,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          height: 5.h,
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(30.px),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    print("DEBUG: Showing empty state");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.group, size: 12.h, color: AppColors.secondaryColor),
        SizedBox(height: 2.h),
        Text(
          'No Contacts Found',
          style:
          CustomTextStyle.headingStyle.copyWith(color: Colors.white),
        ),
        SizedBox(height: 1.h),
        Text(
          'It looks like we couldn’t find any contacts. Try refreshing or check your permissions.',
          style: CustomTextStyle.hintText
              .copyWith(color: const Color(0xffF8F8F8)),
          textAlign: TextAlign.center,
        ),
        getVerticalSpace(3.h),
        GestureDetector(
          onTap: () {
            print("DEBUG: Retry fetching contacts tapped");
            _fetchContacts();
          },
          child: Container(
            padding:
            EdgeInsets.symmetric(horizontal: 4.h, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: AppColors.textFieldColor,
              borderRadius: BorderRadius.circular(30.px),
            ),
            child: Text(
              'Retry Fetching Contacts',
              style: CustomTextStyle.smallText.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        getVerticalSpace(4.h)
      ],
    );
  }
}