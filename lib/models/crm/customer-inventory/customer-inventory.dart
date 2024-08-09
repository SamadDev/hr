import 'package:nandrlon/models/crm/customer-inventory/customer-inventory-item.dart';

class CustomerInventory {
  int id;
  int customerId;
  String date;
  String expiryDate;
  String description;
  List<CustomerInventoryItem> items;

  CustomerInventory({
    this.id,
    this.customerId,
    this.date,
    this.expiryDate,
    this.description,
    this.items,
  });

  CustomerInventory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    date = json['date'];
    expiryDate = json['expiryDate'];
    description = json['description'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items.add(new CustomerInventoryItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['date'] = this.date;
    data['expiryDate'] = this.expiryDate;
    data['description'] = this.description;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static List<CustomerInventory> toList(parsed) {
    return parsed.map<CustomerInventory>((json) => CustomerInventory.fromJson(json)).toList();
  }
}
