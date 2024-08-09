class TaskPriority {
  int id;
  String name;
  bool isDefault;

  TaskPriority({
    this.id,
    this.name,
    this.isDefault,
  });

  TaskPriority.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isDefault'] = this.isDefault;
    return data;
  }

  static List<TaskPriority> toList(parsed) {
    return parsed
        .map<TaskPriority>((json) => TaskPriority.fromJson(json))
        .toList();
  }
}
