class User {
  int id;
  String fullName;
  String image;
  String branch;
  String department;
  String jobTitle;
  String jobPosition;
  String hireDate;

  User({
    this.id,
    this.fullName,
    this.image,
    this.branch,
    this.department,
    this.jobTitle,
    this.jobPosition,
    this.hireDate,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    image = json['image'];
    branch = json['branch'];
    department = json['department'];
    jobTitle = json['jobTitle'];
    jobPosition = json['jobPosition'];
    hireDate = json['hireDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['image'] = this.image;
    data['branch'] = this.branch;
    data['department'] = this.department;
    data['jobTitle'] = this.jobTitle;
    data['jobPosition'] = this.jobPosition;
    data['hireDate'] = this.hireDate;
    return data;
  }
}
