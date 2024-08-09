import 'package:nandrlon/models/crm/Item/Item-group.dart';
import 'package:nandrlon/models/crm/Item/Item-type.dart';
import 'package:nandrlon/models/crm/Item/Item-unit.dart';

class Item {
  int id;
  String code;
  String name;
  int itemGroupId;
  int itemTypeId;
  int itemUnitId;
  double price;
  String photo;
  String description;
  ItemGroup group;
  ItemType type;
  ItemUnit unit;
  String photos;

  Item({
    this.id,
    this.code,
    this.name,
    this.itemGroupId,
    this.itemTypeId,
    this.itemUnitId,
    this.price,
    this.photo,
    this.description,
    this.group,
    this.type,
    this.unit,
    this.photos,
  });

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    itemGroupId = json['itemGroupId'];
    itemTypeId = json['itemTypeId'];
    itemUnitId = json['itemUnitId'];
    price = json['price'];
    photo = json['photo'];
    description = json['description'];
    group = json['group'] != null ? new ItemGroup.fromJson(json['group']) : null;
    type = json['type'] != null ? new ItemType.fromJson(json['type']) : null;
    unit = json['unit'] != null ? new ItemUnit.fromJson(json['unit']) : null;
    photos = json['photos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['itemGroupId'] = this.itemGroupId;
    data['itemTypeId'] = this.itemTypeId;
    data['itemUnitId'] = this.itemUnitId;
    data['price'] = this.price;
    data['photo'] = this.photo;
    data['description'] = this.description;
    if (this.group != null) {
      data['group'] = this.group.toJson();
    }
    if (this.type != null) {
      data['type'] = this.type.toJson();
    }
    if (this.unit != null) {
      data['unit'] = this.unit.toJson();
    }
    data['photos'] = this.photos;
    return data;
  }


  static List<Item> toList(parsed) {
    return parsed.map<Item>((json) => Item.fromJson(json)).toList();
  }
}
