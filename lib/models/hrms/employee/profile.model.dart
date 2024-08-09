class Profile {
  int id;
  String code;
  String employeeImage;
  String employeeName;
  String employeeNameKu;
  String dateOfBirth;
  String placeOfBirth;
  String phoneNo;
  String email;
  String bloodGroup;
  String gender;
  String maritalStatus;
  String hireDate;
  String previousOrganizationName;
  String previousEmploymentStatus;
  String statusColor;
  String startDate;
  String endDate;
  String country;
  String city;
  String address;
  String nationality;
  String religion;
  String shift;
  String fingerId;
  String emergencyContactRelativeName;
  String emergencyContactName;
  String emergencyContactPhone1;
  String emergencyContactPhone2;
  String emergencyContactEmail;
  String emergencyContactAddress1;
  String emergencyContactAddress2;
  String employmentStatus;
  String branch;
  String department;
  String jobTitle;
  String jobPosition;
  String employmentType;
  String jobEmploymentStatus;
  String jobEmploymentStatusColor;
  String grade;
  String step;
  double salary;
  double totalEarnings;
  double totalDeductions;
  double netSalary;
  String reportingTo;
  String jobStartDate;
  String jobEndDate;
  String educationName;
  String educationDegree;
  String speciality;
  String educationGrade;
  int educationFromYear;
  int educationToYear;
  String educationCountry;
  String educationCity;
  int totalCount;

  Profile(
      {this.id,
      this.code,
      this.employeeImage,
      this.employeeName,
      this.employeeNameKu,
      this.dateOfBirth,
      this.placeOfBirth,
      this.phoneNo,
      this.email,
      this.bloodGroup,
      this.gender,
      this.maritalStatus,
      this.hireDate,
      this.previousOrganizationName,
      this.previousEmploymentStatus,
      this.statusColor,
      this.startDate,
      this.endDate,
      this.country,
      this.city,
      this.address,
      this.nationality,
      this.religion,
      this.shift,
      this.fingerId,
      this.emergencyContactRelativeName,
      this.emergencyContactName,
      this.emergencyContactPhone1,
      this.emergencyContactPhone2,
      this.emergencyContactEmail,
      this.emergencyContactAddress1,
      this.emergencyContactAddress2,
      this.employmentStatus,
      this.branch,
      this.department,
      this.jobTitle,
      this.jobPosition,
      this.employmentType,
      this.jobEmploymentStatus,
      this.jobEmploymentStatusColor,
      this.grade,
      this.step,
      this.salary,
      this.totalEarnings,
      this.totalDeductions,
      this.netSalary,
      this.reportingTo,
      this.jobStartDate,
      this.jobEndDate,
      this.educationName,
      this.educationDegree,
      this.speciality,
      this.educationGrade,
      this.educationFromYear,
      this.educationToYear,
      this.educationCountry,
      this.educationCity,
      this.totalCount});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    employeeImage = json['employeeImage'];
    employeeName = json['employeeName'];
    employeeNameKu = json['employeeNameKu'];
    dateOfBirth = json['dateOfBirth'];
    placeOfBirth = json['placeOfBirth'];
    phoneNo = json['phoneNo'];
    email = json['email'];
    bloodGroup = json['bloodGroup'];
    gender = json['gender'];
    maritalStatus = json['maritalStatus'];
    hireDate = json['hireDate'];
    previousOrganizationName = json['previousOrganizationName'];
    previousEmploymentStatus = json['previousEmploymentStatus'];
    statusColor = json['statusColor'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    country = json['country'];
    city = json['city'];
    address = json['address'];
    nationality = json['nationality'];
    religion = json['religion'];
    shift = json['shift'];
    fingerId = json['fingerId'];
    emergencyContactRelativeName = json['emergencyContactRelativeName'];
    emergencyContactName = json['emergencyContactName'];
    emergencyContactPhone1 = json['emergencyContactPhone1'];
    emergencyContactPhone2 = json['emergencyContactPhone2'];
    emergencyContactEmail = json['emergencyContactEmail'];
    emergencyContactAddress1 = json['emergencyContactAddress1'];
    emergencyContactAddress2 = json['emergencyContactAddress2'];
    employmentStatus = json['employmentStatus'];
    branch = json['branch'];
    department = json['department'];
    jobTitle = json['jobTitle'];
    jobPosition = json['jobPosition'];
    employmentType = json['employmentType'];
    jobEmploymentStatus = json['jobEmploymentStatus'];
    jobEmploymentStatusColor = json['jobEmploymentStatusColor'];
    grade = json['grade'];
    step = json['step'];
    salary = json['salary'];
    totalEarnings = json['totalEarnings'];
    totalDeductions = json['totalDeductions'];
    netSalary = json['netSalary'];
    reportingTo = json['reportingTo'];
    jobStartDate = json['jobStartDate'];
    jobEndDate = json['jobEndDate'];
    educationName = json['educationName'];
    educationDegree = json['educationDegree'];
    speciality = json['speciality'];
    educationGrade = json['educationGrade'];
    educationFromYear = json['educationFromYear'];
    educationToYear = json['educationToYear'];
    educationCountry = json['educationCountry'];
    educationCity = json['educationCity'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['employeeImage'] = this.employeeImage;
    data['employeeName'] = this.employeeName;
    data['employeeNameKu'] = this.employeeNameKu;
    data['dateOfBirth'] = this.dateOfBirth;
    data['placeOfBirth'] = this.placeOfBirth;
    data['phoneNo'] = this.phoneNo;
    data['email'] = this.email;
    data['bloodGroup'] = this.bloodGroup;
    data['gender'] = this.gender;
    data['maritalStatus'] = this.maritalStatus;
    data['hireDate'] = this.hireDate;
    data['previousOrganizationName'] = this.previousOrganizationName;
    data['previousEmploymentStatus'] = this.previousEmploymentStatus;
    data['statusColor'] = this.statusColor;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['country'] = this.country;
    data['city'] = this.city;
    data['address'] = this.address;
    data['nationality'] = this.nationality;
    data['religion'] = this.religion;
    data['shift'] = this.shift;
    data['fingerId'] = this.fingerId;
    data['emergencyContactRelativeName'] = this.emergencyContactRelativeName;
    data['emergencyContactName'] = this.emergencyContactName;
    data['emergencyContactPhone1'] = this.emergencyContactPhone1;
    data['emergencyContactPhone2'] = this.emergencyContactPhone2;
    data['emergencyContactEmail'] = this.emergencyContactEmail;
    data['emergencyContactAddress1'] = this.emergencyContactAddress1;
    data['emergencyContactAddress2'] = this.emergencyContactAddress2;
    data['employmentStatus'] = this.employmentStatus;
    data['branch'] = this.branch;
    data['department'] = this.department;
    data['jobTitle'] = this.jobTitle;
    data['jobPosition'] = this.jobPosition;
    data['employmentType'] = this.employmentType;
    data['jobEmploymentStatus'] = this.jobEmploymentStatus;
    data['jobEmploymentStatusColor'] = this.jobEmploymentStatusColor;
    data['grade'] = this.grade;
    data['step'] = this.step;
    data['salary'] = this.salary;
    data['totalEarnings'] = this.totalEarnings;
    data['totalDeductions'] = this.totalDeductions;
    data['netSalary'] = this.netSalary;
    data['reportingTo'] = this.reportingTo;
    data['jobStartDate'] = this.jobStartDate;
    data['jobEndDate'] = this.jobEndDate;
    data['educationName'] = this.educationName;
    data['educationDegree'] = this.educationDegree;
    data['speciality'] = this.speciality;
    data['educationGrade'] = this.educationGrade;
    data['educationFromYear'] = this.educationFromYear;
    data['educationToYear'] = this.educationToYear;
    data['educationCountry'] = this.educationCountry;
    data['educationCity'] = this.educationCity;
    data['totalCount'] = this.totalCount;
    return data;
  }
}
