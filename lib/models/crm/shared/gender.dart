class Gender {
  int id;
  String name;
  String abbrName;
  int sort;

  Gender({this.id, this.name, this.abbrName, this.sort});

  Gender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    abbrName = json['abbrName'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['abbrName'] = this.abbrName;
    data['sort'] = this.sort;
    return data;
  }

  static List<Gender> toList(parsed) {
    return parsed.map<Gender>((json) => Gender.fromJson(json)).toList();
  }
}
