import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/services/crm.service.dart';

class CityService {
  static String api = "/api/shared/cities";

  static Future<List<City>> cities() async {
    final result = await CRMDataService.get(api);
    return City.toList(result);
  }
}
