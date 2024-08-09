import 'package:nandrlon/models/hrms/punishment/punishment-type.model.dart';

class PunishmentParameters {
  int employeeId;
  int punishmentTypeId;
  PunishmentType punishmentType;
  String fromDate;
  String toDate;
  int pageNumber;
  int pageSize;

  PunishmentParameters({
    this.employeeId,
    this.punishmentTypeId,
    this.punishmentType,
    this.fromDate,
    this.toDate,
    this.pageNumber = 1,
    this.pageSize = 25,
  });

  PunishmentParameters.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    punishmentTypeId = json['punishmentTypeId'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['punishmentTypeId'] = this.punishmentTypeId;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    return data;
  }
}
