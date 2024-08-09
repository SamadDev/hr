import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/models/crm/shared/district.dart';
import 'package:nandrlon/models/crm/shared/gender.dart';
import 'package:nandrlon/models/crm/shared/lookup.dart';
import 'package:nandrlon/models/crm/shared/spoken-language.dart';
import 'package:nandrlon/services/crm.service.dart';

class SharedService {

  static Future<List<City>> getCities() async {
    final result = await CRMDataService.get("/api/shared/cities");
    return City.toList(result);
  }

  static Future<List<District>> getDistricts(int cityId) async {
    final result = await CRMDataService.get("/api/shared/cities/$cityId/districts");
    return District.toList(result);
  }

  static Future<List<Gender>> genders() async {
    final result = await CRMDataService.get("/api/shared/genders");
    return Gender.toList(result);
  }

  static Future<List<SpokenLanguage>> spokenLanguages() async {
    final result = await CRMDataService.get("/api/shared/spoken-languages");
    return SpokenLanguage.toList(result);
  }

  static Future<List<Lookup>> getLookups(String type) async {
    final result = await CRMDataService.get("/api/shared/lookups?type=${type}");
    return Lookup.toList(result);
  }
}
