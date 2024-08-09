
import 'package:nandrlon/models/crm/survey/survey.dart';
import 'package:nandrlon/services/crm.service.dart';

class SurveyService {
  static String api = "/api/crm/surveys";

  static Future<List<Survey>> getSurveys() async {
    final result = await CRMDataService.get(api);
    return Survey.toList(result);
  }

  static Future<Survey> getSurvey(int id) async {
    final result = await CRMDataService.get("$api/$id");
    return Survey.fromJson(result);
  }
}
