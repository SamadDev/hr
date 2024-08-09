import 'package:nandrlon/models/crm/sales-order/sales-order-result.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order-statuses.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order.dart';
import 'package:nandrlon/models/crm/sales-order/undelivered-sales-item.dart';
import 'package:nandrlon/models/crm/shared/result.dart';
import 'package:nandrlon/services/crm.service.dart';
class SalesOrderService {
  static String api = "/api/crm/sales-orders";

  static Future<List<SalesOrderResult>> salesOrders(search) async {
    final result = await CRMDataService.get(api + search.toString());
    return SalesOrderResult.toList(result);
  }

  static Future<List<SalesOrderResult>> getUndeliveredSalesOrders(int customerId) async {
    final result = await CRMDataService.get("$api/${customerId.toString()}/undelivered");
    return SalesOrderResult.toList(result);
  }

  static Future<List<UndeliveredSalesItem>> getUndeliveredSalesItems(int itemId) async {
    final result = await CRMDataService.get("$api/${itemId.toString()}/undelivered-items");
    return UndeliveredSalesItem.toList(result);
  }

  static Future<List<SalesOrderStatus>> statuses() async {
    final result = await CRMDataService.get(api + "/statuses");
    return SalesOrderStatus.toList(result);
  }

  static Future<SalesOrder> get(int id) async {
    final result = await CRMDataService.get('$api/$id');
    return SalesOrder.fromJson(result);
  }

  static Future<Result> create(SalesOrder salesOrder) async {
    return await CRMDataService.post(api, salesOrder);
  }

  static Future<Result> update(SalesOrder salesOrder) async {
    return await CRMDataService.put("$api", salesOrder);
  }

  static Future<Result> delete(int id) async {
    return await CRMDataService.delete("$api/$id");
  }

  static Future<Result> duplicate(int id) async {
    return await CRMDataService.getResult("$api/$id/duplicate");
  }
}
