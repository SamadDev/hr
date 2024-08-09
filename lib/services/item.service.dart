import 'package:nandrlon/models/crm/Item/Item-group.dart';
import 'package:nandrlon/models/crm/Item/Item-result.dart';
import 'package:nandrlon/models/crm/Item/Item-type.dart';
import 'package:nandrlon/models/crm/Item/Item-unit.dart';
import 'package:nandrlon/models/crm/Item/item-parameter.dart';
import 'package:nandrlon/models/crm/Item/item-photo.dart';
import 'package:nandrlon/models/crm/Item/item.dart';
import 'package:nandrlon/services/crm.service.dart';

class ItemService {
  static String api = "/api/pim/items";

  static Future<List<ItemResult>> getItemResult(ItemParameters parameters) async {
    final result = await CRMDataService.get("$api/list" + parameters.toString());
    return ItemResult.toList(result);
  }

  static Future<List<Item>> getItems(ItemParameters parameters) async {
    final result = await CRMDataService.get(api + parameters.toString());
    return Item.toList(result);
  }

  static Future<List<ItemGroup>> getItemGroups() async {
    final result = await CRMDataService.get("$api/groups");
    return ItemGroup.toList(result);
  }

  static Future<List<ItemType>> getItemTypes() async {
    final result = await CRMDataService.get("$api/types");
    return ItemType.toList(result);
  }

  static Future<List<ItemUnit>> getItemUnits() async {
    final result = await CRMDataService.get('$api/units');
    return ItemUnit.toList(result);
  }

  static Future<List<ItemPhoto>> photos(id) async {
    final result = await CRMDataService.get('$api/$id/photos');
    return ItemPhoto.toList(result);
  }
}
