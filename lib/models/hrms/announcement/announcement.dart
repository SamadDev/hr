class Announcement {
  int id;
  String subject;
  String summary;
  bool isPublish;
  String publishDate;
  String expiryDate;
  String createdBy;
  String createdDate;
  String modifiedBy;
  String modifiedDate;
  int totalCount;
  bool checked;

  Announcement(
      {this.id,
        this.subject,
        this.summary,
        this.isPublish,
        this.publishDate,
        this.expiryDate,
        this.createdBy,
        this.createdDate,
        this.modifiedBy,
        this.modifiedDate,
        this.totalCount,
        this.checked});

  Announcement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    summary = json['summary'];
    isPublish = json['isPublish'];
    publishDate = json['publishDate'];
    expiryDate = json['expiryDate'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    modifiedBy = json['modifiedBy'];
    modifiedDate = json['modifiedDate'];
    totalCount = json['totalCount'];
    checked = json['checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['summary'] = this.summary;
    data['isPublish'] = this.isPublish;
    data['publishDate'] = this.publishDate;
    data['expiryDate'] = this.expiryDate;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedDate'] = this.modifiedDate;
    data['totalCount'] = this.totalCount;
    data['checked'] = this.checked;
    return data;
  }
}
