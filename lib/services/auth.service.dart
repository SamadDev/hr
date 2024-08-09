import 'package:nandrlon/models/crm/shared/result.dart';
import 'package:nandrlon/services/crm.service.dart';

class AuthService {
  static String api = "/api/auth";

  static Future<Result> signIn(signIn) async {
    return await CRMDataService.post('$api/sign-in', signIn);
  }
}
