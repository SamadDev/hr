class DealResult {
  int id;
  int dealTypeId;
  String dealType;
  String name;
  String date;
  String closingDate;
  int customerId;
  String customer;
  int customerContactId;
  String currency;
  String contactName;
  int stageId;
  String stage;
  double amount;
  String description;
  String createdBy;
  String createdDate;
  String modifiedBy;
  String modifiedDate;
  int entityMode;

  DealResult(
      {this.id,
      this.dealTypeId,
      this.dealType,
      this.name,
      this.date,
      this.closingDate,
      this.customerId,
      this.customer,
      this.customerContactId,
      this.currency,
      this.contactName,
      this.stageId,
      this.stage,
      this.amount,
      this.description,
      this.createdBy,
      this.createdDate,
      this.modifiedBy,
      this.modifiedDate,
      this.entityMode});

  DealResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dealTypeId = json['dealTypeId'];
    dealType = json['dealType'];
    name = json['name'];
    date = json['date'];
    closingDate = json['closingDate'];
    customerId = json['customerId'];
    customer = json['customer'];
    customerContactId = json['customerContactId'];
    currency = json['currency'];
    contactName = json['contactName'];
    stageId = json['stageId'];
    stage = json['stage'];
    amount = json['amount'];
    description = json['description'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    modifiedBy = json['modifiedBy'];
    modifiedDate = json['modifiedDate'];
    entityMode = json['entityMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dealTypeId'] = this.dealTypeId;
    data['dealType'] = this.dealType;
    data['name'] = this.name;
    data['date'] = this.date;
    data['closingDate'] = this.closingDate;
    data['customerId'] = this.customerId;
    data['customer'] = this.customer;
    data['customerContactId'] = this.customerContactId;
    data['currency'] = this.currency;
    data['contactName'] = this.contactName;
    data['stageId'] = this.stageId;
    data['stage'] = this.stage;
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedDate'] = this.modifiedDate;
    data['entityMode'] = this.entityMode;
    return data;
  }

  static List<DealResult> toList(parsed) {
    return parsed.map<DealResult>((json) => DealResult.fromJson(json)).toList();
  }
}
