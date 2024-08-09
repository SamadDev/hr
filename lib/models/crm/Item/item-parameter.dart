import 'package:nandrlon/models/crm/Item/Item-group.dart';
import 'package:nandrlon/models/crm/Item/Item-type.dart';
import 'package:nandrlon/models/crm/Item/Item-unit.dart';

class ItemParameters {
  String searchText;
  ItemGroup itemGroup;
  ItemUnit itemUnit;
  ItemType itemType;
  int itemGroupId;
  int itemTypeId;
  int itemUnitId;
  int itemStatusId;
  int pageNumber;
  int pageSize;

  String toString() {
    var q = '?SearchText=${this.searchText ?? ""}&ItemGroupId=${this.itemGroupId ?? 0}&ItemTypeId=${this.itemTypeId ?? 0}&ItemUnitId=${this.itemUnitId ?? 0}&ItemStatusId=${this.itemStatusId ?? 0}&PageNumber=${this.pageNumber ?? 1}&PageSize=${this.pageSize ?? 10}';
    
    
    return q;
  }
}
