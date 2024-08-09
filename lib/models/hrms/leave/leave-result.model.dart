class LeaveResult {
  int id;
  int employeeId;
  String employeeName;
  String branch;
  String employeeImage;
  int leaveTimeTypeId;
  String leaveTimeType;
  String leaveType;
  String leaveTypeColor;
  String requestDate;
  String startDate;
  String endDate;
  String durationDays;
  double duration;
  String reason;
  String leaveStatus;
  String leaveStatusClass;
  int totalCount;
  bool checked;

  LeaveResult({
    this.id,
    this.employeeId,
    this.branch,
    this.employeeName,
    this.employeeImage,
    this.leaveTimeTypeId,
    this.leaveTimeType,
    this.leaveType,
    this.leaveTypeColor,
    this.requestDate,
    this.startDate,
    this.endDate,
    this.durationDays,
    this.duration,
    this.reason,
    this.leaveStatus,
    this.leaveStatusClass,
    this.totalCount,
    this.checked,
  });

  LeaveResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    branch = json['branch'];
    employeeName = json['employeeName'];
    employeeImage = json['employeeImage'];
    leaveTimeTypeId = json['leaveTimeTypeId'];
    leaveTimeType = json['leaveTimeType'];
    leaveType = json['leaveType'];
    leaveTypeColor = json['leaveTypeColor'];
    requestDate = json['requestDate'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    durationDays = json['durationDays'];
    duration = json['duration'];
    reason = json['reason'];
    leaveStatus = json['leaveStatus'];
    leaveStatusClass = json['leaveStatusClass'];
    totalCount = json['totalCount'];
    checked = json['checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employeeId'] = this.employeeId;
    data['branch'] = this.branch;
    data['employeeName'] = this.employeeName;
    data['employeeImage'] = this.employeeImage;
    data['leaveTimeTypeId'] = this.leaveTimeTypeId;
    data['leaveTimeType'] = this.leaveTimeType;
    data['leaveType'] = this.leaveType;
    data['leaveTypeColor'] = this.leaveTypeColor;
    data['requestDate'] = this.requestDate;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['durationDays'] = this.durationDays;
    data['duration'] = this.duration;
    data['reason'] = this.reason;
    data['leaveStatus'] = this.leaveStatus;
    data['leaveStatusClass'] = this.leaveStatusClass;
    data['totalCount'] = this.totalCount;
    data['checked'] = this.checked;
    return data;
  }
}
