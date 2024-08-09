class VisitPurpose {
  int id;
  String name;

  VisitPurpose({this.id, this.name});

  VisitPurpose.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

  static List<VisitPurpose> toList(parsed) {
    return parsed
        .map<VisitPurpose>((json) => VisitPurpose.fromJson(json))
        .toList();
  }
}
