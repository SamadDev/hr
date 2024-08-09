
import 'package:nandrlon/models/crm/shared/source.dart';
import 'package:nandrlon/services/crm.service.dart';

class SourceService {
  static String api = "/api/cim/sources";

  static Future<List<Source>> getSources() async {
    final result = await CRMDataService.get(api);
    return Source.toList(result);
  }
}
