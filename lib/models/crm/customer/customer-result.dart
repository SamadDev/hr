
import 'package:nandrlon/models/crm/customer/customer.dart';

class CustomerResult extends Customer {
  String groupName;
  String statusName;
  String statusColor;
  String sourceName;
  String cityName;
  String districtName;
  int totalRecords;

  CustomerResult({
    this.groupName,
    this.statusName,
    this.statusColor,
    this.sourceName,
    this.cityName,
    this.districtName,
    this.totalRecords,
  });

  CustomerResult.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    groupName = json['groupName'];
    statusName = json['statusName'];
    statusColor = json['statusColor'];
    sourceName = json['sourceName'];
    cityName = json['cityName'];
    districtName = json['districtName'];
    totalRecords = json['totalRecords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupName'] = this.groupName;
    data['statusName'] = this.statusName;
    data['statusColor'] = this.statusColor;
    data['sourceName'] = this.sourceName;
    data['cityName'] = this.cityName;
    data['districtName'] = this.districtName;
    data['totalRecords'] = this.totalRecords;
    return data;
  }

  static List<CustomerResult> toList(parsed) {
    return parsed
        .map<CustomerResult>((json) => CustomerResult.fromJson(json))
        .toList();
  }
}
