import 'package:nandrlon/models/attendance.model.dart';
import 'package:nandrlon/models/dashboard.dart';
import 'package:nandrlon/models/employee-profile.dart';
import 'package:nandrlon/models/hrms/employee/employee-parameters.dart';
import 'package:nandrlon/models/hrms/employee/employee.model.dart';
import 'package:nandrlon/models/hrms/employee/profile.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-result.model.dart';
import 'package:nandrlon/models/team.model.dart';

import 'data.service.dart';

class EmployeeService {
  static Future<List<Employee>> getEmployees(String employeeName) async {
    var result = await DataService.get(
        'mobile/hr/employees/list?employeeName=$employeeName&pageNumber=1&pageSize=25');
    return result["employees"]
        .map<Employee>((json) => Employee.fromJson(json))
        .toList();
  }

  static Future<List<Employee>> getEmployeesList(
      EmployeeParameters employeeParameters) async {
    var result = await DataService.get(
        'mobile/hr/employees/list' + employeeParameters.toString());

    return result["employees"]
        .map<Employee>((json) => Employee.fromJson(json))
        .toList();
  }

  static Future<Profile> getEmployee(int employeeId) async {
    var result = await DataService.get('mobile/hr/employees/$employeeId');
    return Profile.fromJson(result);
  }

  static Future<Dashboard> getDashboard(int employeeId) async {
    var result = await DataService.get('HR/Dashboard/$employeeId/overview/');
    return Dashboard.fromJson(result);
  }

  static Future<List<Team>> getTeam(userId) async {
    var result = await DataService.get('mobile/hr/employees/$userId/team');
    return result.map<Team>((json) => Team.fromJson(json)).toList();
  }

  static Future<EmployeeProfile> getProfile(employeeId) async {
    var result = await DataService.get('mobile/hr/employees/$employeeId/profile');
    return EmployeeProfile.fromJson(result);
  }

  static Future<dynamic> checkPhone(String phoneNo) async {
    return await DataService.post('mobile/hr/employees/verify', phoneNo);
  }

  static Future<dynamic> updateToken(int employeeId, String token) async {
    return await DataService.post(
        'mobile/hr/employees/${employeeId}/update-token', token);
  }

  static Future<dynamic> updateLanguage(int employeeId, String languageCode) async {
    return await DataService.post(
        'mobile/hr/employees/${employeeId}/update-language', languageCode);
  }

  static Future<List<LeaveResult>> getLeaves(userId) async {
    var result = await DataService.get('mobile/hr/employees/$userId/leaves');
    return result["employeeLeaves"]
        .map<LeaveResult>((json) => LeaveResult.fromJson(json))
        .toList();
  }

  static Future<List<Attendance>> getAttendance(userId) async {
    var result =
        await DataService.get('mobile/hr/employees/$userId/attendances');
    return result["employeeAttendance"]
        .map<Attendance>((json) => Attendance.fromJson(json))
        .toList();
  }
}
