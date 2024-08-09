class LeaveType {
  int id;
  String code;
  String name;
  int leaveTimeTypeId;
  String accrualGroup;
  double balance;
  double openingBalance;
  double maximumBalance;
  bool weekendCount;
  bool holidaysCount;
  bool exceedBalance;
  double minimumGap;
  double minimumLeave;
  double maximumLeave;
  double carryForward;
  bool isPaid;
  bool isPublished;
  int sort;
  String color;
  String leaveTypeColor;
  String leaveType;
  int employmentStatusId;
  String description;

  LeaveType({
    this.id,
    this.code,
    this.name,
    this.leaveTimeTypeId,
    this.accrualGroup,
    this.balance,
    this.openingBalance,
    this.maximumBalance,
    this.weekendCount,
    this.holidaysCount,
    this.exceedBalance,
    this.minimumGap,
    this.minimumLeave,
    this.maximumLeave,
    this.carryForward,
    this.isPaid,
    this.isPublished,
    this.sort,
    this.color,
    this.leaveTypeColor,
    this.leaveType,
    this.employmentStatusId,
    this.description,
  });

  LeaveType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    leaveTimeTypeId = json['leaveTimeTypeId'];
    accrualGroup = json['accrualGroup'];
    balance = json['balance'];
    openingBalance = json['openingBalance'];
    maximumBalance = json['maximumBalance'];
    weekendCount = json['weekendCount'];
    holidaysCount = json['holidaysCount'];
    exceedBalance = json['exceedBalance'];
    minimumGap = json['minimumGap'];
    minimumLeave = json['minimumLeave'];
    maximumLeave = json['maximumLeave'];
    carryForward = json['carryForward'];
    isPaid = json['isPaid'];
    isPublished = json['isPublished'];
    sort = json['sort'];
    color = json['color'];
    leaveTypeColor = json['leaveTypeColor'];
    leaveType = json['leaveType'];
    employmentStatusId = json['employmentStatusId'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['leaveTimeTypeId'] = this.leaveTimeTypeId;
    data['accrualGroup'] = this.accrualGroup;
    data['balance'] = this.balance;
    data['openingBalance'] = this.openingBalance;
    data['maximumBalance'] = this.maximumBalance;
    data['weekendCount'] = this.weekendCount;
    data['holidaysCount'] = this.holidaysCount;
    data['exceedBalance'] = this.exceedBalance;
    data['minimumGap'] = this.minimumGap;
    data['minimumLeave'] = this.minimumLeave;
    data['maximumLeave'] = this.maximumLeave;
    data['carryForward'] = this.carryForward;
    data['isPaid'] = this.isPaid;
    data['isPublished'] = this.isPublished;
    data['sort'] = this.sort;
    data['color'] = this.color;
    data['leaveTypeColor'] = this.leaveTypeColor;
    data['leaveType'] = this.leaveType;
    data['employmentStatusId'] = this.employmentStatusId;
    data['description'] = this.description;

    return data;
  }
}
