class HRMSResult {
  int state;
  String msg;
  dynamic data;

  HRMSResult({this.state, this.msg, this.data});

  HRMSResult.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    msg = json['msg'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['msg'] = this.msg;
    data['data'] = this.data;
    return data;
  }
}
