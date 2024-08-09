class SalesOrderStatus {
  int id;
  String name;
  int sort;

  SalesOrderStatus({this.id, this.name, this.sort});

  SalesOrderStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sort'] = this.sort;
    return data;
  }

  static List<SalesOrderStatus> toList(parsed) {
    return parsed.map<SalesOrderStatus>((json) => SalesOrderStatus.fromJson(json)).toList();
  }
}
