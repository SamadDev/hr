class Result {
  dynamic data;
  String message;
  bool success;
  bool failure;

  Result({this.data, this.success, this.failure});

  Result.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    message = json['message'];
    success = json['success'];
    failure = json['failure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['message'] = this.message;
    data['success'] = this.success;
    data['failure'] = this.failure;
    return data;
  }
}
