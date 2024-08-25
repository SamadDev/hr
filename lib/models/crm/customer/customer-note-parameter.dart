// @dart=2.9

class CustomerNoteParameters {
  String searchText;
  int customerId;
  DateTime fromDate;
  DateTime toDate;
  String sortColumn;
  String sortDirection;
  String pageNumber;
  String pageSize;

  String toString() {
    return '?SearchText=${this.searchText ?? ""}&CustomerId=${this.customerId ?? 0}&FromDate=${this.fromDate}&ToDate=${this.toDate ?? 0}&SortColumn=${this.sortColumn ?? "Id"}&SortDirection=${this.sortDirection ?? "Desc"}&PageNumber=${this.pageNumber ?? 1}&PageSize=${this.pageSize ?? 25}';
  }
}
