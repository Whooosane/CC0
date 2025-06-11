import 'package:circleapp/controller/getx_controllers/auth_controller.dart';
import 'package:circleapp/controller/getx_controllers/convos_controller.dart';
import 'package:circleapp/controller/getx_controllers/messenger_controller.dart';
import 'package:circleapp/controller/getx_controllers/stories_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/common_methods.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/controller/utils/global_variables.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:circleapp/view/custom_widget/media_widget.dart' show mediaWidget;
import 'package:circleapp/view/screens/loop_screens/add_story_screen.dart';
import 'package:circleapp/view/screens/loop_screens/convos/story_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
Widget convosWidget({
  required BuildContext mContext,
  StoryController? storyController,
  String? userImageUrl,
  required String token,
  required String circleId,
  required ConvosController convosController,
})
{
  // Initialize MessengerController for media handling
  final MessengerController messengerController = Get.find<MessengerController>();
  final f = DateFormat('dd/MM/yyy');

  return Obx(() {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 12.h,
            child: storyController?.loading.value == true
                ? Shimmer.fromColors(
              baseColor: AppColors.shimmerColor1,
              highlightColor: AppColors.shimmerColor2,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemExtent: 10.h,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: .8.h),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                    ),
                  );
                },
              ),
            )
                : Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: .8.h),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(() => CreateStoryScreen(circleId: circleId)),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.secondaryColor),
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  Get.put(AuthController(mContext))
                                      .currentUserModel
                                      .value
                                      ?.data
                                      .profilePicture ??
                                      userimagePlaceholder,
                                ),
                                radius: 30,
                              ),
                            ),
                            Positioned(
                              bottom: 1.px,
                              right: 0,
                              child: Container(
                                height: 25.px,
                                width: 25.px,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.add, size: 15.px, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.px),
                      const Text(
                        'Your Story',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                if (storyController?.storiesModel.value?.data.isNotEmpty ?? false)
                  SizedBox(
                    width: 70.w,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: storyController?.storiesModel.value?.data.length,
                      itemBuilder: (context, index) {
                        final story = storyController!.storiesModel.value!.data[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: .8.h),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => Get.to(() => StoryScreen(
                                  stories: Stories(
                                    imageUrl: storyController
                                        .storiesModel.value?.data[index].user.profilePicture ??
                                        "",
                                    userName: storyController
                                        .storiesModel.value?.data[index].user.name ??
                                        "",
                                    stories: storyController
                                        .storiesModel.value?.data[index].stories ??
                                        [],
                                  ),
                                )),
                                child: Container(
                                  height: 62.px,
                                  width: 62.px,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.secondaryColor),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 5.6.h,
                                    backgroundColor: AppColors.mainColor,
                                    backgroundImage: NetworkImage(story.user.profilePicture),
                                  ),
                                ),
                              ),
                              SizedBox(height: 3.px),
                              Text(
                                story.user.name,
                                style: const TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          convosController.getConvosLoading.value
              ? Expanded(
            child: Shimmer.fromColors(
              baseColor: AppColors.shimmerColor1,
              highlightColor: AppColors.shimmerColor2,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.3.h),
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(10.px),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
              : convosController.convosModel.value?.data.isEmpty ?? true
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getVerticalSpace(8.h),
              Icon(
                Icons.chat,
                size: 12.h,
                color: AppColors.secondaryColor,
              ),
              SizedBox(height: 2.h),
              Text(
                'No Convos Yet',
                style: CustomTextStyle.headingStyle.copyWith(
                  color: Colors.white,
                  fontSize: 14.px,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Start a chat with your circle to share updates and ideas!',
                style: CustomTextStyle.hintText.copyWith(color: const Color(0xffF8F8F8)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              GestureDetector(
                onTap: () => convosController.getConvos(isLoading: true, circleId: circleId, token: token),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: AppColors.textFieldColor,
                    borderRadius: BorderRadius.circular(30.px),
                  ),
                  child: Text(
                    'Refresh Convos',
                    style: CustomTextStyle.smallText.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )
              : Expanded(
            child: ListView.builder(
              itemCount: convosController.convosModel.value?.data.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final convos = convosController.convosModel.value!.data[index];
                final profilePicture = convos.type == 'plan'
                    ? (convos.planDetails!.createdBy.profilePicture)
                    : convos.type == 'itinerary'
                    ? convos.senderProfilePicture
                    : convos.type == 'offer'
                    ? (convos.offerDetails!.imageUrls.isNotEmpty
                    ? convos.offerDetails!.imageUrls[0]
                    : convos.senderProfilePicture)
                    : convos.senderProfilePicture;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.3.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: Image.network(
                          profilePicture.toString(),
                          fit: BoxFit.cover,
                          width: 35,
                          height: 35,
                          errorBuilder: (context, error, stackTrace) => Image.network(
                            circleImagePlaceholder,
                            fit: BoxFit.cover,
                            width: 35,
                            height: 35,
                          ),
                        ),
                      ),
                      getHorizentalSpace(3.w),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (convos.type == "plan")
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 2.2.h, vertical: 2.h),
                                width: 60.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.textFieldColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                      Text(
                                        convos.planDetails!.planName.toString(),
                                        style: CustomTextStyle.headingStyle.copyWith(fontSize: 14.px),
                                      ),

                                      Text(
                                      f.format(DateTime.parse(convos.planDetails!.date.toString())),
                                        style: CustomTextStyle.headingStyle.copyWith(fontSize: 14.px),
                                      ),
                                    ],),
                                    SizedBox(height: 4.px),
                                    Text(
                                      convos.planDetails!.description,
                                      style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: Colors.white70),
                                    ),
                                    SizedBox(height: 4.px),
                                    Row(children: [
                                      SvgPicture.asset("assets/svg/Location.svg"),
                                      Text(
                                        convos.planDetails!.location,
                                        style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: Colors.white70),
                                      ),
                                    ],),
                                    SizedBox(height: 10.px),
                                    Text("Added members",style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: Colors.white,fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 10.px),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: convos.planDetails!.members.take(3).map((member) {
                                            return Padding(
                                              padding: EdgeInsets.only(right: 5.px),
                                              child: ClipOval(
                                                child: Image.network(
                                                  member.profilePicture,
                                                  fit: BoxFit.cover,
                                                  width: 25,
                                                  height: 25,
                                                  errorBuilder: (_, __, ___) => Image.network(
                                                    circleImagePlaceholder,
                                                    fit: BoxFit.cover,
                                                    width: 25,
                                                    height: 25,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.mainColorYellow,
                                            borderRadius: BorderRadius.circular(100.px),
                                            border: Border.all(color: AppColors.mainColorYellow),
                                          ),
                                          child: Text(
                                            "Booked",
                                            style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: AppColors.mainColorBackground),
                                          ),
                                        ),
                                      ],),
                                  ],
                                ),
                              )
                            else if (convos.type == "offer")
                                  Container(
                                padding: EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 1.h),
                                width: 60.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.textFieldColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      convos.offerDetails?.title.toString()??"",
                                      style: CustomTextStyle.headingStyle.copyWith(fontSize: 14.px),
                                    ),
                                    SizedBox(height: 5.px),
                                    Text(
                                      convos.offerDetails?.description??"",
                                      style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: Colors.white70),
                                    ),
                                    SizedBox(height: 10.px),
                                    ...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: convos.offerDetails!.imageUrls.take(3).map((url) {
                                            return Padding(
                                              padding: EdgeInsets.only(right: 5.px),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(100.px),
                                                child: Image.network(
                                                  url,
                                                  fit: BoxFit.cover,
                                                  width: 40,
                                                  height: 40,
                                                  errorBuilder: (_, __, ___) => Container(
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            // Get.to(() => OfferDetails(offer: convos.offerDetails!,currentUserId:  currentUserId,));
                                          },
                                          child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100.px),
                                            border: Border.all(color: AppColors.mainColorYellow),
                                          ),
                                          child: Text(
                                            "View Details",
                                            style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: AppColors.mainColorYellow),
                                          ),
                                        ),),
                                      ],
                                    ),
                                  ],
                                  ],
                                ),
                              )
                            else if (convos.type == "itinerary")
                                  Container(
                                  padding: EdgeInsets.symmetric(horizontal: 2.2.h, vertical: 1.h),
                                  width: 60.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.textFieldColor.withOpacity(0.5),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.fiber_manual_record, size: 12.px, color: Colors.white),
                                          SizedBox(width: 10.px),
                                          Expanded(
                                            child: Text(
                                              convos.itineraryDetails?.name??"",
                                              style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: Colors.white),
                                            ),
                                          ),
                                          Text(
                                            convos.itineraryDetails?.time??"",
                                            style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: Colors.white70),
                                          ),
                                          SizedBox(width: 10.px),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 6.w),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                convos.itineraryDetails?.about??"",
                                                style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: AppColors.mainColorYellow),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else if (convos.media.isNotEmpty)
                                  Container(
                                    width: 60.w,
                                    padding: EdgeInsets.all(5.px),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.textFieldColor,
                                      borderRadius: BorderRadius.circular(10.px),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        mediaWidget(
                                          convos.media,
                                          context: mContext,
                                          messengerController: messengerController,
                                          isCurrentUser: false,
                                          messageId: convos.id,
                                          index: index,
                                        ),
                                        if (convos.media.first.type != "audio")
                                          Container(
                                            margin: EdgeInsets.symmetric(vertical: 15.px),
                                            child: Text(
                                              convos.text.toString(),
                                              style: CustomTextStyle.messageDetailText,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                                else
                                  Container(
                                    width: 60.w,
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.textFieldColor,
                                      borderRadius: BorderRadius.circular(10.px),
                                    ),
                                    child: Text(convos.text.toString(), style: CustomTextStyle.messageDetailText),
                                  ),
                                  Container(
                              margin: EdgeInsets.only(top: 5.px, bottom: 15.px),
                              child: Text(
                                getCurrentTimeIn12HourFormat(DateTime.parse(convos.sentAt.toString())),
                                style: CustomTextStyle.messageDetailDate,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  });
}