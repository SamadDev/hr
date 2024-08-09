import 'package:nandrlon/models/crm/Item/Item-result.dart';
import 'package:nandrlon/models/crm/Item/item.dart';
import 'package:nandrlon/models/crm/shared/entity-mode.dart';

class SalesOrderDetail {
  int id;
  int salesOrderId;
  int itemId;
  Item item;
  double quantity;
  double bonus;
  double price;
  double discount;
  double total;
  String description;
  String salesOrder;
  EntityMode entityMode;

  SalesOrderDetail({
    this.id,
    this.salesOrderId,
    this.itemId,
    this.item,
    this.quantity,
    this.bonus,
    this.price,
    this.discount,
    this.total,
    this.description,
    this.salesOrder,
    this.entityMode,
  });

  SalesOrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesOrderId = json['salesOrderId'];
    itemId = json['itemId'];
    quantity = json['quantity'];
    bonus = json['bonus'];
    price = json['price'];
    discount = json['discount'];
    total = json['total'];
    description = json['desciption'];
    salesOrder = json['salesOrder'];
    entityMode = IntToEntityMode(json['entityMode']);
    item = json['item'] != null ? new ItemResult.fromJson(json['item']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['salesOrderId'] = this.salesOrderId;
    data['itemId'] = this.itemId;
    data['quantity'] = this.quantity;
    data['bonus'] = this.bonus;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['total'] = this.total;
    data['description'] = this.description;
    data['salesOrder'] = this.salesOrder;
    data['entityMode'] =  EntityModeToInt(this.entityMode.toString());
    if (this.item != null) {
      data['item'] = this.item.toJson();
    }
    return data;
  }
}
