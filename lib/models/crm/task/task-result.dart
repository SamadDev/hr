class TaskResult {
  int id;
  String subject;
  String date;
  int employeeId;
  int customerId;
  int customerContactId;
  int taskStatusId;
  String status;
  String statusColor;
  int taskPriorityId;
  String priority;
  String description;
  bool isTrashed;
  String trashedBy;
  String trashedDate;
  String createdBy;
  String createdDate;
  String modifiedBy;
  String modifiedDate;
  int entityMode;

  TaskResult(
      {this.id,
        this.subject,
        this.date,
        this.employeeId,
        this.customerId,
        this.customerContactId,
        this.taskStatusId,
        this.status,
        this.statusColor,
        this.taskPriorityId,
        this.priority,
        this.description,
        this.isTrashed,
        this.trashedBy,
        this.trashedDate,
        this.createdBy,
        this.createdDate,
        this.modifiedBy,
        this.modifiedDate,
        this.entityMode,});

  TaskResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    date = json['date'];
    employeeId = json['employeeId'];
    customerId = json['customerId'];
    customerContactId = json['customerContactId'];
    taskStatusId = json['taskStatusId'];
    status = json['status'];
    statusColor = json['statusColor'];
    taskPriorityId = json['taskPriorityId'];
    priority = json['priority'];
    description = json['description'];
    isTrashed = json['isTrashed'];
    trashedBy = json['trashedBy'];
    trashedDate = json['trashedDate'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    modifiedBy = json['modifiedBy'];
    modifiedDate = json['modifiedDate'];
    entityMode = json['entityMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['date'] = this.date;
    data['employeeId'] = this.employeeId;
    data['customerId'] = this.customerId;
    data['customerContactId'] = this.customerContactId;
    data['taskStatusId'] = this.taskStatusId;
    data['status'] = this.status;
    data['statusColor'] = this.statusColor;
    data['taskPriorityId'] = this.taskPriorityId;
    data['priority'] = this.priority;
    data['description'] = this.description;
    data['isTrashed'] = this.isTrashed;
    data['trashedBy'] = this.trashedBy;
    data['trashedDate'] = this.trashedDate;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedDate'] = this.modifiedDate;
    data['entityMode'] = this.entityMode;
    return data;
  }

  static List<TaskResult> toList(parsed) {
    return parsed.map<TaskResult>((json) => TaskResult.fromJson(json)).toList();
  }
}
