

class DeliveryNoteResult {
  String customerName;
  String customerContactName;
  String brandName;
  int totalRecords;
  int id;
  String deliveryNo;
  String deliveryDate;
  String refNo;
  String refDate;
  int customerId;
  int customerContactId;
  int customerBrandId;
  int warehouseId;
  String driverName;
  String driverPhone;
  String description;
  String customer;
  String customerContact;
  String customerBrand;
  String warehouseName;
  String details;

  DeliveryNoteResult(
      {this.customerName,
        this.customerContactName,
        this.brandName,
        this.totalRecords,
        this.id,
        this.deliveryNo,
        this.deliveryDate,
        this.refNo,
        this.refDate,
        this.customerId,
        this.customerContactId,
        this.customerBrandId,
        this.warehouseId,
        this.driverName,
        this.driverPhone,
        this.description,
        this.customer,
        this.customerContact,
        this.customerBrand,
        this.warehouseName,
        this.details});

  DeliveryNoteResult.fromJson(Map<String, dynamic> json) {
    customerName = json['customerName'];
    customerContactName = json['customerContactName'];
    brandName = json['brandName'];
    totalRecords = json['totalRecords'];
    id = json['id'];
    deliveryNo = json['deliveryNo'];
    deliveryDate = json['deliveryDate'];
    refNo = json['refNo'];
    refDate = json['refDate'];
    customerId = json['customerId'];
    customerContactId = json['customerContactId'];
    customerBrandId = json['customerBrandId'];
    warehouseId = json['warehouseId'];
    driverName = json['driverName'];
    driverPhone = json['driverPhone'];
    description = json['description'];
    customer = json['customer'];
    customerContact = json['customerContact'];
    customerBrand = json['customerBrand'];
    warehouseName = json['warehouseName'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerName'] = this.customerName;
    data['customerContactName'] = this.customerContactName;
    data['brandName'] = this.brandName;
    data['totalRecords'] = this.totalRecords;
    data['id'] = this.id;
    data['deliveryNo'] = this.deliveryNo;
    data['deliveryDate'] = this.deliveryDate;
    data['refNo'] = this.refNo;
    data['refDate'] = this.refDate;
    data['customerId'] = this.customerId;
    data['customerContactId'] = this.customerContactId;
    data['customerBrandId'] = this.customerBrandId;
    data['warehouseId'] = this.warehouseId;
    data['driverName'] = this.driverName;
    data['driverPhone'] = this.driverPhone;
    data['description'] = this.description;
    data['customer'] = this.customer;
    data['customerContact'] = this.customerContact;
    data['customerBrand'] = this.customerBrand;
    data['warehouseName'] = this.warehouseName;
    data['details'] = this.details;
    return data;
  }

  static List<DeliveryNoteResult> toList(parsed) {
    return parsed
        .map<DeliveryNoteResult>((json) => DeliveryNoteResult.fromJson(json))
        .toList();
  }
}
