class ItemPhoto {
  int id;
  int itemId;
  String url;
  String description;
  Null item;

  ItemPhoto({
    this.id,
    this.itemId,
    this.url,
    this.description,
    this.item,
  });

  ItemPhoto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['itemId'];
    url = json['url'];
    description = json['description'];
    item = json['item'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['itemId'] = this.itemId;
    data['url'] = this.url;
    data['description'] = this.description;
    data['item'] = this.item;
    return data;
  }

  static List<ItemPhoto> toList(parsed) {
    return parsed.map<ItemPhoto>((json) => ItemPhoto.fromJson(json)).toList();
  }
}
