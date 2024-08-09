class QuestionType {
  int id;
  String name;

  QuestionType({this.id, this.name});

  QuestionType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

  static List<QuestionType> toList(parsed) {
    return parsed
        .map<QuestionType>((json) => QuestionType.fromJson(json))
        .toList();
  }
}
