import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order-detail.dart';
import 'package:nandrlon/models/crm/shared/entity-mode.dart';

class SalesOrder {
  int id;
  String orderNo;
  String orderDate;
  int customerId;
  Customer customer;
  int employeeId;
  int salesOrderStatusId;
  double subTotal;
  double discount = 0;
  double total;
  String deliveryDate;
  String dueDate;
  String description;
  List<SalesOrderDetail> details;
  EntityMode entityMode;

  SalesOrder({
    this.id,
    this.orderNo,
    this.orderDate,
    this.customerId,
    this.customer,
    this.employeeId,
    this.salesOrderStatusId,
    this.subTotal,
    this.discount,
    this.total,
    this.deliveryDate,
    this.dueDate,
    this.description,
    this.details,
    this.entityMode,
  });

  SalesOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['orderNo'];
    orderDate = json['orderDate'];
    customerId = json['customerId'];
    employeeId = json['employeeId'];
    salesOrderStatusId = json['salesOrderStatusId'];
    subTotal = json['subTotal'];
    discount = json['discount'];
    total = json['total'];
    deliveryDate = json['deliveryDate'];
    dueDate = json['dueDate'];
    description = json['description'];
    entityMode = IntToEntityMode(json['entityMode']);
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;

    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new SalesOrderDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderNo'] = this.orderNo;
    data['orderDate'] = this.orderDate;
    data['customerId'] = this.customerId;
    data['employeeId'] = this.employeeId;
    data['salesOrderStatusId'] = this.salesOrderStatusId;
    data['subTotal'] = this.subTotal;
    data['discount'] = this.discount;
    data['total'] = this.total;
    data['deliveryDate'] = this.deliveryDate;
    data['dueDate'] = this.dueDate;
    data['description'] = this.description;
    data['entityMode'] = EntityModeToInt(this.entityMode.toString());

    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }

    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
