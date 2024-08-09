import 'package:nandrlon/models/hrms/branch.model.dart';
import 'package:nandrlon/models/hrms/department.model.dart';

class EmployeeParameters {
  String employeeName;
  int branchId = 0;
  Branch branch;
  int departmentId;
  Department department;
  int cityId;
  int pageNumber;
  int pageSize;

  EmployeeParameters({
    this.employeeName,
    this.branchId,
    this.branch,
    this.departmentId,
    this.department,
    this.cityId,
    this.pageNumber = 1,
    this.pageSize,
  });

  EmployeeParameters.fromJson(Map<String, dynamic> json) {
    employeeName = json['employeeName'];
    branchId = json['branchId'];
    departmentId = json['departmentId'];
    cityId = json['cityId'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeName'] = this.employeeName;
    data['branchId'] = this.branchId;
    data['departmentId'] = this.departmentId;
    data['cityId'] = this.cityId;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    return data;
  }

  String toString() {
    return '?employeeName=${this.employeeName ?? ""}&BranchId=${this.branchId ?? 0}&DepartmentId=${this.departmentId ?? 0}&CityId=${this.cityId ?? 0}&PageNumber=${this.pageNumber ?? 1}&PageSize=${this.pageSize ?? 25}';
  }
}
