class LeaveApproval {
  int id;
  String employeeName;
  String employeePhoto;
  String jobTitle;
  String date;
  String status;
  String statusClass;
  String description;

  LeaveApproval({
    this.id,
    this.employeeName,
    this.employeePhoto,
    this.jobTitle,
    this.date,
    this.status,
    this.statusClass,
    this.description,
  });

  LeaveApproval.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeName = json['employeeName'];
    employeePhoto = json['employeePhoto'];
    jobTitle = json['jobTitle'];
    date = json['date'];
    status = json['status'];
    statusClass = json['statusClass'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employeeName'] = this.employeeName;
    data['employeePhoto'] = this.employeePhoto;
    data['jobTitle'] = this.jobTitle;
    data['date'] = this.date;
    data['status'] = this.status;
    data['statusClass'] = this.statusClass;
    data['description'] = this.description;
    return data;
  }
}
