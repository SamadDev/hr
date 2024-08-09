class CustomerNote {
  int id;
  int customerId;
  String subject;
  String note;
  String date;
  String createdDate;

  CustomerNote({
    this.id,
    this.customerId,
    this.subject,
    this.note,
    this.date,
    this.createdDate,
  });

  CustomerNote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    subject = json['subject'];
    note = json['note'];
    date = json['date'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['subject'] = this.subject;
    data['note'] = this.note;
    data['date'] = this.date;
    data['createdDate'] = this.createdDate;
    return data;
  }

  static List<CustomerNote> toList(parsed) {
    return parsed
        .map<CustomerNote>((json) => CustomerNote.fromJson(json))
        .toList();
  }
}
