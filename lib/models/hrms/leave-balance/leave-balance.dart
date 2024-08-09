class LeaveBalance {
  int employeeId;
  String employeeName;
  String employeeImage;
  String branch;
  String department;
  List<LeaveBalanceDetail> result;
  bool showDetail;

  LeaveBalance({
    this.employeeId,
    this.employeeName,
    this.employeeImage,
    this.branch,
    this.department,
    this.result,
    this.showDetail,
  });

  LeaveBalance.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    employeeImage = json['employeeImage'];
    branch = json['branch'];
    department = json['department'];
    if (json['result'] != null) {
      result = <LeaveBalanceDetail>[];
      json['result'].forEach((v) {
        result.add(new LeaveBalanceDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['employeeName'] = this.employeeName;
    data['employeeImage'] = this.employeeImage;
    data['branch'] = this.branch;
    data['department'] = this.department;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaveBalanceDetail {
  int leaveTypeId;
  String leaveTypeCode;
  String leaveTypeColor;
  String leaveType;
  double balance;
  double leaveIn;
  double leaveOut;

  LeaveBalanceDetail(
      {this.leaveTypeId,
      this.leaveTypeCode,
      this.leaveTypeColor,
      this.leaveType,
      this.balance,
      this.leaveIn,
      this.leaveOut});

  LeaveBalanceDetail.fromJson(Map<String, dynamic> json) {
    leaveTypeId = json['leaveTypeId'];
    leaveTypeCode = json['leaveTypeCode'];
    leaveTypeColor = json['leaveTypeColor'];
    leaveType = json['leaveType'];
    balance = json['balance'];
    leaveIn = json['leaveIn'];
    leaveOut = json['leaveOut'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leaveTypeId'] = this.leaveTypeId;
    data['leaveTypeCode'] = this.leaveTypeCode;
    data['leaveTypeColor'] = this.leaveTypeColor;
    data['leaveType'] = this.leaveType;
    data['balance'] = this.balance;
    data['leaveIn'] = this.leaveIn;
    data['leaveOut'] = this.leaveOut;
    return data;
  }
}
