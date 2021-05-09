import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.Id,
    this.Name,
    this.NIC,
    this.Password,
    this.Type,
    this.AdminArea,
    this.PostalCode,
  });

  String Id;
  String Name;
  String NIC;
  String Password;
  String Type;
  String AdminArea;
  int PostalCode;

  factory User.fromJson(Map<String, dynamic> json) => User(
        Id: json["id"],
        Name: json["name"],
        NIC: json["nic"],
        Password: json["password"],
        Type: json["type"],
        AdminArea: json["area"],
        PostalCode: json["postalCode"],
      );

  Map<String, dynamic> toJson() => {
        "id": Id,
        "name": Name,
        "nic": NIC,
        "password": Password,
        "type": Type,
        "area": AdminArea,
        "postalCode": PostalCode,
      };
}
