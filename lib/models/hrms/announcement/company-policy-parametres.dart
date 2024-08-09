import 'package:nandrlon/models/hrms/company-policy/company-policy-status.dart';
import 'package:nandrlon/models/hrms/item-list.dart';
class AnnouncementParameters {
  String subject;
  bool isPublished;
  int currentPage;
  int pageNumber;
  int pageSize;
  String fromDate;
  String toDate;

  AnnouncementParameters(
      {this.subject,
        this.isPublished,
        this.currentPage,
        this.pageNumber = 1,
        this.pageSize = 25,
        this.fromDate,
        this.toDate});

  AnnouncementParameters.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    isPublished = json['isPublished'];
    currentPage = json['currentPage'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject'] = this.subject;
    data['isPublished'] = this.isPublished;
    data['currentPage'] = this.currentPage;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    return data;
  }
}
