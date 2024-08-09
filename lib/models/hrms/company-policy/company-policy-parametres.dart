import 'package:nandrlon/models/hrms/company-policy/company-policy-status.dart';
import 'package:nandrlon/models/hrms/item-list.dart';

class CompanyPolicyParameters {
  String title;
  String fromDate;
  String toDate;
  List<ItemList> companyPolicyStatuses;
  int pageNumber;
  int pageSize;

  CompanyPolicyParameters({
    this.title = "",
    this.fromDate,
    this.toDate,
    this.companyPolicyStatuses,
    this.pageNumber = 1,
    this.pageSize = 25,
  });

  CompanyPolicyParameters.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    if (json['companyPolicyStatuses'] != null) {
      companyPolicyStatuses = <ItemList>[];
      json['companyPolicyStatuses'].forEach((v) {
        companyPolicyStatuses.add(new ItemList.fromJson(v));
      });
    }
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    if (this.companyPolicyStatuses != null) {
      data['companyPolicyStatuses'] =
          this.companyPolicyStatuses.map((v) => v.toJson()).toList();
    }
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    return data;
  }
}
