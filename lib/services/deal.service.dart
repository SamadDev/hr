import 'package:nandrlon/models/crm/deal/deal-result.dart';
import 'package:nandrlon/models/crm/deal/deal.dart';
import 'package:nandrlon/models/crm/deal/stage.dart';
import 'package:nandrlon/services/crm.service.dart';

class DealService {
  static String api = "/api/crm/deals";


  static Future<List<DealResult>> getDeals(search) async {
    final result = await CRMDataService.get(api + search.toString());
    return DealResult.toList(result);
  }

  static Future<void> create(Deal deal) async {
    final result = await CRMDataService.post(api, deal);
    return DealResult.fromJson(result.data);
  }

  static Future<void> update(Deal deal) async {
    final result = await CRMDataService.put("$api", deal);
    return DealResult.fromJson(result.data);
  }

  static Future<List<Stage>> getStages() async {
    final result = await CRMDataService.get("$api/stages");
    return Stage.toList(result);
  }
}
