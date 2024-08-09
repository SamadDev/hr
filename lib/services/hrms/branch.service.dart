import 'package:nandrlon/models/hrms/branch.model.dart';
import 'package:nandrlon/services/data.service.dart';

class BranchService {
  static Future<List<Branch>> get() async {
    var result = await DataService.get('hr/branches');
    return result.map<Branch>((json) => Branch.fromJson(json)).toList();
  }
}
