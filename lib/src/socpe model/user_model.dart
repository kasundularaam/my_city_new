import 'dart:convert';
import 'dart:io';
import 'package:my_city/src/models/user_modal.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:http/http.dart' as http;

class UserModel extends Model {
  Future<http.Response> addUser(User user) async {
    String url = "https://hivi-99-apigateway-gww2g.ondigitalocean.app/User";

    final http.Response response = await http.post(Uri.parse(url),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: userToJson(user));
    return response;
  }

  List<User> parseUsers(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  Future<List<User>> getUsers() async {
    try {
      String url = "https://hivi-99-apigateway-gww2g.ondigitalocean.app/User";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return parseUsers(response.body);
      } else {
        throw Exception('Unable to fetch users from the REST API');
      }
    } catch (error) {
      print("The errror: $error");
    }
  }

  Future<List<User>> getUserByNIC(String nic) async {
    try {
      String url =
          "https://hivi-99-apigateway-gww2g.ondigitalocean.app/User/GetUserByNic/$nic";
      print(url);
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return parseUsers(response.body);
      } else {
        throw Exception('Unable to fetch users from the REST API');
      }
    } catch (error) {
      print("The errror: $error");
    }
  }
}
