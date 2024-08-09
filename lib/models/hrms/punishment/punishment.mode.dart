class Punishment {
  int id;
  int employeeId;
  String employeeName;
  String punishmentType;
  String fromDate;
  String toDate;
  String reason;
  double fineAmount;
  String deductFrom;
  bool isTrashed;
  int totalCount;
  bool checked;

  Punishment({
    this.id,
    this.employeeId,
    this.employeeName,
    this.punishmentType,
    this.fromDate,
    this.toDate,
    this.reason,
    this.fineAmount,
    this.deductFrom,
    this.isTrashed,
    this.totalCount,
    this.checked,
  });

  Punishment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    punishmentType = json['punishmentType'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    reason = json['reason'];
    fineAmount = json['fineAmount'];
    deductFrom = json['deductFrom'];
    isTrashed = json['isTrashed'];
    totalCount = json['totalCount'];
    checked = json['checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employeeId'] = this.employeeId;
    data['employeeName'] = this.employeeName;
    data['punishmentType'] = this.punishmentType;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['reason'] = this.reason;
    data['fineAmount'] = this.fineAmount;
    data['deductFrom'] = this.deductFrom;
    data['isTrashed'] = this.isTrashed;
    data['totalCount'] = this.totalCount;
    data['checked'] = this.checked;
    return data;
  }
}
