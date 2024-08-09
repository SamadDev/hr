import 'package:nandrlon/models/crm/Item/Item-group.dart';
import 'package:nandrlon/models/crm/Item/item.dart';
import 'package:nandrlon/models/crm/shared/entity-mode.dart';

class DeliveryNoteDetail {
  int id;
  int deliveryNoteId;
  int itemId;
  int itemUnitId;
  String itemCode;
  int packing;
  int packingQuantity;
  double quantity = 0;
  String description;
  Item item;
  ItemGroup itemUnit;
  String deliveryNote;
  EntityMode entityMode;

  DeliveryNoteDetail({
    this.id,
    this.deliveryNoteId,
    this.itemId,
    this.itemUnitId,
    this.itemCode,
    this.packing,
    this.packingQuantity,
    this.quantity,
    this.description,
    this.item,
    this.itemUnit,
    this.deliveryNote,
    this.entityMode,
  });

  DeliveryNoteDetail.fromJson(Map<String, dynamic> json) {
    entityMode = json['entityMode'];
    id = json['id'];
    deliveryNoteId = json['deliveryNoteId'];
    itemId = json['itemId'];
    itemUnitId = json['itemUnitId'];
    itemCode = json['itemCode'];
    packing = json['packing'];
    packingQuantity = json['packingQuantity'];
    quantity = json['quantity'];
    description = json['description'];
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
    deliveryNote = json['deliveryNote'];
    entityMode = IntToEntityMode(json['entityMode']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entityMode'] = this.entityMode;
    data['id'] = this.id;
    data['deliveryNoteId'] = this.deliveryNoteId;
    data['itemId'] = this.itemId;
    data['itemUnitId'] = this.itemUnitId;
    data['itemCode'] = this.itemCode;
    data['packing'] = this.packing;
    data['packingQuantity'] = this.packingQuantity;
    data['quantity'] = this.quantity;
    data['description'] = this.description;

    data['deliveryNote'] = this.deliveryNote;
    data['entityMode'] = EntityModeToInt(this.entityMode.toString());
    return data;
  }
}
