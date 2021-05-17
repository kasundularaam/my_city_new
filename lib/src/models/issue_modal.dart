import 'dart:convert';

Issue issueFromJson(String str) => Issue.fromJson(json.decode(str));

String issueToJson(Issue data) => json.encode(data.toJson());

class Issue {
  Issue({
    this.id,
    this.image,
    this.lat,
    this.long,
    this.postalCode,
    this.location,
    this.status,
    this.date,
    this.roadType,
    this.issueType,
    this.adminArea,
    this.uid,
  });

  String id;
  String image;
  double lat;
  double long;
  int postalCode;
  String location;
  String status;
  String date;
  String roadType;
  int issueType;
  String adminArea;
  String uid;

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
        id: json["id"],
        image: json["image"],
        lat: json["lat"].toDouble(),
        long: json["long"].toDouble(),
        postalCode: json["postalCode"],
        location: json["location"],
        status: json["status"],
        date: json["date"],
        roadType: json["roadType"],
        issueType: json["issueType"],
        adminArea: json["adminArea"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "lat": lat,
        "long": long,
        "postalCode": postalCode,
        "location": location,
        "status": status,
        "date": date,
        "roadType": roadType,
        "issueType": issueType,
        "adminArea": adminArea,
        "uid": uid,
      };
}
