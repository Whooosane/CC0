import 'package:meta/meta.dart';
import 'dart:convert';

import 'loop_models/event_model.dart';

class PlanModel {
  bool success;
  String message;
  List<Plan> plans;

  PlanModel({
    required this.success,
    required this.message,
    required this.plans,
  });

  factory PlanModel.fromRawJson(String str) => PlanModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
    success: json["success"],
    message: json["message"],
    plans: List<Plan>.from(json["plans"].map((x) => Plan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "plans": List<dynamic>.from(plans.map((x) => x.toJson())),
  };
}

class Plan {
  String id;
  String name;
  String description;
  DateTime date;
  String location;
  Event eventType;
  List<Member> members;
  int budget;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.location,
    required this.eventType,
    required this.members,
    required this.budget,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Plan.fromRawJson(String str) => Plan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    date: DateTime.parse(json["date"]),
    location: json["location"],
    eventType: Event.fromJson(json["eventType"]),
    members: List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
    budget: json["budget"],
    createdBy: json["createdBy"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "date": date.toIso8601String(),
    "location": location,
    "eventType": eventType.toJson(),
    "members": List<dynamic>.from(members.map((x) => x.toJson())),
    "budget": budget,
    "createdBy": createdBy,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class Member {
  String id;
  String name;
  String email;
  String? profilePicture;

  Member({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
  });

  factory Member.fromRawJson(String str) => Member.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    profilePicture: json["profilePicture"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "profilePicture": profilePicture,
  };
}
