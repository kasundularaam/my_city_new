import 'dart:convert';

Issue issueFromJson(String str) => Issue.fromJson(json.decode(str));

String issueToJson(Issue data) => json.encode(data.toJson());

class Issue {
  Issue({
    this.Id,
    this.Image,
    this.Lat,
    this.Long,
    this.PostalCode,
    this.Location,
    this.Status,
    this.Date,
    this.RoadType,
    this.IssueType,
    this.AdminArea,
  });

  String Id;
  String Image;
  double Lat;
  double Long;
  int PostalCode;
  String Location;
  String Status;
  String Date;
  String RoadType;
  int IssueType;
  String AdminArea;

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
        Id: json["id"],
        Image: json["image"],
        Lat: json["lat"],
        Long: json["long"],
        PostalCode: json["postalCode"],
        Location: json["location"],
        Status: json["status"],
        Date: json["date"],
        RoadType: json["roadType"],
        IssueType: json["issueType"],
        AdminArea: json["adminArea"],
      );

  Map<String, dynamic> toJson() => {
        "image": Image,
        "lat": Lat,
        "long": Long,
        "postalCode": PostalCode,
        "location": Location,
        "status": Status,
        "date": Date,
        "roadType": RoadType,
        "issueType": IssueType,
        "adminArea": AdminArea,
      };
}
