
class Stage {
  int id;
  String name;

  Stage({this.id, this.name});

  Stage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

  static List<Stage> toList(parsed) {
    return parsed
        .map<Stage>((json) => Stage.fromJson(json))
        .toList();
  }
}
