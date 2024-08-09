class CustomerNoteCategory {
  int id;
  String name;
  int sort;
  bool isDefault;

  CustomerNoteCategory({
    this.id,
    this.name,
    this.sort,
    this.isDefault,
  });

  CustomerNoteCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sort = json['sort'];
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sort'] = this.sort;
    data['isDefault'] = this.isDefault;
    return data;
  }

  static List<CustomerNoteCategory> toList(parsed) {
    return parsed
        .map<CustomerNoteCategory>((json) => CustomerNoteCategory.fromJson(json))
        .toList();
  }
}
