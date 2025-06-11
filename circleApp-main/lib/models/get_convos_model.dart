import 'dart:convert';

import 'package:circleapp/models/message_models/get_message_model.dart';

GetConvosModel getConvosModelFromJson(String str) {
  try {
    return GetConvosModel.fromJson(json.decode(str));
  } catch (e, stackTrace) {
    print('getConvosModelFromJson Error: $e');
    print('Stack Trace: $stackTrace');
    print('Input JSON: $str');
    rethrow;
  }
}

String getConvosModelToJson(GetConvosModel data) => json.encode(data.toJson());

class GetConvosModel {
  final bool success;
  final List<Datum> data;
  final String? circleId;

  GetConvosModel({
    required this.success,
    required this.data,
    this.circleId,
  });

  factory GetConvosModel.fromJson(Map<String, dynamic> json) {
    try {
      return GetConvosModel(
        success: json['success'] as bool? ?? false,
        data: (json['data'] as List<dynamic>?)
            ?.map((x) => Datum.fromJson(x as Map<String, dynamic>))
            .toList() ??
            [],
        circleId: json['circleId'] as String?,
      );
    } catch (e, stackTrace) {
      print('GetConvosModel Parsing Error: $e');
      print('Stack Trace: $stackTrace');
      print('Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((x) => x.toJson()).toList(),
      'circleId': circleId,
    };
  }
}

class Datum {
  final String id;
  final String type;
  final String senderId;
  final String text;
  final String senderName;
  final String senderProfilePicture;
  final DateTime? sentAt;
  final bool pinned;
  final List<Media> media;
  final ItineraryDetails? itineraryDetails;
  final OfferDetails? offerDetails;
  final PlanDetails? planDetails;

  Datum({
    required this.id,
    required this.type,
    required this.senderId,
    required this.text,
    required this.senderName,
    required this.senderProfilePicture,
    this.sentAt,
    required this.pinned,
    required this.media,
    this.itineraryDetails,
    this.offerDetails,
    this.planDetails,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    try {
      return Datum(
        id: json['id'] as String? ?? '',
        type: json['type'] as String? ?? '',
        senderId: json['senderId'] as String? ?? '',
        text: json['text'] as String? ?? '',
        senderName: json['senderName'] as String? ?? '',
        senderProfilePicture: json['senderProfilePicture'] as String? ?? '',
        sentAt: json['sentAt'] != null ? DateTime.tryParse(json['sentAt'] as String) : null,
        pinned: json['pinned'] as bool? ?? false,
        media: (json['media'] as List<dynamic>?)
            ?.map((x) => Media.fromJson(x as Map<String, dynamic>))
            .toList() ??
            [],
        itineraryDetails: json['itineraryDetails'] != null
            ? ItineraryDetails.fromJson(json['itineraryDetails'] as Map<String, dynamic>)
            : null,
        offerDetails: json['offerDetails'] != null
            ? OfferDetails.fromJson(json['offerDetails'] as Map<String, dynamic>)
            : null,
        planDetails: json['planDetails'] != null
            ? PlanDetails.fromJson(json['planDetails'] as Map<String, dynamic>)
            : null,
      );
    } catch (e, stackTrace) {
      print('Datum Parsing Error: $e');
      print('Stack Trace: $stackTrace');
      print('Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'senderId': senderId,
      'text': text,
      'senderName': senderName,
      'senderProfilePicture': senderProfilePicture,
      'sentAt': sentAt?.toIso8601String(),
      'pinned': pinned,
      'media': media.map((x) => x.toJson()).toList(),
      'itineraryDetails': itineraryDetails?.toJson(),
      'offerDetails': offerDetails?.toJson(),
      'planDetails': planDetails?.toJson(),
    };
  }
}

class ItineraryDetails {
  final String itineraryId;
  final String name;
  final String about;
  final DateTime? date;
  final String time;

  ItineraryDetails({
    required this.itineraryId,
    required this.name,
    required this.about,
    this.date,
    required this.time,
  });

  factory ItineraryDetails.fromJson(Map<String, dynamic> json) {
    return ItineraryDetails(
      itineraryId: json['itineraryId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      about: json['about'] as String? ?? '',
      date: json['date'] != null ? DateTime.tryParse(json['date'] as String) : null,
      time: json['time'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itineraryId': itineraryId,
      'name': name,
      'about': about,
      'date': date?.toIso8601String(),
      'time': time,
    };
  }
}


class OfferDetails {
  final String id;
  final String title;
  final String description;
  final int numberOfPeople;
  final DateTime? startingDate;
  final DateTime? endingDate;
  final String interest;
  final int price;
  final List<String> imageUrls;
  final bool active;
  final DateTime? createdAt;

  OfferDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.numberOfPeople,
    this.startingDate,
    this.endingDate,
    required this.interest,
    required this.price,
    required this.imageUrls,
    required this.active,
    this.createdAt,
  });

  factory OfferDetails.fromJson(Map<String, dynamic> json) {
    return OfferDetails(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      numberOfPeople: json['numberOfPeople'] as int? ?? 0,
      startingDate: json['startingDate'] != null ? DateTime.tryParse(json['startingDate'] as String) : null,
      endingDate: json['endingDate'] != null ? DateTime.tryParse(json['endingDate'] as String) : null,
      interest: json['interest'] as String? ?? '',
      price: json['price'] as int? ?? 0,
      imageUrls: (json['imageUrls'] as List<dynamic>?)?.cast<String>() ?? [],
      active: json['active'] as bool? ?? false,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'numberOfPeople': numberOfPeople,
      'startingDate': startingDate?.toIso8601String(),
      'endingDate': endingDate?.toIso8601String(),
      'interest': interest,
      'price': price,
      'imageUrls': imageUrls,
      'active': active,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class PlanDetails {
  final String planId;
  final String planName;
  final String description;
  final DateTime? date;
  final String location;
  final EventType eventType;
  final List<Member> members;
  final int budget;
  final CreatedBy createdBy;

  PlanDetails({
    required this.planId,
    required this.planName,
    required this.description,
    this.date,
    required this.location,
    required this.eventType,
    required this.members,
    required this.budget,
    required this.createdBy,
  });

  factory PlanDetails.fromJson(Map<String, dynamic> json) {
    return PlanDetails(
      planId: json['planId'] as String? ?? '',
      planName: json['planName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date: json['date'] != null ? DateTime.tryParse(json['date'] as String) : null,
      location: json['location'] as String? ?? '',
      eventType: EventType.fromJson(json['eventType'] as Map<String, dynamic>? ?? {}),
      members: (json['members'] as List<dynamic>?)
          ?.map((x) => Member.fromJson(x as Map<String, dynamic>))
          .toList() ??
          [],
      budget: json['budget'] as int? ?? 0,
      createdBy: CreatedBy.fromJson(json['createdBy'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'planName': planName,
      'description': description,
      'date': date?.toIso8601String(),
      'location': location,
      'eventType': eventType.toJson(),
      'members': members.map((x) => x.toJson()).toList(),
      'budget': budget,
      'createdBy': createdBy.toJson(),
    };
  }
}

class CreatedBy {
  final String id;
  final String name;
  final String profilePicture;

  CreatedBy({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      profilePicture: json['profilePicture'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profilePicture': profilePicture,
    };
  }
}

class EventType {
  final String eventId;
  final String name;
  final String color;

  EventType({
    required this.eventId,
    required this.name,
    required this.color,
  });

  factory EventType.fromJson(Map<String, dynamic> json) {
    return EventType(
      eventId: json['eventId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      color: json['color'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'name': name,
      'color': color,
    };
  }
}

class Member {
  final String id;
  final String name;
  final String profilePicture;

  Member({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as String? ?? json['memberId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      profilePicture: json['profilePicture'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profilePicture': profilePicture,
    };
  }
}