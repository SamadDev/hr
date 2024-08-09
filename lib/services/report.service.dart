import 'package:nandrlon/models/crm/warehouse/warehouse.dart';
import 'package:nandrlon/services/crm.service.dart';

class WarehouseService {
  static String api = "/api/wms/warehouses";

  static Future<List<Warehouse>> getAll() async {
    final result = await CRMDataService.get(api);
    return Warehouse.toList(result);
  }
}
