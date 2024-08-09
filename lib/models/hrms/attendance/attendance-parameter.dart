import 'package:nandrlon/models/employee-filter.model.dart';
import 'package:nandrlon/models/hrms/attendance/attendance-status.model.dart';
import 'package:nandrlon/models/hrms/item-list.dart';

class AttendanceParameters {
  int reportingTo;
  int employeeId;
  EmployeeFilter employee;
  String fromDate;
  String toDate;
  List<ItemList> branches;
  List<ItemList> departments;
  List<ItemList> shifts;
  List<ItemList> statuses;
  AttendanceStatus attendanceStatus;
  String sortColumn = "date";
  String sortDirection = "desc";

  AttendanceParameters({
    this.reportingTo,
    this.employeeId,
    this.employee,
    this.fromDate,
    this.toDate,
    this.branches,
    this.departments,
    this.shifts,
    this.statuses,
    this.attendanceStatus,
    this.sortColumn,
    this.sortDirection,
  });

  AttendanceParameters.fromJson(Map<String, dynamic> json) {
    reportingTo = json['reportingTo'];
    employeeId = json['employeeId'];
    employee = json['employee'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    if (json['branches'] != null) {
      branches = <ItemList>[];
      json['branches'].forEach((v) {
        branches.add(new ItemList.fromJson(v));
      });
    }
    if (json['departments'] != null) {
      departments = <ItemList>[];
      json['departments'].forEach((v) {
        departments.add(new ItemList.fromJson(v));
      });
    }
    if (json['shifts'] != null) {
      shifts = <ItemList>[];
      json['shifts'].forEach((v) {
        shifts.add(new ItemList.fromJson(v));
      });
    }
    if (json['statuses'] != null) {
      statuses = <ItemList>[];
      json['statuses'].forEach((v) {
        statuses.add(new ItemList.fromJson(v));
      });
    }
    sortColumn = json['sortColumn'];
    sortDirection = json['sortDirection'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['reportingTo'] = this.reportingTo;
    data['employee'] = this.employee;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    if (this.branches != null) {
      data['branches'] = this.branches.map((v) => v.toJson()).toList();
    }
    if (this.departments != null) {
      data['departments'] = this.departments.map((v) => v.toJson()).toList();
    }
    if (this.shifts != null) {
      data['shifts'] = this.shifts.map((v) => v.toJson()).toList();
    }
    if (this.statuses != null) {
      data['statuses'] = this.statuses.map((v) => v.toJson()).toList();
    }
    data['sortColumn'] = this.sortColumn;
    data['sortDirection'] = this.sortDirection;
    return data;
  }
}
