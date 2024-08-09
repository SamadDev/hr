import 'package:nandrlon/models/employee-filter.model.dart';
import 'package:nandrlon/models/hrms/announcement/company-policy-parametres.dart';
import 'package:nandrlon/models/hrms/company-policy/company-policy-parametres.dart';
import 'package:nandrlon/models/hrms/employee/employee.model.dart';
import 'package:nandrlon/models/hrms/attendance/attendance-parameter.dart';
import 'package:nandrlon/models/hrms/holiday/holiday-parametres.dart';
import 'package:nandrlon/models/hrms/hrms-result.model.dart';
import 'package:nandrlon/models/hrms/leave-approval.model.dart';
import 'package:nandrlon/models/hrms/leave-balance/leave-balance.dart';
import 'package:nandrlon/models/hrms/leave/leave-detail.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-parametres.dart';
import 'package:nandrlon/models/hrms/leave/leave-result.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-type.model.dart';
import 'package:nandrlon/models/hrms/punishment/punishment-parametres.dart';
import 'package:nandrlon/models/hrms/salary/salary-parameters.dart';
import 'package:nandrlon/models/team-parameter.dart';

import 'data.service.dart';

class TeamService {
  static Future<List<EmployeeFilter>> getEmployeesTeamByName(
      int employeeId, String filter) async {
    

    var result = await DataService.get(
        'hr/Employees/GetEmployeesTeamByName/$employeeId?filter=$filter');
    return result
        .map<EmployeeFilter>((json) => EmployeeFilter.fromJson(json))
        .toList();
  }

  static Future<List<Employee>> getTeam(TeamParameters teamParameters) async {
    var result = await DataService.post(
        'hr/Employees/GetEmployeeContacts', teamParameters);
    return result['employees']
        .map<Employee>((json) => Employee.fromJson(json))
        .toList();
  }

  static Future<List<LeaveResult>> getLeavesApprovals(
      LeaveParameters leaveParameters) async {
    var result = await DataService.post(
        'HR/EmployeeLeaves/GetEmployeeLeavesApprovals', leaveParameters);
    return result['employeeLeaves']
        .map<LeaveResult>((json) => LeaveResult.fromJson(json))
        .toList();
  }

  static Future<List<LeaveResult>> getEmployeeLeaves(
      LeaveParameters leaveParameters) async {
    var result = await DataService.post(
        'HR/EmployeeLeaves/GetEmployeeLeaves', leaveParameters);
    return result['employeeLeaves']
        .map<LeaveResult>((json) => LeaveResult.fromJson(json))
        .toList();
  }

  // static Future<HRMSResult> applyEmployeeLeaveApproval(
  //     int leaveId, dynamic approvalTrack) async {
  //   
  //
  //   var result = await DataService.post(
  //       'HR/EmployeeLeaves/ApplyEmployeeLeaveApproval/${leaveId}',
  //       approvalTrack);
  //
  //   return HRMSResult.fromJson(result);
  // }

  static Future<HRMSResult> applyEmployeeLeaveApproval(
      int leaveId, String reason) async {
    var result =
        await DataService.post('HR/EmployeeLeaves/${leaveId}/approve/', reason);

    
    

    return HRMSResult.fromJson(result);
  }

  static Future<HRMSResult> applyEmployeeLeaveReject(
      int leaveId, String reason) async {
    var result =
        await DataService.post('HR/EmployeeLeaves/${leaveId}/reject/', reason);

    
    

    return HRMSResult.fromJson(result);
  }

  static Future<LeaveDetail> GetEmployeeLeaveResult(int leaveId) async {
    var result = await DataService.get(
        'HR/EmployeeLeaves/GetEmployeeLeaveResult/${leaveId}');
    return LeaveDetail.fromJson(result);
  }

  static Future<List<LeaveApproval>> getLeaveApprovalTracks(leaveId) async {
    var result = await DataService.get('HR/EmployeeLeaves/GetLeaveApprovalTracks/${leaveId}');
    return result
        .map<LeaveApproval>((json) => LeaveApproval.fromJson(json))
        .toList();
  }

  static Future<List<LeaveBalance>> getLeaveBalances(
      TeamParameters teamParameters) async {
    var result = await DataService.post(
        'HR/EmployeeLeaves/GetEmployeesLeaveBalance', teamParameters);
    return result
        .map<LeaveBalance>((json) => LeaveBalance.fromJson(json))
        .toList();
  }

  static Future<dynamic> getLeaveFormResult() async {
    return await DataService.get('HR/EmployeeLeaves/GetFormResult');
  }

  static Future<List<LeaveType>> getLeaveTypesByEmployee(int employeeId) async {
    var result = await DataService.get(
        'HR/EmployeeLeaves/GetLeaveTypesByEmployee/${employeeId}');
    return result.map<LeaveType>((json) => LeaveType.fromJson(json)).toList();
  }

  static Future getAttendance(AttendanceParameters attendanceParameters) async {
    var result = await DataService.post(
        'HR/EmployeeAttendances/AttendanceDailyReport/', attendanceParameters);

    return result;
  }

  static Future getSalaries(SalaryParameters salaryParameters) async {
    return await DataService.post(
        'HR/EmployeeSalaries/GetEmployeeSalaries/', salaryParameters);
  }

  static Future getEmployeeSalaryDetails(int id) async {
    return await DataService.get(
        'HR/EmployeeSalaries/GetEmployeeSalaryDetails/${id}');
  }

  static Future getTeamSalaries(int month, int year, int employeeId) async {
    return await DataService.get(
        'HR/EmployeeSalaries/GetTeamSalaries/$month/$year/$employeeId');
  }

  static Future getHolidaies(HolidayParameters holidayParameters) async {
    return await DataService.post('HR/Holidays/GetHolidays', holidayParameters);
  }

  static Future getPunishments(
      PunishmentParameters punishmentParameters) async {
    return await DataService.post(
        'HR/EmployeePunishments/GetEmployeePunishments', punishmentParameters);
  }

  static Future getPunishmentFormResult() async {
    return await DataService.get('HR/EmployeePunishments/GetFormResult/');
  }

  static Future getCompanyPolicies(
      CompanyPolicyParameters companyPolicyParameters) async {
    return await DataService.post(
        'HR/CompanyPolicies/GetCompanyPolicies', companyPolicyParameters);
  }

  static Future getCompanyPolicy(int id) async {
    return await DataService.get('HR/CompanyPolicies/${id}');
  }

  static Future getAnnouncements(
      AnnouncementParameters announcementParameters) async {
    return await DataService.post(
        'HR/Announcements/GetAnnouncements', announcementParameters);
  }

  static Future getAnnouncement(int id) async {
    return await DataService.get('HR/Announcements/${id}');
  }

  static Future<dynamic> getAttendanceFormResult() async {
    return await DataService.get('HR/EmployeeAttendances/GetIndexResult');
  }
}
