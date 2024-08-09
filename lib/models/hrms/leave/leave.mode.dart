import 'package:flutter/material.dart';
import 'package:nandrlon/models/employee-filter.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-type.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-time-type.model.dart';

class EmployeeLeave {
  int leaveStatusId;
  List<EmployeeLeaveDetails> employeeLeaveDetails;
  bool enableApproval;
  int employeeId;
  int leaveTimeTypeId;
  int leaveTypeId;
  LeaveType leaveType;
  LeaveTimeType leaveTimeType;
  String requestDate;
  String startDate;
  TimeOfDay fromTime;
  TimeOfDay toTime;
  String endDate;
  double duration;
  String reason;
  EmployeeFilter delegateeEmployee;
  int delegateeEmployeeId;

  EmployeeLeave({
    this.leaveStatusId,
    this.employeeLeaveDetails,
    this.enableApproval,
    this.employeeId,
    this.leaveTimeTypeId,
    this.leaveTypeId,
    this.leaveType,
    this.leaveTimeType,
    this.requestDate,
    this.startDate,
    this.endDate,
    this.duration,
    this.reason,
    this.delegateeEmployee,
    this.delegateeEmployeeId,
  });

  EmployeeLeave.fromJson(Map<String, dynamic> json) {
    leaveStatusId = json['leaveStatusId'];
    if (json['employeeLeaveDetails'] != null) {
      employeeLeaveDetails = <EmployeeLeaveDetails>[];
      json['employeeLeaveDetails'].forEach((v) {
        employeeLeaveDetails.add(new EmployeeLeaveDetails.fromJson(v));
      });
    }
    enableApproval = json['enableApproval'];
    employeeId = json['employeeId'];
    leaveTimeTypeId = json['leaveTimeTypeId'];
    leaveTypeId = json['leaveTypeId'];
    requestDate = json['requestDate'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    duration = json['duration'];
    reason = json['reason'];
    delegateeEmployeeId = json['delegateeEmployeeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leaveStatusId'] = this.leaveStatusId;
    if (this.employeeLeaveDetails != null) {
      data['employeeLeaveDetails'] =
          this.employeeLeaveDetails.map((v) => v.toJson()).toList();
    }
    data['enableApproval'] = this.enableApproval;
    data['employeeId'] = this.employeeId;
    data['leaveTimeTypeId'] = this.leaveTimeTypeId;
    data['leaveTypeId'] = this.leaveTypeId;
    data['requestDate'] = this.requestDate;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['duration'] = this.duration;
    data['reason'] = this.reason;
    data['delegateeEmployeeId'] = this.delegateeEmployeeId;
    return data;
  }
}

class EmployeeLeaveDetails {
  int entityMode;
  String date;
  int duration;
  String status;
  String statusColor;

  EmployeeLeaveDetails(
      {this.entityMode,
      this.date,
      this.duration,
      this.status,
      this.statusColor});

  EmployeeLeaveDetails.fromJson(Map<String, dynamic> json) {
    entityMode = json['entityMode'];
    date = json['date'];
    duration = json['duration'];
    status = json['status'];
    statusColor = json['statusColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entityMode'] = this.entityMode;
    data['date'] = this.date;
    data['duration'] = this.duration;
    data['status'] = this.status;
    data['statusColor'] = this.statusColor;
    return data;
  }
}
