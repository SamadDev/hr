
import 'package:nandrlon/models/crm/visit/visit-purpose.dart';
import 'package:nandrlon/models/crm/visit/visit-result.dart';
import 'package:nandrlon/models/crm/visit/visit-status.dart';
import 'package:nandrlon/models/crm/visit/visit.dart';
import 'package:nandrlon/services/crm.service.dart';

class VisitService {
  static String api = "/api/crm/Visits";

  static Future<Visit> create(Visit visit) async {
    var result = await CRMDataService.post(api, visit);
    return Visit.fromJson(result.data);
  }

  static Future<void> update(Visit visit) async {
    var result = await CRMDataService.put("$api", visit);
    return Visit.fromJson(result.data);
  }

  static Future<List<VisitStatus>> getStatuses() async {
    final result = await CRMDataService.get("$api/statuses");
    return VisitStatus.toList(result);
  }

  static Future<List<VisitPurpose>> getPurposes() async {
    final result = await CRMDataService.get("$api/purposes");
    return VisitPurpose.toList(result);
  }

  static Future<List<VisitResult>> getResults() async {
    final result = await CRMDataService.get("$api/results");
    return VisitResult.toList(result);
  }
}
