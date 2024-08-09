class Media {
  int id;
  String name;
  String summary;
  String details;
  String description;
  String createdDate;

  Media({
    this.id,
    this.name,
    this.summary,
    this.details,
    this.description,
    this.createdDate,
  });

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    summary = json['summary'];
    details = json['details'];
    description = json['description'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['summary'] = this.summary;
    data['details'] = this.details;
    data['description'] = this.description;
    data['createdDate'] = this.createdDate;
    return data;
  }

  static List<Media> toList(parsed) {
    return parsed.map<Media>((json) => Media.fromJson(json)).toList();
  }
}
