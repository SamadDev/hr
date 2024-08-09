class Menu {
  int id;
  String name;
  String url;
  int sort;
  Null parameters;
  Null parentId;
  List<Attributes> attributes;
  List<Menu> menuItems;

  Menu(
      {this.id,
        this.name,
        this.url,
        this.sort,
        this.parameters,
        this.parentId,
        this.attributes,
        this.menuItems});

  Menu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    sort = json['sort'];
    parameters = json['parameters'];
    parentId = json['parentId'];
    if (json['attributes'] != null) {
      attributes = new List<Attributes>();
      json['attributes'].forEach((v) {
        attributes.add(new Attributes.fromJson(v));
      });
    }
    if (json['menuItems'] != null) {
      menuItems = new List<Null>();
      json['menuItems'].forEach((v) {
        menuItems.add(new Menu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    data['sort'] = this.sort;
    data['parameters'] = this.parameters;
    data['parentId'] = this.parentId;
    if (this.attributes != null) {
      data['attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }
    if (this.menuItems != null) {
      data['menuItems'] = this.menuItems.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static List<Menu> toList(parsed) {
    return parsed.map<Menu>((json) => Menu.fromJson(json)).toList();
  }
}

class Attributes {
  int id;
  int menuItemId;
  String name;
  String value;
  Null menuItem;

  Attributes({this.id, this.menuItemId, this.name, this.value, this.menuItem});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuItemId = json['menuItemId'];
    name = json['name'];
    value = json['value'];
    menuItem = json['menuItem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['menuItemId'] = this.menuItemId;
    data['name'] = this.name;
    data['value'] = this.value;
    data['menuItem'] = this.menuItem;
    return data;
  }
}
