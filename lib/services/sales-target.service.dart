import 'package:nandrlon/models/crm/sales-target/sales-target-item-result.dart';
import 'package:nandrlon/models/crm/sales-target/sales-target.dart';
import 'package:nandrlon/services/crm.service.dart';

class SalesTargetService {
  static String api = "/api/crm/sales-targets";

  static Future<List<SalesTarget>> getSalesTargets(parameters) async {
    final result = await CRMDataService.get(api + parameters.toString());
    return SalesTarget.toList(result);
  }

  static Future<List<SalesTargetItemResult>> getSalesTargetItems(int id) async {
    final result = await CRMDataService.get("${api}/$id/items");
    return SalesTargetItemResult.toList(result);
  }
  //
  // static Future<SalesTarget> getSalesTarget(int id) async {
  //   final result = await CRMDataService.get('$api/$id');
  //   return SalesTarget.fromJson(result);
  // }
  //
  // static Future<List<SalesTargetResult>> getCustomerSalesTargets(int customerId) async {
  //
  //   final result = await CRMDataService.get('/api/cim/customers/$customerId/contacts/');
  //   return SalesTargetResult.toList(result);
  // }
  //
  // static Future<Result> create(SalesTarget contact) async {
  //   return  await CRMDataService.post(api, contact);
  // }
  //
  // static Future<Result> update(SalesTarget contact) async {
  //   return  await CRMDataService.put("$api", contact);
  // }
}
