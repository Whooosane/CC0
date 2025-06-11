import 'dart:convert';
class EventModel {
  bool success;
  String message;
  List<Event> eventTypes;

  EventModel({
    required this.success,
    required this.message,
    required this.eventTypes,
  });

  factory EventModel.fromRawJson(String str) => EventModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    success: json["success"],
    message: json["message"],
    eventTypes: List<Event>.from(json["eventTypes"].map((x) => Event.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "eventTypes": List<dynamic>.from(eventTypes.map((x) => x.toJson())),
  };
}

class Event {
  String id;
  String name;
  String color;

  Event({
    required this.id,
    required this.name,
    required this.color,
  });

  factory Event.fromRawJson(String str) => Event.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["_id"],
    name: json["name"],
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "color": color,
  };
}
