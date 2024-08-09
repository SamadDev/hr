class EmployeeAttendance {
  String id;
  String date;
  int employeeId;
  String employeeName;
  String image;
  String branch;
  String department;
  String jobTitle;
  String jobPosition;
  String firstIn;
  String lastOut;
  String workingHours;
  String status;
  String statusColor;
  String statusIcon;

  EmployeeAttendance(
      {this.id,
      this.date,
      this.employeeId,
      this.employeeName,
      this.image,
      this.branch,
      this.department,
      this.jobTitle,
      this.jobPosition,
      this.firstIn,
      this.lastOut,
      this.workingHours,
      this.status,
      this.statusColor,
      this.statusIcon});

  EmployeeAttendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    image = json['image'];
    branch = json['branch'];
    department = json['department'];
    jobTitle = json['jobTitle'];
    jobPosition = json['jobPosition'];
    firstIn = json['firstIn'];
    lastOut = json['lastOut'];
    workingHours = json['workingHours'];
    status = json['status'];
    statusColor = json['statusColor'];
    statusIcon = json['statusIcon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['employeeId'] = this.employeeId;
    data['employeeName'] = this.employeeName;
    data['image'] = this.image;
    data['branch'] = this.branch;
    data['department'] = this.department;
    data['jobTitle'] = this.jobTitle;
    data['jobPosition'] = this.jobPosition;
    data['firstIn'] = this.firstIn;
    data['lastOut'] = this.lastOut;
    data['workingHours'] = this.workingHours;
    data['status'] = this.status;
    data['statusColor'] = this.statusColor;
    data['statusIcon'] = this.statusIcon;
    return data;
  }
}
