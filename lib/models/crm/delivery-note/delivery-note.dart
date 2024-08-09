import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/delivery-note/delivery-note-detail.dart';
import 'package:nandrlon/models/crm/shared/entity-mode.dart';
import 'package:nandrlon/models/crm/warehouse/warehouse.dart';

class DeliveryNote {
  int id;
  String deliveryNo;
  String deliveryDate;
  int refId;
  String refNo;
  String refDate;
  int customerId;
  Customer customer;
  int customerContactId;
  int customerBrandId;
  int warehouseId;
  Warehouse warehouse;
  String driverName;
  String driverPhone;
  String description;
  List<DeliveryNoteDetail> details;
  EntityMode entityMode;


  DeliveryNote({
    this.id,
    this.deliveryNo,
    this.deliveryDate,
    this.refId,
    this.refNo,
    this.refDate,
    this.customerId,
    this.customer,
    this.warehouse,
    this.customerContactId,
    this.customerBrandId,
    this.warehouseId,
    this.driverName,
    this.driverPhone,
    this.description,
    this.details,
    this.entityMode,

  });

  DeliveryNote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deliveryNo = json['deliveryNo'];
    deliveryDate = json['deliveryDate'];
    refId = json['refId'];
    refNo = json['refNo'];
    refDate = json['refDate'];
    customerId = json['customerId'];
    customerContactId = json['customerContactId'];
    customerBrandId = json['customerBrandId'];
    warehouseId = json['warehouseId'];
    driverName = json['driverName'];
    driverPhone = json['driverPhone'];
    description = json['description'];
    entityMode = IntToEntityMode(json['entityMode']);
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;

    if (json['details'] != null) {
      details = <DeliveryNoteDetail>[];
      json['details'].forEach((v) {
        details.add(new DeliveryNoteDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deliveryNo'] = this.deliveryNo;
    data['deliveryDate'] = this.deliveryDate;
    data['refId'] = this.refId;
    data['refNo'] = this.refNo;
    data['refDate'] = this.refDate;
    data['customerId'] = this.customerId;
    data['customerContactId'] = this.customerContactId;
    data['customerBrandId'] = this.customerBrandId;
    data['warehouseId'] = this.warehouseId;
    data['driverName'] = this.driverName;
    data['driverPhone'] = this.driverPhone;
    data['description'] = this.description;
    data['entityMode'] = EntityModeToInt(this.entityMode.toString());

    // if (this.customer != null) {
    //   data['customer'] = this.customer.toJson();
    // }

    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
