class ShareGroupItemModel{
  String GroupName, SubTitle,ImagePath;
  bool selected;

  ShareGroupItemModel({
    required this.GroupName,
    required this.SubTitle,
    required this.ImagePath,
    required this.selected,
  });

  // Named constructor
  ShareGroupItemModel.fromMap(Map<String, dynamic> map)
      : GroupName = map['GroupName'],
        SubTitle = map['SubTitle'],
        ImagePath = map['ImagePath'],
        selected = map['selected'];
}
