import 'package:nandrlon/models/hrms/leave-approval.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-result.model.dart';
import 'package:nandrlon/models/hrms/leave/leave.mode.dart';

import 'data.service.dart';

class LeaveService {
  static Future<List<LeaveResult>> getAll(userId) async {
    var result = await DataService.get('mobile/hr/employees/$userId/leaves');
    return result["employeeLeaves"]
        .map<LeaveResult>((json) => LeaveResult.fromJson(json))
        .toList();
  }

  static Future create(EmployeeLeave employeeLeave) async {
    return await DataService.post('HR/EmployeeLeaves/Create', employeeLeave);
  }

  static Future<LeaveResult> update(EmployeeLeave employeeLeave) async {
    return await DataService.post('api/HR/EmployeeLeaves', employeeLeave);
  }

}
