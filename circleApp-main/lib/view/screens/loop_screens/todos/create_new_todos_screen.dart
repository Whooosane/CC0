import 'dart:io';
import 'package:circleapp/controller/api/upload_apis.dart';
import 'package:circleapp/controller/getx_controllers/picker_controller.dart';
import 'package:circleapp/controller/getx_controllers/todo_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/models/add_bill_model.dart';
import 'package:circleapp/models/add_todo_model.dart';
import 'package:circleapp/models/all_users_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:circleapp/view/screens/plan_screens/all_members_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'add_bill_screen.dart';

class CreateNewToDo extends StatefulWidget {
  final String circleId;
  const CreateNewToDo({super.key, required this.circleId});
  @override
  State<CreateNewToDo> createState() => _CreateNewToDoState();
}

class _CreateNewToDoState extends State<CreateNewToDo> {
  final RxList<Datum> selectedUsers = <Datum>[].obs;
  final pickerController = Get.put(PickerController());
  final todosController = Get.put(TodosController(Get.context!));
  final RxList<File?> todoImages = <File>[].obs;
  final titleTextController = TextEditingController();
  final descriptionController = TextEditingController();
  final RxBool billAdded = false.obs;
  final Rxn<AddBillsModel> addBillModel = Rxn<AddBillsModel>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            getVerticalSpace(6.h),
            _buildHeader(context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getVerticalSpace(3.h),
                  _buildTextFieldSection('Title', titleTextController, 'Winter trip Plan'),
                  getVerticalSpace(3.h),
                  _buildTextFieldSection(
                    'Description',
                    descriptionController,
                    'Lorem ipsum dolor sit amet...',
                    maxLine: 4,
                    borderRadius: BorderRadius.circular(15.px),
                  ),
                  getVerticalSpace(3.h),
                  _buildImageUploadSection(),
                  getVerticalSpace(4.h),
                  _buildMemberSection(),
                  getVerticalSpace(3.h),
                  _buildDoneButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: Get.back,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 2.h),
            ),
          ),
          getHorizentalSpace(1.5.h),
          Text('Create new To-Dos', style: CustomTextStyle.headingStyle),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              final value = await Get.to(() => const AddBills());
              if (value != null) {
                addBillModel.value = value;
                billAdded.value = true;
              }
            },
            child: customTextButton1(title: 'Add Bill'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldSection(String label, TextEditingController controller, String hint,
      {int maxLine = 1, BorderRadius? borderRadius}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomTextStyle.smallText.copyWith(color: Colors.white)),
        getVerticalSpace(.4.h),
        customTextFormField(controller, hint, isObsecure: false, maxLine: maxLine, borderRadius: borderRadius),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upload Images', style: CustomTextStyle.headingStyle),
        getVerticalSpace(.6.h),
        Text('you can add multiple images.', style: CustomTextStyle.hintText),
        getVerticalSpace(1.h),
        GestureDetector(
          onTap: () async => todoImages.add(await pickerController.pickImage()),
          child: Image.asset("assets/png/chooseImage.png"),
        ),
        if (todoImages.isNotEmpty) ...[
          getVerticalSpace(1.5.h),
          SizedBox(
            height: 8.2.h,
            width: double.infinity, // Ensure the ListView has a bounded width
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: todoImages.length,
              itemExtent: 11.h,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: .3.h),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.px), color: AppColors.textFieldColor),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.px),
                    child: Image.file(todoImages[index]!, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMemberSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add person in group to split bill', style: CustomTextStyle.headingStyle),
        getVerticalSpace(1.h),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 3.5.h,
                width: double.infinity, // Ensure the ListView has a bounded width
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedUsers.length,
                  itemExtent: 4.h,
                  itemBuilder: (context, index) => Container(
                    padding: EdgeInsets.symmetric(horizontal: .3.h),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.secondaryColor), shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 5.6.h,
                      backgroundColor: AppColors.mainColor,
                      backgroundImage: selectedUsers[index].profilePicture != null
                          ? NetworkImage(selectedUsers[index].profilePicture!)
                          : const AssetImage('assets/png/userplacholder.png') as ImageProvider,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final value = await Get.to(() => AllMembersScreen(showAll: false, circleId: widget.circleId));
                if (value != null) selectedUsers.value = value;
              },
              child: customTextButton1(
                title: 'Add Member',
                horizentalPadding: 1.h,
                verticalPadding: .5.h,
                bgColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDoneButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.5.h),
      child: customButton(
        onTap: () {
          if (titleTextController.text.isEmpty) {
            customScaffoldMessenger("Add title");
          } else if (descriptionController.text.isEmpty) {
            customScaffoldMessenger("Add description");
          } else if (todoImages.isEmpty) {
            customScaffoldMessenger("Add at least one image");
          } else if (selectedUsers.isEmpty) {
            customScaffoldMessenger("Add at least one member");
          } else {
            showCustomDialog(
              context,
              title: titleTextController.text,
              description: descriptionController.text,
              selectedUsers: selectedUsers,
              addBillsModel: addBillModel.value ?? AddBillsModel(title: "", billAmount: "0", todoImages: []),
              todosController: todosController,
              circleId: widget.circleId,
              todoImages: todoImages,
            );
          }
        },
        backgroundColor: AppColors.secondaryColor,
        borderColor: AppColors.primaryColor,
        title: 'Done',
        titleColor: Colors.black,
        height: 4.5.h,
      ),
    );
  }
}

void showCustomDialog(
    BuildContext context, {
      required String title,
      required String description,
      required RxList<Datum> selectedUsers,
      required AddBillsModel addBillsModel,
      required TodosController todosController,
      required String circleId,
      required List<File?> todoImages,
    }) {
  final RxBool backButton = false.obs;
  final RxBool nextButton = true.obs;
  final RxBool isLoading = false.obs;

  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: !isLoading.value, // Prevent dismissal during loading
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => Center(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2.3.h),
              padding: EdgeInsets.symmetric(horizontal: 1.9.h, vertical: 1.3.h),
              height: 40.h,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.px), color: AppColors.textFieldColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: isLoading.value ? null : Get.back,
                        child: Icon(Icons.cancel, color: Colors.white, size: 2.5.h),
                      ),
                    ],
                  ),
                  getVerticalSpace(2.h),
                  Row(
                    children: [
                      Text('To-Dos Details', style: CustomTextStyle.headingStyle),
                      const Spacer(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Total Bill: ',
                              style: CustomTextStyle.smallText.copyWith(color: const Color(0xffFFFFFF).withOpacity(0.48)),
                            ),
                            TextSpan(text: '\$${addBillsModel.billAmount}', style: CustomTextStyle.smallText),
                          ],
                        ),
                      ),
                    ],
                  ),
                  getVerticalSpace(1.3.h),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Title: ', style: CustomTextStyle.smallText.copyWith(color: const Color(0xffDADADA))),
                        TextSpan(text: title, style: CustomTextStyle.smallText.copyWith(color: const Color(0xffDADADA))),
                      ],
                    ),
                  ),
                  getVerticalSpace(1.3.h),
                  Text("Description: $description", style: CustomTextStyle.hintText),
                  getVerticalSpace(1.3.h),
                  Row(
                    children: [
                      Text(
                        "Splitting Bill",
                        style: CustomTextStyle.hintText.copyWith(color: const Color(0xffFFFFFF).withOpacity(0.69)),
                      ),
                      const Spacer(),
                      Text(
                        'Bill receipts',
                        style: CustomTextStyle.hintText.copyWith(color: const Color(0xffFFFFFF).withOpacity(0.69)),
                      ),
                    ],
                  ),
                  getVerticalSpace(1.3.h),
                  Row(
                    children: [
                      SizedBox(
                        height: 4.h,
                        width: 40.w, // Constrain the width of the ListView
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedUsers.length,
                          itemExtent: 4.h,
                          itemBuilder: (context, index) => Container(
                            padding: EdgeInsets.symmetric(horizontal: .3.h),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.secondaryColor),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 5.6.h,
                              backgroundColor: AppColors.mainColor,
                              backgroundImage: selectedUsers[index].profilePicture != null
                                  ? NetworkImage(selectedUsers[index].profilePicture!)
                                  : const AssetImage('assets/png/userplacholder.png') as ImageProvider,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 4.h,
                        width: 40.w, // Constrain the width of the ListView
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: addBillsModel.todoImages.length,
                          itemExtent: 5.h,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: .3.h),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.px),
                                image: DecorationImage(image: FileImage(addBillsModel.todoImages[index]!)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  getVerticalSpace(3.4.h),
                  Obx(
                        () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        getHorizentalSpace(4.h),
                        Expanded(
                          child: customButton(
                            onTap: isLoading.value ? null : Get.back,
                            backgroundColor: backButton.value ? AppColors.secondaryColor : AppColors.primaryColor,
                            borderColor: backButton.value ? AppColors.primaryColor : AppColors.secondaryColor,
                            title: 'Back',
                            titleColor: backButton.value ? Colors.black : Colors.white,
                            width: 12.h,
                            height: 4.5.h,
                          ),
                        ),
                        getHorizentalSpace(1.h),
                        Expanded(
                          child: customButton(
                            onTap: isLoading.value
                                ? null
                                : () async {
                              isLoading.value = true;
                              final todoImagesString = <String>[];
                              final receiptImagesString = <String>[];

                              for (var image in todoImages) {
                                final value = await UploadApis(context).uploadFile(image!);
                                if (value != null) todoImagesString.add(value.first);
                              }
                              for (var image in addBillsModel.todoImages) {
                                final value = await UploadApis(context).uploadFile(image!);
                                if (value != null) receiptImagesString.add(value.first);
                              }

                              await todosController.createNewTodo(
                                load: true,
                                addNewToDoModel: AddNewTodoModel(
                                  title: title,
                                  description: description,
                                  memberIds: selectedUsers.map((datum) => datum.id).toList(),
                                  circleId: circleId,
                                  images: todoImagesString,
                                  bill: Bill(
                                    total: double.parse(addBillsModel.billAmount),
                                    title: title,
                                    images: receiptImagesString,
                                    members: selectedUsers.map((datum) => datum.id).toList(),
                                  ),
                                ),
                              );
                              isLoading.value = false;
                              Get.back();
                            },
                            backgroundColor: nextButton.value ? AppColors.secondaryColor : AppColors.primaryColor,
                            borderColor: nextButton.value ? AppColors.primaryColor : AppColors.secondaryColor,
                            title: 'Done',
                            titleColor: nextButton.value ? Colors.black : Colors.white,
                            width: 12.h,
                            height: 4.5.h,
                          ),
                        ),
                        getHorizentalSpace(4.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Obx(
                  () => isLoading.value
                  ? Container(
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.px),
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryColor),
                      ),
                      getVerticalSpace(2.h),
                      Text(
                        'Creating To-Do...',
                        style: CustomTextStyle.headingStyle.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    ),
    transitionBuilder: (_, anim, __, child) => SlideTransition(
      position: Tween<Offset>(
        begin: anim.status == AnimationStatus.reverse ? const Offset(-1, 0) : const Offset(1, 0),
        end: Offset.zero,
      ).animate(anim),
      child: FadeTransition(opacity: anim, child: child),
    ),
  );
}