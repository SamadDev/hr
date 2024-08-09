class Warehouse {
  int id;
  String name;

  Warehouse({
    this.id,
    this.name,
  });

  Warehouse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

  static List<Warehouse> toList(parsed) {
    return parsed.map<Warehouse>((json) => Warehouse.fromJson(json)).toList();
  }
}
