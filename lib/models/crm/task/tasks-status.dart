class TaskStatus {
  int id;
  String name;
  bool isDefault;

  TaskStatus({
    this.id,
    this.name,
    this.isDefault,
  });

  TaskStatus.fromJson(Map<String, dynamic> json) {
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

  static List<TaskStatus> toList(parsed) {
    return parsed.map<TaskStatus>((json) => TaskStatus.fromJson(json)).toList();
  }
}
