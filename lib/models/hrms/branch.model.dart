class Branch {
  int id;
  String name;
  double target;
  double sale;

  Branch({this.id, this.name, this.target, this.sale});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    target = json['target'];
    sale = json['sale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['target'] = this.target;
    data['sale'] = this.sale;
    return data;
  }
}
