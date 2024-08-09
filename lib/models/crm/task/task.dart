import 'package:nandrlon/models/crm/contact/contact.dart';
import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/task/tasks-priority.dart';
import 'package:nandrlon/models/crm/task/tasks-status.dart';

class Task {
  String createdBy;
  String createdDate;
  String modifiedBy;
  String modifiedDate;
  bool isTrashed;
  String trashedBy;
  String trashedDate;
  int id;
  String subject;
  String date;
  int employeeId;
  Customer customer;
  Contact contact;
  int customerId;
  int customerContactId;
  TaskStatus taskStatus;
  int taskStatusId;
  TaskPriority taskPriority;
  int taskPriorityId;
  String description;

  Task(
      {this.createdBy,
      this.createdDate,
      this.modifiedBy,
      this.modifiedDate,
      this.isTrashed,
      this.trashedBy,
      this.trashedDate,
      this.id,
      this.subject,
      this.date,
      this.employeeId,
      this.customer,
      this.contact,
      this.customerId,
      this.customerContactId,
      this.taskStatusId,
      this.taskPriorityId,
      this.description});

  Task.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    modifiedBy = json['modifiedBy'];
    modifiedDate = json['modifiedDate'];
    isTrashed = json['isTrashed'];
    trashedBy = json['trashedBy'];
    trashedDate = json['trashedDate'];
    id = json['id'];
    subject = json['subject'];
    date = json['date'];
    employeeId = json['employeeId'];
    customerId = json['customerId'];
    customerContactId = json['customerContactId'];
    taskStatusId = json['taskStatusId'];
    taskPriorityId = json['taskPriorityId'];
    description = json['description'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    contact =
        json['contact'] != null ? new Contact.fromJson(json['contact']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedDate'] = this.modifiedDate;
    data['trashedBy'] = this.trashedBy;
    data['trashedDate'] = this.trashedDate;
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['date'] = this.date;
    data['employeeId'] = this.employeeId;
    data['customerId'] = this.customerId;
    data['customerContactId'] = this.customerContactId;
    data['taskStatusId'] = this.taskStatusId;
    data['taskPriorityId'] = this.taskPriorityId;
    data['description'] = this.description;

    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    if (this.contact != null) {
      data['contact'] = this.contact.toJson();
    }

    return data;
  }
}
