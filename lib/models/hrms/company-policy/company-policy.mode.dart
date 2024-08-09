class CompanyPolicy {
  int id;
  String title;
  String summary;
  String detail;
  String lastRevision;
  int companyPolicyStatusId;
  String status;
  String statusColor;
  int totalCount;
  bool checked;

  CompanyPolicy({
    this.id,
    this.title,
    this.summary,
    this.detail,
    this.lastRevision,
    this.companyPolicyStatusId,
    this.status,
    this.statusColor,
    this.totalCount,
    this.checked,
  });

  CompanyPolicy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    summary = json['summary'];
    detail = json['detail'];
    lastRevision = json['lastRevision'];
    companyPolicyStatusId = json['companyPolicyStatusId'];
    status = json['status'];
    statusColor = json['statusColor'];
    totalCount = json['totalCount'];
    checked = json['checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['summary'] = this.summary;
    data['detail'] = this.detail;
    data['lastRevision'] = this.lastRevision;
    data['companyPolicyStatusId'] = this.companyPolicyStatusId;
    data['status'] = this.status;
    data['statusColor'] = this.statusColor;
    data['totalCount'] = this.totalCount;
    data['checked'] = this.checked;
    return data;
  }
}
