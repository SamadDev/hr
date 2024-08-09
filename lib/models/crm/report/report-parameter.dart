import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/menu.dart';

class ReportParameters {
  Customer customer;
  Menu menu;
  int customerId;
  String fromDate;
  String toDate;

  ReportParameters({
    this.customer,
    this.menu,
    this.customerId,
    this.fromDate,
    this.toDate,
  });

  ReportParameters.fromJson(Map<String, dynamic> json) {
    customer = json['customer'];
    menu = json['menu'];
    customerId = json['customerId'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer'] = this.customer;
    data['menu'] = this.menu;
    data['customerId'] = this.customerId;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    return data;
  }

  String toQueryString(ReportParameters parameters) {
    final json = parameters.toJson();

    String params = "";
    json.forEach((final String key, final value) {
      params += "${key}=${value},";
    });

    return params.substring(0, params.length - 1);
  }

// String toString() {
//   final str;
//
//   if(this.customerId > 0) {
//     str+=
//   }
//
//
//   final json = device.toJson();
//
//   json.forEach((final String key, final value) {
//     _logger.info("Key: {{$key}} -> value: ${value}");
//     // do with this info whatever you want
//   });
//
//
// }
//
// String toString() {
//   return '?OrderNo=${this.orderNo ?? ""}&CustomerId=${this.customerId ?? ""}&EmployeeId=${this.employeeId ?? ""}&FromDate=${this.fromDate  ?? ""}&ToDate=${this.toDate  ?? ""}&SortColumn=${this.sortColumn ?? "Id"}&SortDirection=${this.sortDirection ?? "Desc"}&PageNumber=${this.pageNumber ?? 1}&PageSize=${this.pageSize ?? 25}';
// }
}
