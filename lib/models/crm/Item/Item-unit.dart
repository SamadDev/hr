class ItemUnit {
  int id;
  String name;
  int sort;
  String description;

  ItemUnit({this.id, this.name, this.sort, this.description});

  ItemUnit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sort = json['sort'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sort'] = this.sort;
    data['description'] = this.description;
    return data;
  }

  static List<ItemUnit> toList(parsed) {
    return parsed.map<ItemUnit>((json) => ItemUnit.fromJson(json)).toList();
  }
}
