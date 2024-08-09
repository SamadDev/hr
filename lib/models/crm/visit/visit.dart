import 'package:nandrlon/models/crm/visit/visit-purpose.dart';
import 'package:nandrlon/models/crm/visit/visit-result.dart';
import 'package:nandrlon/models/crm/visit/visit-status.dart';

class Visit {
  int id;
  int employeeId;
  int customerId;
  String date;
  String startTime;
  String endTime;
  VisitPurpose visitPurpose;
  int visitPurposeId;
  int visitResultId;
  VisitResult visitResult;
  int visitStatusId;
  VisitStatus visitStatus;
  String latitude;
  String longitude;
  String description;

  Visit({
    this.id,
    this.employeeId,
    this.customerId,
    this.date,
    this.startTime,
    this.endTime,
    this.visitPurposeId,
    this.visitResultId,
    this.visitStatusId,
    this.latitude,
    this.longitude,
    this.description,
  });

  Visit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    customerId = json['customerId'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    visitPurposeId = json['visitPurposeId'];
    visitResultId = json['visitResultId'];
    visitStatusId = json['visitStatusId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employeeId'] = this.employeeId;
    data['customerId'] = this.customerId;
    data['date'] = this.date;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['visitPurposeId'] = this.visitPurposeId;
    data['visitResultId'] = this.visitResultId;
    data['visitStatusId'] = this.visitStatusId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['description'] = this.description;
    return data;
  }
}
