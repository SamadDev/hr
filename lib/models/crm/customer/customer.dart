import 'package:nandrlon/models/crm/contact/contact.dart';
import 'package:nandrlon/models/crm/customer/customer-group.dart';
import 'package:nandrlon/models/crm/customer/customer-status.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/models/crm/shared/district.dart';
import 'package:nandrlon/models/crm/shared/source.dart';

class Customer {
  int id;
  String code;
  String name;
  String nameAR;
  int customerGroupId;
  int customerStatusId;
  int sourceId;
  String phoneNo;
  String phoneNo2;
  String email;
  int cityId;
  int districtId;
  int accountId;
  String address;
  String address2;
  String latitude;
  String longitude;
  String photo;
  String description;

  List<Contact> contacts;
  CustomerGroup group;
  CustomerStatus status;
  District district;
  Source source;
  City city;

  Customer({
    this.id,
    this.code,
    this.name,
    this.nameAR,
    this.contacts,
    this.customerGroupId,
    this.customerStatusId,
    this.source,
    this.sourceId,
    this.accountId,
    this.phoneNo,
    this.phoneNo2,
    this.email,
    this.cityId,
    this.address,
    this.address2,
    this.latitude,
    this.longitude,
    this.photo,
    this.description,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    nameAR = json['nameAR'];
    if (json['contacts'] != null) {
      contacts = [];
      json['contacts'].forEach((v) {
        contacts.add(new Contact.fromJson(v));
      });
    }
    group = json['group'] != null ? new CustomerGroup.fromJson(json['group']) : null;
    customerGroupId = json['customerGroupId'];
    status = json['status'] != null ? new CustomerStatus.fromJson(json['status']) : null;
    customerStatusId = json['customerStatusId'];
    source = json['source'] != null ? new Source.fromJson(json['source']) : null;
    accountId = json['accountId'];
    sourceId = json['sourceId'];
    phoneNo = json['phoneNo'];
    phoneNo2 = json['phoneNo2'];
    email = json['email'];
    cityId = json['cityId'];
    district = json['district'] != null ? new District.fromJson(json['district']) : null;
    districtId = json['districtId'];
    address = json['address'];
    address2 = json['address2'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    photo = json['photo'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['nameAR'] = this.nameAR;
    if (this.contacts != null) {
      data['contacts'] = this.contacts.map((v) => v.toJson()).toList();
    }

    data['customerGroupId'] = this.customerGroupId;
    data['customerStatusId'] = this.customerStatusId;
    data['accountId'] = this.accountId;
    data['sourceId'] = this.sourceId;
    data['phoneNo'] = this.phoneNo;
    data['phoneNo2'] = this.phoneNo2;
    data['email'] = this.email;
    data['cityId'] = this.cityId;
    data['districtId'] = this.districtId;
    data['address'] = this.address;
    data['address2'] = this.address2;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['photo'] = this.photo;
    data['description'] = this.description;
    return data;
  }

  static List<Customer> toList(parsed) {
    return parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
  }
}
