class EmployeeProfile {
  int id;
  String fullName;
  String fullNameKu;
  String image;
  String branch;
  String department;
  String jobTitle;
  String jobPosition;
  String token;
  String hireDate;

  EmployeeProfile({
    this.id,
    this.fullName,
    this.fullNameKu,
    this.image,
    this.branch,
    this.department,
    this.jobTitle,
    this.jobPosition,
    this.token,
    this.hireDate,
  });

  EmployeeProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    fullNameKu = json['fullNameKu'];
    image = json['image'];
    branch = json['branch'];
    department = json['department'];
    jobTitle = json['jobTitle'];
    jobPosition = json['jobPosition'];
    token = json['token'];
    hireDate = json['hireDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['fullNameKu'] = this.fullNameKu;
    data['image'] = this.image;
    data['branch'] = this.branch;
    data['department'] = this.department;
    data['jobTitle'] = this.jobTitle;
    data['jobPosition'] = this.jobPosition;
    data['token'] = this.token;
    data['hireDate'] = this.hireDate;
    return data;
  }
}
