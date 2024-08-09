class CustomerStatus {
  int id;
  String name;
  bool isActive;
  int sort;
  bool isDefault;
  String color;
  String description;

  CustomerStatus({
    this.id,
    this.name,
    this.isActive,
    this.sort,
    this.isDefault,
    this.color,
    this.description,
  });

  CustomerStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    sort = json['sort'];
    isDefault = json['isDefault'];
    color = json['color'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['sort'] = this.sort;
    data['isDefault'] = this.isDefault;
    data['color'] = this.color;
    data['description'] = this.description;
    return data;
  }

  static List<CustomerStatus> toList(parsed) {
    return parsed
        .map<CustomerStatus>((json) => CustomerStatus.fromJson(json))
        .toList();
  }
}
