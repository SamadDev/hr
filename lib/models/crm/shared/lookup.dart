class Lookup {
  int id;
  int lookupTypeId;
  String name;
  String value;

  Lookup({
    this.id,
    this.lookupTypeId,
    this.name,
    this.value,
  });

  Lookup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lookupTypeId = json['lookupTypeId'];
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lookupTypeId'] = this.lookupTypeId;
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }

  static List<Lookup> toList(parsed) {
    return parsed.map<Lookup>((json) => Lookup.fromJson(json)).toList();
  }
}
