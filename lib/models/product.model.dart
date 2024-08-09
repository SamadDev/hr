class Product {
  int id;
  String name;
  String group;
  double price;
  bool selected;
  double quantity;
  double discount;
  double total;
  String description;

  Product({
    this.id,
    this.name,
    this.group,
    this.price,
    this.selected,
    this.quantity,
    this.discount,
    this.total,
    this.description,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    group = json['group'];
    price = json['price'];
    selected = json['selected'];
    quantity = json['quantity'];
    discount = json['discount'];
    total = json['total'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['group'] = this.group;
    data['price'] = this.price;
    data['selected'] = this.selected;
    data['quantity'] = this.quantity;
    data['discount'] = this.discount;
    data['total'] = this.total;
    data['totaltotal'] = this.description;
    return data;
  }
}
