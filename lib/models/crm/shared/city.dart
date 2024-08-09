class City {
  int id;
  int countryId;
  String name;
  Null abbrName;
  Null sort;
  bool isDefault;
  Null description;

  City(
      {this.id,
      this.countryId,
      this.name,
      this.abbrName,
      this.sort,
      this.isDefault,
      this.description});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['countryId'];
    name = json['name'];
    abbrName = json['abbrName'];
    sort = json['sort'];
    isDefault = json['isDefault'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['countryId'] = this.countryId;
    data['name'] = this.name;
    data['abbrName'] = this.abbrName;
    data['sort'] = this.sort;
    data['isDefault'] = this.isDefault;
    data['description'] = this.description;
    return data;
  }

  static List<City> toList(parsed) {
    return parsed.map<City>((json) => City.fromJson(json)).toList();
  }
}
