class ItemType {
  int id;
  String name;
  int sort;
  String description;
  int entityMode;

  ItemType({this.id, this.name, this.sort, this.description, this.entityMode});

  ItemType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sort = json['sort'];
    description = json['description'];
    entityMode = json['entityMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sort'] = this.sort;
    data['description'] = this.description;
    data['entityMode'] = this.entityMode;
    return data;
  }

  static List<ItemType> toList(parsed) {
    return parsed.map<ItemType>((json) => ItemType.fromJson(json)).toList();
  }
}
