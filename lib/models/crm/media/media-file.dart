class MediaFile {
  int id;
  int mediaId;
  String fileUrl;
  String fileName;
  int fileSize;
  int mediaFileTypeId;
  FileType fileType;
  String createdBy;
  String createdDate;
  String modifiedBy;
  String modifiedDate;
  int entityMode;

  MediaFile(
      {this.id,
        this.mediaId,
        this.fileUrl,
        this.fileName,
        this.fileSize,
        this.mediaFileTypeId,
        this.fileType,
        this.createdBy,
        this.createdDate,
        this.modifiedBy,
        this.modifiedDate,
        this.entityMode});

  MediaFile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mediaId = json['mediaId'];
    fileUrl = json['fileUrl'];
    fileName = json['fileName'];
    fileSize = json['fileSize'];
    mediaFileTypeId = json['mediaFileTypeId'];
    fileType = json['fileType'] != null
        ? new FileType.fromJson(json['fileType'])
        : null;
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    modifiedBy = json['modifiedBy'];
    modifiedDate = json['modifiedDate'];
    entityMode = json['entityMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mediaId'] = this.mediaId;
    data['fileUrl'] = this.fileUrl;
    data['fileName'] = this.fileName;
    data['fileSize'] = this.fileSize;
    data['mediaFileTypeId'] = this.mediaFileTypeId;
    if (this.fileType != null) {
      data['fileType'] = this.fileType.toJson();
    }
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedDate'] = this.modifiedDate;
    data['entityMode'] = this.entityMode;
    return data;
  }

  static List<MediaFile> toList(parsed) {
    return parsed.map<MediaFile>((json) => MediaFile.fromJson(json)).toList();
  }
}

class FileType {
  int id;
  String name;
  String icon;
  String createdBy;
  String createdDate;
  String modifiedBy;
  String modifiedDate;
  int entityMode;

  FileType(
      {this.id,
        this.name,
        this.icon,
        this.createdBy,
        this.createdDate,
        this.modifiedBy,
        this.modifiedDate,
        this.entityMode});

  FileType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    modifiedBy = json['modifiedBy'];
    modifiedDate = json['modifiedDate'];
    entityMode = json['entityMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedDate'] = this.modifiedDate;
    data['entityMode'] = this.entityMode;
    return data;
  }
}