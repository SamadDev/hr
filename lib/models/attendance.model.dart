// @dart=2.9
class Attendance {
  String id;
  String date;
  String employeeName;
  String employeeImage;
  String jobPosition;
  String jobTitle;
  String department;
  String branch;
  String firstIn;
  String shiftMissIn;
  String shiftMissOut;
  String lastOut;
  String missIn;
  String missOut;
  String workingHours;
  String totalWorkingHours;
  String task;
  String overtime;
  String leave;
  String totalHours;
  String status;
  String statusColor;

  Attendance({
    this.id,
    this.date,
    this.employeeName,
    this.employeeImage,
    this.jobPosition,
    this.department,
    this.branch,
    this.jobTitle,
    this.firstIn,
    this.shiftMissIn,
    this.shiftMissOut,
    this.lastOut,
    this.missIn,
    this.missOut,
    this.workingHours,
    this.totalWorkingHours,
    this.task,
    this.overtime,
    this.leave,
    this.totalHours,
    this.status,
    this.statusColor,
  });

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    employeeName = json['employeeName'];
    employeeImage = json['employeeImage'];
    jobTitle = json['jobTitle'];
    jobPosition = json['jobPosition'];
    branch = json['branch'];
    department = json['department'];
    firstIn = json['firstIn'];
    shiftMissIn = json['shiftMissIn'];
    shiftMissOut = json['shiftMissOut'];
    lastOut = json['lastOut'];
    missIn = json['missIn'];
    missOut = json['missOut'];
    workingHours = json['workingHours'];
    totalWorkingHours = json['totalWorkingHours'];
    task = json['task'];
    overtime = json['overtime'];
    leave = json['leave'];
    totalHours = json['totalHours'];
    status = json['status'];
    statusColor = json['statusColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['employeeName'] = this.employeeName;
    data['employeeImage'] = this.employeeImage;
    data['jobTitle'] = this.jobTitle;
    data['jobPosition'] = this.jobPosition;
    data['branch'] = this.branch;
    data['department'] = this.department;
    data['firstIn'] = this.firstIn;
    data['shiftMissIn'] = this.shiftMissIn;
    data['shiftMissOut'] = this.shiftMissOut;
    data['lastOut'] = this.lastOut;
    data['missIn'] = this.missIn;
    data['missOut'] = this.missOut;
    data['workingHours'] = this.workingHours;
    data['totalWorkingHours'] = this.totalWorkingHours;
    data['task'] = this.task;
    data['overtime'] = this.overtime;
    data['leave'] = this.leave;
    data['totalHours'] = this.totalHours;
    data['status'] = this.status;
    data['statusColor'] = this.statusColor;
    return data;
  }
}
