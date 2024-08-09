class Notification {
  int id;
  int notificationTypeId;
  int employeeId;
  String title;
  String message;
  String icon;
  bool isSeen;
  String date;
  String refId;
  String action;

  Notification({
    this.id,
    this.notificationTypeId,
    this.employeeId,
    this.title,
    this.message,
    this.icon,
    this.isSeen,
    this.date,
    this.refId,
    this.action,
  });

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notificationTypeId = json['notificationTypeId'];
    employeeId = json['employeeId'];
    title = json['title'];
    message = json['message'];
    icon = json['icon'];
    isSeen = json['isSeen'];
    date = json['date'];
    refId = json['refId'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['notificationTypeId'] = this.notificationTypeId;
    data['employeeId'] = this.employeeId;
    data['title'] = this.title;
    data['message'] = this.message;
    data['icon'] = this.icon;
    data['isSeen'] = this.isSeen;
    data['date'] = this.date;
    data['refId'] = this.refId;
    data['action'] = this.action;
    return data;
  }
}
