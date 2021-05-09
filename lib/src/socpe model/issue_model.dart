import 'dart:convert';
import 'dart:io';
import 'package:my_city/src/models/issue_modal.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:http/http.dart' as http;

class IssueModel extends Model {
  Future<http.Response> addIssue(Issue issue) async {
    String url = "https://hivi-99-apigateway-gww2g.ondigitalocean.app/Issue";

    final http.Response response = await http.post(Uri.parse(url),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: issueToJson(issue));
    return response;
  }

  List<Issue> parseIssues(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Issue>((json) => Issue.fromJson(json)).toList();
  }

  Future<List<Issue>> getIssues() async {
    try {
      String url = "https://hivi-99-apigateway-gww2g.ondigitalocean.app/Issue";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return parseIssues(response.body);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      print("The errror: $error");
    }
  }

  Future<List<Issue>> getIssuesByAdminArea(String adminArea) async {
    try {
      String url =
          "https://hivi-99-apigateway-gww2g.ondigitalocean.app/Issue/GetIssueByAdminArea/$adminArea";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return parseIssues(response.body);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      print("The errror: $error");
    }
  }
}
