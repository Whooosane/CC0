import 'dart:developer';
import 'dart:io';
import 'package:circleapp/controller/api/circle_apis.dart';
import 'package:circleapp/models/circle_models/GetUserInterestsModel.dart';
import 'package:circleapp/models/circle_models/circle_details_model.dart';
import 'package:circleapp/models/circle_models/circle_members_model.dart';
import 'package:circleapp/models/circle_models/get_circle_model.dart';
import 'package:circleapp/models/circle_models/post_circle_model.dart';
import 'package:circleapp/models/contact_model.dart';
import 'package:circleapp/models/loop_models/get_experience_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
class CircleController extends GetxController {
  late final BuildContext context;

  CircleController(this.context);

  ///Variables
  RxBool loading = false.obs;
  RxBool contactsLoading = false.obs;
  RxBool createCircleLoading = false.obs;
  RxBool messagesLoading = false.obs;
  RxBool newTodoLoading = false.obs;
  RxBool addMembersLoading = false.obs;
  RxString image="".obs;
  RxString? circleImage="".obs;

  ///Rx Models
  Rxn<PostCircleModel> postCircleModel = Rxn<PostCircleModel>();
  Rxn<GetCircleModel?> getCircleModel = Rxn<GetCircleModel?>();
  Rxn<CircleDetailsModel> circleDetailsModel = Rxn<CircleDetailsModel>();
  Rxn<CircleMembersModel> circleMembersModel = Rxn<CircleMembersModel>();
  TextEditingController circleNameTextController = TextEditingController();
  TextEditingController circleDescriptionTextController = TextEditingController();
  Rxn<GetUserInterestsModel> userInterestsModel = Rxn<GetUserInterestsModel>();
  Rxn<GetExperienceModel?> getExperienceModel = Rxn<GetExperienceModel?>();

  ///Create Circle Controller
  Future<void> createCircle({
    required bool load,
    required String circleName,
    required String circleImage,
    required String description,
    required String type,
    required List<String> circleInterests,
    required List<ContactSelection> contactsSelection,
  })
  async {
    try {
      createCircleLoading.value = load;
      image.value = await uploadCircleImage(File(circleImage)) ?? "";
      if (image.value.isNotEmpty) {
         await CircleApis(context).createCircleApi(
          circleName: circleName,
          circleImage: image.value,
          description: description,
          type: type,
          circleInterests: circleInterests,
          memberIds: [],
          phoneNumbers: getContactsFromModel(false, contactsSelection),
        );
         createCircleLoading.value=false;
        getCircles(load: getCircleModel.value == null);
        getCircleModel.refresh();
      } else {
        print("Image upload failed or returned empty URL.");
      }

      createCircleLoading.value = false;
    } catch (e, stackTrace) {
      createCircleLoading.value = false;
      log("Error in createCircle: $e");
      log("StackTrace: $stackTrace");
      customScaffoldMessenger("Error :$e");
    }
  }


  ///Get Circle Controller
  Future<void> getCircles({required bool load})
  async {
    try{
      loading.value = load;
      getCircleModel.value = await CircleApis(context).getCircles();
      loading.value = false;
    }catch(e){
      loading.value = false;
      log("Error :$e");
      customScaffoldMessenger("Error :$e");
    }
  }

  ///Get Circle Members Controller
  Future<void> getCircleMembers({required bool load, required String circleId})
  async {
   try{
     loading.value = load;
     circleMembersModel.value = await CircleApis(context).getCircleMembers(circleId: circleId);
     loading.value = false;
   }catch(e){
     loading.value = false;
     customScaffoldMessenger("Error :$e");
   }
  }

  ///Get Circle By Id Controller
  Future<void> getCircleById({required bool load, required String circleId})
  async {
  try{
    loading.value = load;
    circleDetailsModel.value = await CircleApis(context).getCircleById(circleId);
    loading.value = false;
  }catch(e){
    loading.value = false;
    customScaffoldMessenger("Error :$e");
  }
  }

  ///Upload image Controller
  Future<String?> uploadCircleImage(File imageFile)
  async {
    loading.value = true;
    try {
      print("imageFile :$imageFile");
       circleImage?.value=await CircleApis(context).uploadCircleImage(imageFile: imageFile)??"";
       loading.value = false;
       return circleImage?.value;
    } catch (e) {
      loading.value = false;
      customScaffoldMessenger('Upload failed. Please try again.$e');


    }
    loading.value = false;
    return null;
  }

  ///Upload Circle Controller
  Future<bool> updateCircle({required bool load, required String circleId, required String circleName, required String circleImage})
  async {
    bool done = false;
    if (load) {

    }

    await CircleApis(context).updateCircle(circleId: circleId, circleName: circleName, circleImage: circleImage).then(
      (value) {
        loading.value = false;
        done = value;
      },
    );
    return done;
  }

  ///Add Members in Circle Controller
  Future<bool> addMembersToCircle({required bool load, required String circleId, required List<String> memberIds})
  async {
    bool done = false;
    if (load) {
      addMembersLoading.value = true;
    }

    await CircleApis(context).addMembersToCircle(circleId: circleId, memberIds: memberIds).then(
      (value) {
        addMembersLoading.value = false;
        done = value;
      },
    );
    return done;
  }

  /// Supporting Method
  Future<RxList<ContactSelection>?> getContacts() async {
    try {
      contactsLoading.value = true;
      log("Contacts loading started");

      if (await Permission.contacts.request().isGranted) {
        final contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: false);
        if (contacts.isEmpty) {
          log("No contacts found");
          customScaffoldMessenger("No contacts found in your phone");
          return null;
        }

        final myContacts = <ContactSelection>[].obs;

        for (var contact in contacts) {
          if (contact.phones.isNotEmpty) {
            myContacts.add(ContactSelection(
              contact: contact,
              isUser: false,
              isSelected: false,
            ));
          }
        }

        if (myContacts.isEmpty) {
          log("No contacts with phone numbers found");
          customScaffoldMessenger("No contacts with phone numbers found");
          return null;
        }

        log("Contacts processing completed");
        return myContacts;
      } else {
        customScaffoldMessenger("Please grant contacts permission");
        return null;
      }
    } catch (e, stackTrace) {
      log("Error fetching contacts: $e");
      log(stackTrace.toString());
      customScaffoldMessenger("Failed to load contacts");
      return null;
    } finally {
      contactsLoading.value = false;
    }
  }


  ///Is Valid Phone Or Not
  bool _isValidPhoneNumber(String phoneNumber) {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    return cleaned.isNotEmpty && RegExp(r'^\+?[0-9]+$').hasMatch(cleaned);
  }

  String _sanitizePhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  }

  ///Get Contact from Model
  List<String> getContactsFromModel(bool areUser, List<ContactSelection> contactsSelection)
  {
    List<String> contactNumbers = [];
    for (var contact in contactsSelection) {
      contactNumbers.add(contact.contact.phones.first.number);
      log("contactNumbers :$contactNumbers");
    }
    return contactNumbers;
  }

  ///Get Interest Controller
  Future<void> fetchUserInterests({required bool load})
  async {
   try{
     loading.value = load;
     userInterestsModel.value = await CircleApis(context).getUserInterests();
     loading.value = false;
   }catch(e){
     loading.value = false;
     customScaffoldMessenger("Error :$e");
   }

  }

  ///Get Experience Controller
  Future<void> getExperienceController({required bool load})
  async {
    try{
      loading.value = load;
      getExperienceModel.value = await CircleApis(context).getExperienceApiMethod();
      loading.value = false;
    }catch(e){
      loading.value = false;
      customScaffoldMessenger("Error :$e");
    }

  }
}
