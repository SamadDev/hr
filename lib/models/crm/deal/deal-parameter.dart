
class DealParameters {
  String searchText;
  String fromDate;
  String toDate;
  String dealTypeId;
  int customerId;
  int customerContactId;
  int stageId;
  double fromAmount;
  double toAmount;
  String sortColumn;
  String sortDirection;
  String pageNumber;
  String pageSize;

  String toString() {
    return '?SearchText=${this.searchText ?? ""}&FromDate=${this.fromDate ?? ""}&toDate=${this.toDate ?? ""}&DealTypeId=${this.dealTypeId ?? 0}&CustomerId=${this.customerId ?? 0}&CustomerContactId=${this.customerContactId ?? 0}&stageId=${this.stageId ?? 0}&FromAmount=${this.fromAmount ?? 0}&ToAmount=${this.toAmount ?? 0}&SortColumn=${this.sortColumn ?? "Id"}&SortDirection=${this.sortDirection ?? "Desc"}&PageNumber=${this.pageNumber ?? 1}&PageSize=${this.pageSize ?? 25}';
  }
}
