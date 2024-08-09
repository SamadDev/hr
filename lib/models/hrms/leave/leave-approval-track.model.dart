class LeaveApprovalTrack {
  int approvalStatusId;
  int employeeId;
  String description;

  LeaveApprovalTrack(
      {this.approvalStatusId, this.employeeId, this.description});

  LeaveApprovalTrack.fromJson(Map<String, dynamic> json) {
    approvalStatusId = json['approvalStatusId'];
    employeeId = json['employeeId'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['approvalStatusId'] = this.approvalStatusId;
    data['employeeId'] = this.employeeId;
    data['description'] = this.description;
    return data;
  }
}
