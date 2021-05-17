import 'dart:convert';
import 'dart:io';
import 'package:my_city/src/models/user_modal.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:http/http.dart' as http;

class UserService extends Model {
  List<User> parseUsers(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  Future<List<User>> getAllUsers() async {
    try {
      String url = "https://hivi-99-apigateway-gww2g.ondigitalocean.app/User";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<User> userList = parseUsers(response.body);
        if (userList.isNotEmpty) {
          return userList;
        } else {
          throw Exception('no users');
        }
      } else {
        throw Exception('${response.statusCode}');
      }
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future<User> getUserByNIC(String nic) async {
    try {
      String url =
          "https://hivi-99-apigateway-gww2g.ondigitalocean.app/User/GetUserByNic/$nic";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<User> userByNicList = parseUsers(response.body);
        if (userByNicList.isNotEmpty) {
          return userByNicList[0];
        } else {
          throw Exception('no user found with this NIC');
        }
      } else {
        throw Exception('${response.statusCode}');
      }
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future<User> getUserById(String uid) async {
    try {
      String url =
          "https://hivi-99-apigateway-gww2g.ondigitalocean.app/User/$uid";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        User user = userFromJson(response.body);
        if (user != null) {
          return user;
        } else {
          throw Exception('User not found');
        }
      } else {
        throw Exception('${response.statusCode}');
      }
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future<String> loginUser(String nic, String password) async {
    User userForNic = await getUserByNIC(nic);
    if (userForNic.password == password) {
      return userForNic.id;
    } else {
      throw Exception('Password does not match');
    }
  }

  Future<String> signUpUser(User user) async {
    String url = "https://hivi-99-apigateway-gww2g.ondigitalocean.app/User";
    try {
      final http.Response response = await http.post(Uri.parse(url),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: userToJson(user));
      if (response.statusCode == 201) {
        User newUser = userFromJson(response.body);

        return newUser.id;
      } else {
        throw Exception('${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
