import 'package:nandrlon/models/crm/customer/customer.dart';

class DeliveryNoteParameters {
  String deliveryNo;
  String refNo;
  String fromDate;
  String toDate;
  Customer customer;
  int customerId = 0;
  String sortColumn ="Id";
  String sortDirection = "desc";
  int pageNumber = 1;
  int pageSize = 25;

  DeliveryNoteParameters({
    this.deliveryNo,
    this.refNo,
    this.fromDate,
    this.toDate,
    this.customer,
    this.customerId,
    this.sortColumn,
    this.sortDirection,
    this.pageNumber,
    this.pageSize,
  });

  DeliveryNoteParameters.fromJson(Map<String, dynamic> json) {
    deliveryNo = json['DeliveryNo'];
    refNo = json['RefNo'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    customerId = json['CustomerId'];
    sortColumn = json['SortColumn'];
    sortDirection = json['SortDirection'];
    pageNumber = json['PageNumber'];
    pageSize = json['PageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DeliveryNo'] = this.deliveryNo;
    data['RefNo'] = this.refNo;
    data['FromDate'] = this.fromDate;
    data['ToDate'] = this.toDate;
    data['CustomerId'] = this.customerId;
    data['SortColumn'] = this.sortColumn;
    data['SortDirection'] = this.sortDirection;
    data['PageNumber'] = this.pageNumber;
    data['PageSize'] = this.pageSize;
    return data;
  }

  String toString() {
    return '?DeliveryNo=${this.deliveryNo ?? ""}&RefNo=${this.refNo ?? ""}&FromDate=${this.fromDate ?? ""}&ToDate=${this.toDate ?? ""}&CustomerId=${this.customerId ?? 0}&SortColumn=${this.sortColumn ?? "id"}&SortDirection=${this.sortDirection ?? "desc"}&PageNumber=${this.pageNumber ?? "1"}&PageSize=${this.pageSize ?? "25"}';
  }
}
