import 'package:nandrlon/models/crm/Item/item.dart';

class CustomerInventoryItem {
  int id;
  int customerInventoryId;
  int itemId;
  double quantity;
  double price;
  String description;
  String customerInventory;
  bool isAddToBasket;
  String batchNo;
  String expiryDate;
  Item item;

  CustomerInventoryItem({
    this.id,
    this.customerInventoryId,
    this.itemId,
    this.quantity,
    this.price,
    this.description,
    this.customerInventory,
    this.isAddToBasket,
    this.batchNo,
    this.expiryDate,
    this.item,
  });

  CustomerInventoryItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerInventoryId = json['customerInventoryId'];
    itemId = json['itemId'];
    quantity = json['quantity'];
    price = json['price'];
    description = json['description'];
    customerInventory = json['customerInventory'];
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerInventoryId'] = this.customerInventoryId;
    data['itemId'] = this.itemId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['description'] = this.description;
    data['customerInventory'] = this.customerInventory;
    if (this.item != null) {
      data['item'] = this.item.toJson();
    }
    return data;
  }

  static List<CustomerInventoryItem> toList(parsed) {
    return parsed
        .map<CustomerInventoryItem>(
            (json) => CustomerInventoryItem.fromJson(json))
        .toList();
  }
}
