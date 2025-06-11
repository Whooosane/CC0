import 'package:flutter_contacts/contact.dart';

class ContactSelection {
  Contact contact;
  bool isSelected, isUser;

  ContactSelection({
    required this.contact,
    required this.isUser,
    this.isSelected = false,
  });
}
