import 'dart:io';

import 'package:circleapp/controller/getx_controllers/picker_controller.dart';
import 'package:circleapp/controller/getx_controllers/stories_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/media_enum.dart';
import 'package:circleapp/view/custom_widget/custom_text_field.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateStoryScreen extends StatelessWidget {
  String circleId;

  CreateStoryScreen({super.key, required this.circleId});

  Rx<File?> selectedImage = Rx<File>(File(''));

  TextEditingController storyTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    StoryController storyController = StoryController(context);
    Size mediaQuerySize = MediaQuery.of(context).size;
    return Obx(() {
      return Scaffold(
        body: SafeArea(
          child: Container(
            height: mediaQuerySize.height,
            width: mediaQuerySize.width,
            color: AppColors.primaryColor,
            child: Padding(
              padding: EdgeInsets.all(18.px),
              child: Column(
                children: [
                  const Text(
                    'Create your story',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: mediaQuerySize.height * 0.04,
                  ),
                  selectedImage.value!.path.isEmpty
                      ? GestureDetector(
                          onTap: () async {
                            showDialog(
                              context: context, // Make sure to pass the correct context
                              builder: (BuildContext context) {
                                return storyDialog(onCameraSelected: () async {
                                  selectedImage.value = await Get.put(PickerController()).pickImageFromCamera();
                                }, onGallerySelected: () async {
                                  selectedImage.value = await Get.put(PickerController()).pickImage();
                                },);
                              },
                            );
                          },
                          child: SvgPicture.asset('assets/svg/add_images.svg'),
                        )
                      : Container(
                          height: mediaQuerySize.height * 0.3,
                          width: mediaQuerySize.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(fit: BoxFit.cover, image: FileImage(File(selectedImage.value!.path))),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                  SizedBox(
                    height: mediaQuerySize.height * 0.025,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'About story',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  CustomTextField(
                    controller: storyTextController,
                    hintText: 'Tell about your story',
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: customButton(
                            onTap: () {
                              Get.back();
                            },
                            height: mediaQuerySize.height * 0.06,
                            backgroundColor: AppColors.primaryColor,
                            borderColor: AppColors.mainColorYellow,
                            title: 'Cancel',
                            titleColor: AppColors.mainColorYellow),
                      ),
                      SizedBox(
                        width: 8.px,
                      ),
                      Expanded(
                        child: customLoadingButton(
                            loading: storyController.loading,
                            onTap: () {
                              storyController.uploadStory(
                                  load: true,
                                  circleId: circleId,
                                  storyText: storyTextController.text,
                                  file: selectedImage.value!,
                                  mediaType: MediaType.image);
                            },
                            height: mediaQuerySize.height * 0.06,
                            backgroundColor: AppColors.mainColorYellow,
                            borderColor: AppColors.mainColorYellow,
                            title: 'Post',
                            titleColor: AppColors.primaryColor),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
