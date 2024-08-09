class VisitResult {
  int id;
  String name;

  VisitResult({this.id, this.name});

  VisitResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

  static List<VisitResult> toList(parsed) {
    return parsed
        .map<VisitResult>((json) => VisitResult.fromJson(json))
        .toList();
  }
}
