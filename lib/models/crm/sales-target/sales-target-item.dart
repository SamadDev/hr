import 'package:nandrlon/models/crm/Item/item.dart';

class SalesTargetItem {
  int id;
  int salesTargetId;
  int itemId;
  double quantity;
  Item item;

  SalesTargetItem(
      {this.id,
        this.salesTargetId,
        this.itemId,
        this.quantity,
        this.item});

  SalesTargetItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesTargetId = json['salesTargetId'];
    itemId = json['itemId'];
    quantity = json['quantity'];
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['salesTargetId'] = this.salesTargetId;
    data['itemId'] = this.itemId;
    data['quantity'] = this.quantity;
    if (this.item != null) {
      data['item'] = this.item.toJson();
    }
    return data;
  }


  static List<SalesTargetItem> toList(parsed) {
    return parsed
        .map<SalesTargetItem>((json) => SalesTargetItem.fromJson(json))
        .toList();
  }
}
