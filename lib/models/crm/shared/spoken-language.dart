class SpokenLanguage {
  int id;
  String name;

  SpokenLanguage({
    this.id,
    this.name,
  });

  SpokenLanguage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name; 
    return data;
  }

  static List<SpokenLanguage> toList(parsed) {
    return parsed
        .map<SpokenLanguage>((json) => SpokenLanguage.fromJson(json))
        .toList();
  }
}
