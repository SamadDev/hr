import 'package:nandrlon/models/employee-filter.model.dart';
import 'package:nandrlon/models/hrms/item-list.dart';
import 'package:nandrlon/models/hrms/leave/leave-status.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-time-type.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-type.model.dart';

class LeaveParameters {
  int employeeId;
  EmployeeFilter employee;
  int approverId;
  LeaveType leaveType;
  List<ItemList> leaveTypes;
  LeaveTimeType leaveTimeType;
  List<ItemList> leaveTimeTypes;
  LeaveStatus leaveStatus;
  List<ItemList> leaveStatuses;
  int fromDuration;
  int toDuration;
  String startDate;
  String endDate;
  int pageNumber;
  int pageSize;

  LeaveParameters({
    this.employeeId,
    this.employee,
    this.approverId,
    this.leaveTypes,
    this.leaveTimeTypes,
    this.leaveStatus,
    this.leaveStatuses,
    this.fromDuration,
    this.toDuration,
    this.startDate,
    this.endDate,
    this.pageNumber = 1,
    this.pageSize = 25,
  });

  LeaveParameters.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    approverId = json['approverId'];
    if (json['leaveTypes'] != null) {
      leaveTypes = <ItemList>[];
      json['leaveTypes'].forEach((v) {
        leaveTypes.add(new ItemList.fromJson(v));
      });
    }
    if (json['leaveTimeTypes'] != null) {
      leaveTimeTypes = <ItemList>[];
      json['leaveTimeTypes'].forEach((v) {
        leaveTimeTypes.add(new ItemList.fromJson(v));
      });
    }
    if (json['leaveStatuses'] != null) {
      leaveStatuses = <ItemList>[];
      json['leaveStatuses'].forEach((v) {
        leaveStatuses.add(new ItemList.fromJson(v));
      });
    }
    fromDuration = json['fromDuration'];
    toDuration = json['toDuration'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['approverId'] = this.approverId;
    if (this.leaveTypes != null) {
      data['leaveTypes'] = this.leaveTypes.map((v) => v.toJson()).toList();
    }
    if (this.leaveTimeTypes != null) {
      data['leaveTimeTypes'] =
          this.leaveTimeTypes.map((v) => v.toJson()).toList();
    }
    if (this.leaveStatuses != null) {
      data['leaveStatuses'] =
          this.leaveStatuses.map((v) => v.toJson()).toList();
    }
    data['fromDuration'] = this.fromDuration;
    data['toDuration'] = this.toDuration;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    return data;
  }
}
