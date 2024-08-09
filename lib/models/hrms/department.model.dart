class Department {
  int id;
  int departmentTypeId;
  String name;

  Department({this.id, this.departmentTypeId, this.name});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentTypeId = json['departmentTypeId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['departmentTypeId'] = this.departmentTypeId;
    data['name'] = this.name;
    return data;
  }
}
