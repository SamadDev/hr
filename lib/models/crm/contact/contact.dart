import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/shared/gender.dart';
import 'package:nandrlon/models/crm/shared/spoken-language.dart';

class Contact {
  int id;
  int customerId;
  String name;
  String jobTitle;
  int genderId;
  int spokenLanguageId;
  String phoneNo1;
  String phoneNo2;
  String email;
  String address;
  String photo;
  Customer customer;
  Gender gender;
  SpokenLanguage spokenLanguage;
  bool isActive;

  Contact({
    this.id,
    this.customerId,
    this.name,
    this.jobTitle,
    this.genderId,
    this.spokenLanguageId,
    this.phoneNo1,
    this.phoneNo2,
    this.customer,
    this.gender,
    this.spokenLanguage,
    this.email,
    this.address,
    this.photo,
    this.isActive,
  });

  Contact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    name = json['name'];
    jobTitle = json['jobTitle'];
    genderId = json['genderId'];
    spokenLanguageId = json['spokenLanguageId'];
    phoneNo1 = json['phoneNo1'];
    phoneNo2 = json['phoneNo2'];
    email = json['email'];
    address = json['address'];
    photo = json['photo'];
    isActive = json['isActive'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    gender = json['gender'] != null
        ? new Gender.fromJson(json['gender'])
        : null;
    spokenLanguage = json['spokenLanguage'] != null
        ? new SpokenLanguage.fromJson(json['spokenLanguage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['name'] = this.name;
    data['jobTitle'] = this.jobTitle;
    data['genderId'] = this.genderId;
    data['spokenLanguageId'] = this.spokenLanguageId;
    data['phoneNo1'] = this.phoneNo1;
    data['phoneNo2'] = this.phoneNo2;
    data['email'] = this.email;
    data['address'] = this.address;
    data['photo'] = this.photo;
    data['isActive'] = this.isActive;

    return data;
  }
}
