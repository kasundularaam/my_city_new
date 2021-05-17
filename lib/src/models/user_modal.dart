import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.name,
    this.nic,
    this.password,
    this.postalCode,
    this.area,
  });

  String id;
  String name;
  String nic;
  String password;
  int postalCode;
  String area;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        nic: json["nic"],
        password: json["password"],
        postalCode: json["postalCode"],
        area: json["area"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nic": nic,
        "password": password,
        "postalCode": postalCode,
        "area": area,
      };
}
