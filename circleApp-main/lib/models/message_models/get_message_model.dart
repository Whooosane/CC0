import 'dart:convert';

class GetMessageModel {
  final bool success;
  final List<MessageData> data;
  final String circleId;

  GetMessageModel({
    required this.success,
    required this.data,
    required this.circleId,
  });

  factory GetMessageModel.fromJson(Map<String, dynamic> json) {
    return GetMessageModel(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MessageData.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      circleId: json['circleId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((e) => e.toJson()).toList(),
      'circleId': circleId,
    };
  }
}

class MessageData {
  final String id;
  final String type;
  final String senderId;
  final String text;
  final String senderName;
  final String senderProfilePicture;
  final String sentAt;
  final bool pinned;
  final List<Media> media;
  final PlanDetails? planDetails;
  final OfferDetails? offerDetails;
  final ItineraryDetails? itineraryDetails;

  MessageData({
    required this.id,
    required this.type,
    required this.senderId,
    required this.text,
    required this.senderName,
    required this.senderProfilePicture,
    required this.sentAt,
    required this.pinned,
    required this.media,
    this.planDetails,
    this.offerDetails,
    this.itineraryDetails,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      senderId: json['senderId'] ?? '',
      text: json['text'] ?? '',
      senderName: json['senderName'] ?? '',
      senderProfilePicture: json['senderProfilePicture'] ?? '',
      sentAt: json['sentAt'] ?? '',
      pinned: json['pinned'] ?? false,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      planDetails: json['planDetails'] != null
          ? PlanDetails.fromJson(json['planDetails'] as Map<String, dynamic>)
          : null,
      offerDetails: json['offerDetails'] != null
          ? OfferDetails.fromJson(json['offerDetails'] as Map<String, dynamic>)
          : null,
      itineraryDetails: json['itineraryDetails'] != null
          ? ItineraryDetails.fromJson(json['itineraryDetails'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'senderId': senderId,
      'text': text,
      'senderName': senderName,
      'senderProfilePicture': senderProfilePicture,
      'sentAt': sentAt,
      'pinned': pinned,
      'media': media.map((e) => e.toJson()).toList(),
      'planDetails': planDetails?.toJson(),
      'offerDetails': offerDetails?.toJson(),
      'itineraryDetails': itineraryDetails?.toJson(),
    };
  }
}

class Media {
  final String type;
  final String url;
  final String mimetype;

  Media({
    required this.type,
    required this.url,
    required this.mimetype,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      type: json['type'] ?? '',
      url: json['url'] ?? '',
      mimetype: json['mimetype'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'url': url,
      'mimetype': mimetype,
    };
  }
}

class PlanDetails {
  final String planId;
  final String planName;
  final String description;
  final String date;
  final String location;
  final EventType eventType;
  final List<dynamic> members;
  final int budget;
  final CreatedBy createdBy;

  PlanDetails({
    required this.planId,
    required this.planName,
    required this.description,
    required this.date,
    required this.location,
    required this.eventType,
    required this.members,
    required this.budget,
    required this.createdBy,
  });

  factory PlanDetails.fromJson(Map<String, dynamic> json) {
    return PlanDetails(
      planId: json['planId'] ?? '',
      planName: json['planName'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      location: json['location'] ?? '',
      eventType: EventType.fromJson(json['eventType'] as Map<String, dynamic>),
      members: json['members'] ?? [],
      budget: json['budget'] ?? 0,
      createdBy: CreatedBy.fromJson(json['createdBy'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'planName': planName,
      'description': description,
      'date': date,
      'location': location,
      'eventType': eventType.toJson(),
      'members': members,
      'budget': budget,
      'createdBy': createdBy.toJson(),
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
      eventId: json['eventId'] ?? '',
      name: json['name'] ?? '',
      color: json['color'] ?? '',
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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
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

class OfferDetails {
  final String id;
  final String title;
  final String description;
  final int numberOfPeople;
  final String startingDate;
  final String endingDate;
  final String interest;
  final int price;
  final List<String> imageUrls;
  final bool active;
  final String createdAt;

  OfferDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.numberOfPeople,
    required this.startingDate,
    required this.endingDate,
    required this.interest,
    required this.price,
    required this.imageUrls,
    required this.active,
    required this.createdAt,
  });

  factory OfferDetails.fromJson(Map<String, dynamic> json) {
    return OfferDetails(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      numberOfPeople: json['numberOfPeople'] ?? 0,
      startingDate: json['startingDate'] ?? '',
      endingDate: json['endingDate'] ?? '',
      interest: json['interest'] ?? '',
      price: json['price'] ?? 0,
      imageUrls: (json['imageUrls'] as List<dynamic>?)?.cast<String>() ?? [],
      active: json['active'] ?? false,
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'numberOfPeople': numberOfPeople,
      'startingDate': startingDate,
      'endingDate': endingDate,
      'interest': interest,
      'price': price,
      'imageUrls': imageUrls,
      'active': active,
      'createdAt': createdAt,
    };
  }
}

class ItineraryDetails {
  final String itineraryId;
  final String name;
  final String about;
  final String date;
  final String time;

  ItineraryDetails({
    required this.itineraryId,
    required this.name,
    required this.about,
    required this.date,
    required this.time,
  });

  factory ItineraryDetails.fromJson(Map<String, dynamic> json) {
    return ItineraryDetails(
      itineraryId: json['itineraryId'] ?? '',
      name: json['name'] ?? '',
      about: json['about'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itineraryId': itineraryId,
      'name': name,
      'about': about,
      'date': date,
      'time': time,
    };
  }
}

GetMessageModel getMessageModelFromJson(String str) =>
    GetMessageModel.fromJson(json.decode(str));

String getMessageModelToJson(GetMessageModel data) => json.encode(data.toJson());