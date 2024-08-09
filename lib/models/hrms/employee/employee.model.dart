class Employee {
  int id;
  String employeeImage;
  String employeeName;
  String firstName;
  String employeeNameKu;
  String phoneNo;
  String secondaryPhoneNo;
  String email;
  String secondaryEmail;
  String branch;
  String department;
  String jobTitle;
  String jobPosition;
  int totalCount;

  Employee(
      {this.id,
      this.employeeImage,
      this.employeeName,
      this.firstName,
      this.employeeNameKu,
      this.phoneNo,
      this.secondaryPhoneNo,
      this.email,
      this.secondaryEmail,
      this.branch,
      this.department,
      this.jobTitle,
      this.jobPosition,
      this.totalCount});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeImage = json['employeeImage'];
    employeeName = json['employeeName'];
    firstName = json['firstName'];
    employeeNameKu = json['employeeNameKu'];
    phoneNo = json['phoneNo'];
    secondaryPhoneNo = json['secondaryPhoneNo'];
    email = json['email'];
    secondaryEmail = json['secondaryEmail'];
    branch = json['branch'];
    department = json['department'];
    jobTitle = json['jobTitle'];
    jobPosition = json['jobPosition'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employeeImage'] = this.employeeImage;
    data['employeeName'] = this.employeeName;
    data['firstName'] = this.firstName;
    data['employeeNameKu'] = this.employeeNameKu;
    data['phoneNo'] = this.phoneNo;
    data['secondaryPhoneNo'] = this.secondaryPhoneNo;
    data['email'] = this.email;
    data['secondaryEmail'] = this.secondaryEmail;
    data['branch'] = this.branch;
    data['department'] = this.department;
    data['jobTitle'] = this.jobTitle;
    data['jobPosition'] = this.jobPosition;
    data['totalCount'] = this.totalCount;
    return data;
  }
}
