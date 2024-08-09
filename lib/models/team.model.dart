class Team {
  int id;
  String employeeName;
  String employeeImage;
  String jobTitle;
  bool visible;

  Team({
    this.id,
    this.employeeName,
    this.employeeImage,
    this.jobTitle,
    this.visible,
  });

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeName = json['employeeName'];
    employeeImage = json['employeeImage'];
    jobTitle = json['jobTitle'];
    visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employeeName'] = this.employeeName;
    data['employeeImage'] = this.employeeImage;
    data['jobTitle'] = this.jobTitle;
    data['visible'] = this.visible;
    return data;
  }

  static List<Team> toList(parsed) {
    return parsed.map<Team>((json) => Team.fromJson(json)).toList();
  }
}
