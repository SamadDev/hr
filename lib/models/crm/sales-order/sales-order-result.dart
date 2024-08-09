import 'package:nandrlon/models/crm/sales-order/sales-order.dart';

class SalesOrderResult extends SalesOrder {
  String customerName;
  String salesOrderStatusName;
  String groupName;

  SalesOrderResult({this.customerName, this.groupName});

  SalesOrderResult.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    customerName = json['customerName'];
    groupName = json['groupName'];
    salesOrderStatusName = json['salesOrderStatusName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerName'] = this.customerName;
    data['groupName'] = this.groupName;
    data['salesOrderStatusName'] = this.salesOrderStatusName;
    return data;
  }

  static List<SalesOrderResult> toList(parsed) {
    return parsed
        .map<SalesOrderResult>((json) => SalesOrderResult.fromJson(json))
        .toList();
  }
}
