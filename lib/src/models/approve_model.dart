import 'dart:convert';

Approve approveFromJson(String str) => Approve.fromJson(json.decode(str));

String approveToJson(Approve data) => json.encode(data.toJson());

class Approve {
  Approve({
    this.id,
    this.userId,
    this.issueId,
  });

  String id;
  String userId;
  String issueId;

  factory Approve.fromJson(Map<String, dynamic> json) => Approve(
        id: json["id"],
        userId: json["userId"],
        issueId: json["issueId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "issueId": issueId,
      };
}
