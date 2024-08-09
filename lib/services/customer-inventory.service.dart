
import 'package:nandrlon/models/crm/customer-inventory/customer-inventory-item.dart';
import 'package:nandrlon/models/crm/customer-inventory/customer-inventory-result.dart';
import 'package:nandrlon/models/crm/customer-inventory/customer-inventory.dart';
import 'package:nandrlon/models/crm/visit/visit.dart';
import 'package:nandrlon/services/crm.service.dart';

class CustomerInventoryService {
  static String api = "/api/crm/customer-inventories";


  static Future<List<CustomerInventoryResult>> getCustomerInventories() async {
    final result = await CRMDataService.get(api);
    return CustomerInventoryResult.toList(result);
  }

  static Future<List<CustomerInventoryItem>> getCustomerInventoryItems(int id) async {
    final result = await CRMDataService.get("$api/$id/items");
    return CustomerInventoryItem.toList(result);
  }

  static Future<Visit> create(CustomerInventory customerInventory) async {
    var result = await CRMDataService.post(api, customerInventory);
    return Visit.fromJson(result.data);
  }

  static Future<void> update(CustomerInventory customerInventory) async {
    var result = await CRMDataService.put("$api", customerInventory);
    return Visit.fromJson(result.data);
  }
}
