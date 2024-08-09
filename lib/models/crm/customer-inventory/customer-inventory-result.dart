import 'package:nandrlon/models/crm/Item/item.dart';

class CustomerInventoryResult {
  int id;
  int customerId;
  String date;
  String description;
  Item item;

  CustomerInventoryResult({
    this.id,
    this.customerId,
    this.date,
    this.description,
    this.item,
  });

  CustomerInventoryResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    date = json['date'];
    description = json['description'];
    item = json['group'] != null ? new Item.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['date'] = this.date;
    data['description'] = this.description;
    if (this.item != null) {
      data['item'] = this.item.toJson();
    }
    return data;
  }

  static List<CustomerInventoryResult> toList(parsed) {
    return parsed.map<CustomerInventoryResult>((json) => CustomerInventoryResult.fromJson(json)).toList();
  }
}
