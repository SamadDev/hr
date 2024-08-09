class LeaveDetail {
  int id;
  int employeeId;
  String employeeName;
  String employeeImage;
  String primaryemail;
  int leaveTypeId;
  String leaveType;
  String leaveTypeColor;
  int leaveTimeTypeId;
  String leaveTimeType;
  String requestDate;
  double duration;
  String startDate;
  String endDate;
  int delegateeEmployeeId;
  String delegateeEmployee;
  String delegateeEmail;
  String reason;
  String leaveStatus;
  String leaveStatusClass;
  bool isTrashed;

  LeaveDetail({
    this.id,
    this.employeeId,
    this.employeeName,
    this.employeeImage,
    this.primaryemail,
    this.leaveTypeId,
    this.leaveType,
    this.leaveTypeColor,
    this.leaveTimeTypeId,
    this.leaveTimeType,
    this.requestDate,
    this.duration,
    this.startDate,
    this.endDate,
    this.delegateeEmployeeId,
    this.delegateeEmployee,
    this.delegateeEmail,
    this.reason,
    this.leaveStatus,
    this.leaveStatusClass,
    this.isTrashed,
  });

  LeaveDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    employeeImage = json['employeeImage'];
    primaryemail = json['primaryemail'];
    leaveTypeId = json['leaveTypeId'];
    leaveType = json['leaveType'];
    leaveTypeColor = json['leaveTypeColor'];
    leaveTimeTypeId = json['leaveTimeTypeId'];
    leaveTimeType = json['leaveTimeType'];
    requestDate = json['requestDate'];
    duration = json['duration'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    delegateeEmployeeId = json['delegateeEmployeeId'];
    delegateeEmployee = json['delegateeEmployee'];
    delegateeEmail = json['delegateeEmail'];
    reason = json['reason'];
    leaveStatus = json['leaveStatus'];
    leaveStatusClass = json['leaveStatusClass'];
    isTrashed = json['isTrashed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employeeId'] = this.employeeId;
    data['employeeName'] = this.employeeName;
    data['employeeImage'] = this.employeeImage;
    data['primaryemail'] = this.primaryemail;
    data['leaveTypeId'] = this.leaveTypeId;
    data['leaveType'] = this.leaveType;
    data['leaveTypeColor'] = this.leaveTypeColor;
    data['leaveTimeTypeId'] = this.leaveTimeTypeId;
    data['leaveTimeType'] = this.leaveTimeType;
    data['requestDate'] = this.requestDate;
    data['duration'] = this.duration;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['delegateeEmployeeId'] = this.delegateeEmployeeId;
    data['delegateeEmployee'] = this.delegateeEmployee;
    data['delegateeEmail'] = this.delegateeEmail;
    data['reason'] = this.reason;
    data['leaveStatus'] = this.leaveStatus;
    data['leaveStatusClass'] = this.leaveStatusClass;
    data['isTrashed'] = this.isTrashed;
    return data;
  }
}
