import 'package:nandrlon/models/crm/customer/customer.dart';
class SalesOrderParameters {
  String orderNo;
  Customer customer;
  int customerId = 0;
  int employeeId = 0;
  String fromDate;
  String toDate;
  String sortColumn;
  String sortDirection;
  String pageNumber;
  String pageSize;

  SalesOrderParameters(
      {this.orderNo,
        this.employeeId,
        this.customer,
        this.customerId,
        this.fromDate,
        this.toDate,
        this.sortColumn,
        this.sortDirection,
        this.pageNumber,
        this.pageSize});

  SalesOrderParameters.fromJson(Map<String, dynamic> json) {
    orderNo = json['OrderNo'];
    customerId = json['CustomerId'] ;
    employeeId = json['EmployeeId'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    sortColumn = json['SortColumn'];
    sortDirection = json['SortDirection'];
    pageNumber = json['PageNumber'];
    pageSize = json['PageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderNo'] = this.orderNo;
    data['CustomerId'] = this.customerId;
    data['EmployeeId'] = this.employeeId;
    data['FromDate'] = this.fromDate;
    data['ToDate'] = this.toDate;
    data['SortColumn'] = this.sortColumn;
    data['SortDirection'] = this.sortDirection;
    data['PageNumber'] = this.pageNumber;
    data['PageSize'] = this.pageSize;
    return data;
  }

  String toString() {
    return '?OrderNo=${this.orderNo ?? ""}&CustomerId=${this.customerId ?? ""}&EmployeeId=${this.employeeId ?? ""}&FromDate=${this.fromDate  ?? ""}&ToDate=${this.toDate  ?? ""}&SortColumn=${this.sortColumn ?? "Id"}&SortDirection=${this.sortDirection ?? "Desc"}&PageNumber=${this.pageNumber ?? 1}&PageSize=${this.pageSize ?? 25}';
  }
}
