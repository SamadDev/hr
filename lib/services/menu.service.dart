import 'package:nandrlon/models/menu.dart';
import 'package:nandrlon/services/crm.service.dart';

class MenuService {
  static String api = "/api/menus/2/menu-items";

  static Future<List<Menu>> getMenus(int id) async {
    final result = await CRMDataService.get("/api/menus/${id}/menu-items");
    return Menu.toList(result);
  }
}
