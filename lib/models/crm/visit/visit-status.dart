class VisitStatus {
  int id;
  String name;

  VisitStatus({this.id, this.name});

  VisitStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

  static List<VisitStatus> toList(parsed) {
    return parsed
        .map<VisitStatus>((json) => VisitStatus.fromJson(json))
        .toList();
  }
}
