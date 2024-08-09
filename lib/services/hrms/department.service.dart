import 'package:nandrlon/models/hrms/branch.model.dart';
import 'package:nandrlon/models/hrms/department.model.dart';
import 'package:nandrlon/services/data.service.dart';

class DepartmentService {
  static Future<List<Department>> get() async {
    var result = await DataService.get('hr/departments');
    return result.map<Department>((json) => Department.fromJson(json)).toList();
  }
}
