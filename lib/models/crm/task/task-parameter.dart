import 'package:nandrlon/models/crm/contact/contact-result.dart';
import 'package:nandrlon/models/crm/task/tasks-priority.dart';
import 'package:nandrlon/models/crm/task/tasks-status.dart';

class TaskParameters {
  String searchText;
  String fromDate;
  String toDate;
  int employeeId;
  int customerId;
  ContactResult customerContact;
  int customerContactId;
  TaskStatus taskStatus;
  int taskStatusId;
  TaskPriority taskPriority;
  int taskPriorityId;
  String sortColumn;
  String sortDirection;
  String pageNumber;
  String pageSize;

  String toString() {
    return '?SearchText=${this.searchText ?? ""}'
        '&fromDate=${this.fromDate ?? ""}'
        '&toDate=${this.toDate ?? ""}'
        '&employeeId=${this.employeeId ?? 0}'
        '&customerId=${this.customerId ?? 0}'
        '&customerContactId=${this.customerContactId ?? 0}'
        '&taskStatusId=${this.taskStatusId ?? 0}'
        '&taskPriorityId=${this.taskPriorityId ?? 0}'
        '&sortColumn=${this.sortColumn ?? "Id"}'
        '&sortDirection=${this.sortDirection ?? "Desc"}'
        '&pageNumber=${this.pageNumber ?? "1"}'
        '&pageSize=${this.pageSize ?? "25"}';
  }
}
