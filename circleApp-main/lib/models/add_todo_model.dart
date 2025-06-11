class AddNewTodoModel {
  String title;
  String description;
  List<String> memberIds;
  String circleId;
  List<String> images;
  Bill bill;

  AddNewTodoModel({
    required this.title,
    required this.description,
    required this.memberIds,
    required this.circleId,
    required this.images,
    required this.bill,
  });

  // Convert JSON to model
  factory AddNewTodoModel.fromJson(Map<String, dynamic> json) {
    return AddNewTodoModel(
      title: json['title'],
      description: json['description'],
      memberIds: List<String>.from(json['memberIds']),
      circleId: json['circleId'],
      images: List<String>.from(json['images']),
      bill: Bill.fromJson(json['bill']),
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'memberIds': memberIds,
      'circleId': circleId,
      'images': images,
      'bill': bill.toJson(),
    };
  }

  // Custom toString method
  @override
  String toString() {
    return 'AddNewTodoModel(title: $title, description: $description, memberIds: $memberIds, circleId: $circleId, images: $images, bill: ${bill.toString()})';
  }
}

class Bill {
  double total;
  String title;
  List<String> images;
  List<String> members;

  Bill({
    required this.total,
    required this.title,
    required this.images,
    required this.members,
  });

  // Convert JSON to model
  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      total: json['total'],
      title: json['title'],
      images: List<String>.from(json['images']),
      members: List<String>.from(json['members']),
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'title': title,
      'images': images,
      'members': members,
    };
  }

  // Custom toString method
  @override
  String toString() {
    return 'Bill(total: $total, title: $title, images: $images, members: $members)';
  }
}
