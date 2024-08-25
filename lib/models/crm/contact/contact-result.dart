// @dart=2.9
import 'package:nandrlon/models/crm/contact/contact.dart';

class ContactResult extends Contact {
  String customerName;
  String groupName;
  String genderName;
  String languageName;
  int totalRecords;

  ContactResult({
    this.customerName,
    this.groupName,
    this.genderName,
    this.languageName,
    this.totalRecords,
  });

  ContactResult.fromJson(Map<String, dynamic> json) : super.fromJson(json) {

    customerName = json['customerName'];
    groupName = json['groupName'];
    genderName = json['genderName'];
    languageName = json['languageName'];
    totalRecords = json['totalRecords'];
  }

  static List<ContactResult> toList(parsed) {
    return parsed
        .map<ContactResult>((json) => ContactResult.fromJson(json))
        .toList();
  }
}
