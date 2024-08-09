import 'package:nandrlon/models/crm/Item/item.dart';

class ItemResult extends Item {
  
  String groupName;
  String typeName;
  String unitName;
  bool selected;
  bool isAddToBasket;
  String batchNo;
  String expiryDate;
  double quantity = 0;
  double discount = 0;
  double total;
  int totalRecords;

  ItemResult({
    this.groupName,
    this.typeName,
    this.unitName,
    this.totalRecords,
    this.selected,
    this.isAddToBasket,
    this.batchNo,
    this.expiryDate,
    this.quantity,
    this.discount,
    this.total,
  });

  ItemResult.fromJson(Map<String, dynamic> json) :super.fromJson(json) {
    
    groupName = json['groupName'];
    typeName = json['typeName'];
    unitName = json['unitName'];
    totalRecords = json['totalRecords'];
  }

  static List<ItemResult> toList(parsed) {
    return parsed.map<ItemResult>((json) => ItemResult.fromJson(json)).toList();
  }
}
