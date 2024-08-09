class CustomerGroup {
  int id;
  String name;
  int sort;
  bool isDefault;
  String description;

  CustomerGroup(
      {this.id, this.name, this.sort, this.isDefault, this.description});

  CustomerGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sort = json['sort'];
    isDefault = json['isDefault'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sort'] = this.sort;
    data['isDefault'] = this.isDefault;
    data['description'] = this.description;
    return data;
  }

  static List<CustomerGroup> toList(parsed) {
    return parsed
        .map<CustomerGroup>((json) => CustomerGroup.fromJson(json))
        .toList();
  }
}
