class TeamParameters {
  int reportingTo;
  int reportingToId;
  int approverId;
  String fromDate;
  String toDate;

  TeamParameters({this.reportingTo});

  TeamParameters.fromJson(Map<String, dynamic> json) {
    reportingTo = json['reportingTo'];
    reportingToId = json['reportingToId'];
    approverId = json['approverId'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reportingTo'] = this.reportingTo;
    data['reportingToId'] = this.reportingToId;
    data['approverId'] = this.approverId;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    return data;
  }
}
