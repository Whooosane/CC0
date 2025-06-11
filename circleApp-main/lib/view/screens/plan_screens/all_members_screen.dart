import 'dart:developer';
import 'package:circleapp/controller/getx_controllers/auth_controller.dart';
import 'package:circleapp/controller/getx_controllers/circle_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/models/all_users_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/utils/global_variables.dart';
import '../../../models/circle_models/circle_members_model.dart';
import '../../custom_widget/customwidgets.dart';

class AllMembersScreen extends StatefulWidget {
  final bool showAll;
  final String? circleId;
  const AllMembersScreen({super.key, required this.showAll, this.circleId});

  @override
  State<AllMembersScreen> createState() => _AllMembersScreenState();
}

class _AllMembersScreenState extends State<AllMembersScreen> {
  late AuthController authController;
  late CircleController circleController;
  RxList<Datum> selectedUsers = <Datum>[].obs;
  RxList<Member> selectedCircleUsers = <Member>[].obs;
  TextEditingController searchController = TextEditingController();
  RxList<Datum> filteredUsers = <Datum>[].obs;
  RxList<Member> filteredCircleUsers = <Member>[].obs;

  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController(context));
    circleController = Get.put(CircleController(context));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.showAll)
        {
          authController.getAllUsers();
          authController.allUsersModel.listen((model) {
            if (model != null) {
              filteredUsers.value = model.data;
            }
          });
          searchController.addListener(_filterUsers);
        }
      else
        {
          circleController.getCircleMembers(load: true, circleId: widget.circleId!);
          circleController.circleMembersModel.listen((model) {
            if (model != null) {
              filteredCircleUsers.value = model.members;
            }
          });
          searchController.addListener(_filterCircleUsers);
        }
    });
  }

  void _filterUsers() {
    final query = searchController.text.toLowerCase();
    final allUsers = authController.allUsersModel.value?.data ?? [];
    if (query.isEmpty) {
      filteredUsers.value = allUsers;
    } else {
      filteredUsers.value =
          allUsers.where((user) => user.name.toLowerCase().contains(query) || user.phoneNumber.toLowerCase().contains(query)).toList();
    }
  }

  void _filterCircleUsers() {
    final query = searchController.text.toLowerCase();
    final allUsers = circleController.circleMembersModel.value?.members ?? [];
    if (query.isEmpty) {
      filteredCircleUsers.value = allUsers;
    } else {
      filteredCircleUsers.value =
          allUsers.where((user) => user.name.toLowerCase().contains(query) || user.phoneNumber.toLowerCase().contains(query)).toList();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Obx(() {
        return SizedBox(
          height: Device.height,
          width: Device.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getVerticalSpace(6.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 2.h,
                        ),
                      ),
                    ),
                    getHorizentalSpace(1.5.h),
                    Text(
                      'Add Members',
                      style: CustomTextStyle.headingStyle,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.h, bottom: 2.5.h),
                  child: Text(
                    'Select circle members',
                    style: CustomTextStyle.hintText.copyWith(color: const Color(0xffF8F8F8)),
                  ),
                ),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name or number',
                    hintStyle: CustomTextStyle.hintText.copyWith(color: const Color(0xffF8F8F8)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: AppColors.textFieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.px),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                widget.showAll && authController.loading.value || !widget.showAll && circleController.loading.value
                    ? Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: 15,
                          itemBuilder: (BuildContext context, int index) {
                            return Shimmer.fromColors(
                              baseColor: AppColors.shimmerColor1,
                              highlightColor: AppColors.shimmerColor2,
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                height: 5.h,
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(30.px),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: widget.showAll ? filteredUsers.length : filteredCircleUsers.length,
                          itemBuilder: (context, index) {
                            Datum user = widget.showAll ? filteredUsers[index] : Datum(id: filteredCircleUsers[index].id, phoneNumber: filteredCircleUsers[index].phoneNumber, name: filteredCircleUsers[index].name, email: "", profilePicture: filteredCircleUsers[index].profilePicture);
                            selectedUsers.contains(user);
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              child: Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    selectedUsers.contains(user) ? selectedUsers.remove(user) : selectedUsers.add(user);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 5.px),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.px),
                                      color: const Color(0xff313131),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: Image.network(
                                            user.profilePicture ?? "",
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
                                        getHorizentalSpace(1.h),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              user.name,
                                              style: CustomTextStyle.headingStyle.copyWith(fontSize: 12.px),
                                            ),
                                            Text(
                                              user.phoneNumber,
                                              style: CustomTextStyle.hintText.copyWith(color: Colors.white.withOpacity(0.49)),
                                            )
                                          ],
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 2.h,
                                          width: 2.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: selectedUsers.contains(user) ? AppColors.textFieldColor : AppColors.secondaryColor,
                                            ),
                                          ),
                                          child: selectedUsers.contains(user)
                                              ? SvgPicture.asset('assets/svg/selected.svg', fit: BoxFit.cover)
                                              : SvgPicture.asset(
                                                  'assets/svg/unselected.svg',
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),
                getVerticalSpace(2.h),
                customButton(
                  onTap: () {
                    log("Selected Users inner ${selectedUsers.length}");
                    Get.back(result: selectedUsers);
                  },
                  backgroundColor: AppColors.secondaryColor,
                  borderColor: AppColors.primaryColor,
                  title: 'Done',
                  titleColor: Colors.black,
                  height: 4.5.h,
                ),
                getVerticalSpace(2.5.h),
              ],
            ),
          ),
        );
      }),
    );
  }
}
