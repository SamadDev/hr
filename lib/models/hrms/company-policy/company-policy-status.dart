class CompanyPolicyStatus {
  int id;
  String name;
  String color;

  CompanyPolicyStatus({this.id, this.name, this.color});

  CompanyPolicyStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['color'] = this.color;
    return data;
  }
}
