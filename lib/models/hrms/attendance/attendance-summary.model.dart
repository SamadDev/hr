class AttendanceSummary {
  String status;
  String statusColor;
  String statusIcon;
  int count;
  int statusId;

  AttendanceSummary(
      {this.status,
      this.statusColor,
      this.statusIcon,
      this.count,
      this.statusId});

  AttendanceSummary.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusColor = json['statusColor'];
    statusIcon = json['statusIcon'];
    count = json['count'];
    statusId = json['statusId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['statusColor'] = this.statusColor;
    data['statusIcon'] = this.statusIcon;
    data['count'] = this.count;
    data['statusId'] = this.statusId;
    return data;
  }
}
