import 'package:nandrlon/models/hrms/item-list.dart';

class SalaryParameters {
  int employeeId;
  String fromDate;
  String toDate;
  int month;
  int year;
  List<ItemList> branches;
  int departmentId;
  int jobPositionId;
  int currencyId;
  int payrollWorkflowStatusId;
  int payrollProcessLogId;
  int pageNumber;
  int pageSize;

  SalaryParameters({
    this.employeeId,
    this.fromDate,
    this.toDate,
    this.month = 0,
    this.year,
    this.branches,
    this.departmentId = 0,
    this.jobPositionId = 0,
    this.currencyId = 0,
    this.payrollWorkflowStatusId = 0,
    this.payrollProcessLogId = 0,
    this.pageNumber = 1,
    this.pageSize = 25,
  });

  SalaryParameters.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    month = json['month'];
    year = json['year'];
    if (json['branches'] != null) {
      branches = <Null>[];
      json['branches'].forEach((v) {
        branches.add(new ItemList.fromJson(v));
      });
    }
    departmentId = json['departmentId'];
    jobPositionId = json['jobPositionId'];
    currencyId = json['currencyId'];
    payrollWorkflowStatusId = json['PayrollWorkflowStatusId'];
    payrollProcessLogId = json['payrollProcessLogId'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['month'] = this.month;
    data['year'] = this.year;
    if (this.branches != null) {
      data['branches'] = this.branches.map((v) => v.toJson()).toList();
    }
    data['departmentId'] = this.departmentId;
    data['jobPositionId'] = this.jobPositionId;
    data['currencyId'] = this.currencyId;
    data['PayrollWorkflowStatusId'] = this.payrollWorkflowStatusId;
    data['payrollProcessLogId'] = this.payrollProcessLogId;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    return data;
  }
}


class SalaryTeamParameters {
  int year;
  int month;

  SalaryTeamParameters({this.year, this.month});

  SalaryTeamParameters.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    month = json['month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    data['month'] = this.month;
    return data;
  }
}
