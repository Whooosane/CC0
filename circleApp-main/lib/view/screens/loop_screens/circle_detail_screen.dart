import 'package:circleapp/controller/getx_controllers/convos_controller.dart';
import 'package:circleapp/controller/getx_controllers/messenger_controller.dart';
import 'package:circleapp/controller/getx_controllers/stories_controller.dart';
import 'package:circleapp/controller/getx_controllers/todo_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/controller/utils/preference_keys.dart';
import 'package:circleapp/controller/utils/shared_preferences.dart';
import 'package:circleapp/view/screens/loop_screens/todos/create_new_todos_screen.dart';
import 'package:circleapp/view/screens/loop_screens/todos/experince_screen.dart';
import 'package:circleapp/view/screens/loop_screens/todos/to_dos_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'convos/convos_widget.dart';
class CircleDetails extends StatefulWidget {
  final String circleId, userProfileImage, circleName;
  const CircleDetails(
      {super.key,
        required this.circleId,
        required this.userProfileImage,
        required this.circleName});
  @override
  State<CircleDetails> createState() => _CircleDetailsState();
  }
  class _CircleDetailsState extends State<CircleDetails> {
  late StoryController storyController;
  late TodosController todosController;
  late ConvosController convosController;
  late MessengerController messengerController;
  final selectedIndex = 0.obs;
  final tabs = ['Convos', 'To-Dos',"Experiences"].obs;
  final RxList<String>imaged=[
    "assets/png/png1.png",
    "assets/png/png2.png",
    "assets/png/png3.png",
  ].obs;
final RxString token="".obs;
  @override
  void initState() {
    super.initState();
    storyController = Get.put(StoryController(context));
    todosController = Get.put(TodosController(context));
    todosController = Get.put(TodosController(context));
    convosController = Get.put(ConvosController(context));
    messengerController = Get.put(MessengerController(context));
    token.value=MySharedPreferences.getString(userTokenKey);
    storyController.getStories(
      circleId: widget.circleId,
      load: storyController.storiesModel.value == null ||
          messengerController.messagesModel.value?.circleId != widget.circleId,
    );
    convosController.getConvos(
      isLoading: messengerController.messagesModel.value==null,
      token: token.value,
      circleId: widget.circleId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Obx(
            () => Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
            children: [
              SizedBox(height: 50.px),
              Row(
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 2.4.h),
                    ),
                  ),
                  SizedBox(width: 1.5.h),
                  Text(widget.circleName, style: CustomTextStyle.headingStyle),
                  const Spacer(),
                  if (selectedIndex.value == 1)
                    GestureDetector(
                      onTap: () =>
                          Get.to(CreateNewToDo(circleId: widget.circleId)),
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        padding: EdgeInsets.symmetric(horizontal: 2.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.mainColorYellow),
                        ),
                        child: Text("Add+",
                            style: CustomTextStyle.mediumTextYellow
                                .copyWith(fontSize: 13.px)),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10.px),
              Row(
                children: [
                  _buildTab(0, tabs[0], true,false),
                  SizedBox(width: 5.px),
                  _buildTab(1, tabs[1], false,false),
                  SizedBox(width: 5.px),
                  _buildTab(3, tabs[2], false,true),
                ],
              ),
              SizedBox(height:selectedIndex.value == 0||selectedIndex.value == 1? 1.3.h:0),
              selectedIndex.value == 0
                  ?convosWidget(
                circleId: widget.circleId,
                convosController: convosController,
                mContext: context, token: token.value,
                 ):selectedIndex.value == 1? toDosWidget(
                  todosController: todosController,
                  circleId: widget.circleId):
              Expanded(child: ExperienceScreen(circleId: widget.circleId)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index, String title, bool isLeft,bool isRight) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          selectedIndex.value = index;
          if (index == 0) {
            storyController.getStories(
                circleId: widget.circleId,
                load: storyController.storiesModel.value == null);
            convosController.getConvos(
              isLoading: convosController.convosModel.value == null,
              token: token.value,
              circleId: widget.circleId,
            );
          } else {
            todosController.getTodosTodos(
                load: todosController.allTodosModel.value == null,
                circleId: widget.circleId);
          }
        },
        child: Container(
          height: 40.px,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selectedIndex.value == index
                ? AppColors.secondaryColor
                : AppColors.textFieldColor,
            borderRadius:!isLeft&&!isRight?BorderRadius.zero: BorderRadius.horizontal(
              left: isLeft ? Radius.circular(20.px) : Radius.zero,
              right: !isLeft ? Radius.circular(20.px) : Radius.zero,
            ),
          ),
          child: Text(
            title,
            style: CustomTextStyle.smallText.copyWith(
              fontSize: 12.px,
              color: selectedIndex.value == index ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
