import 'dart:convert';
import 'dart:io';
import 'package:my_city/src/models/issue_modal.dart';

import 'package:http/http.dart' as http;
import 'package:my_city/src/services/approve_service.dart';

class IssueService {
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
        List<Issue> issueList = parseIssues(response.body);
        if (issueList != null) {
          return issueList;
        } else {
          throw Exception("no issues found");
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future<List<Issue>> getIssuesByAdminArea(String adminArea) async {
    try {
      String url =
          "https://hivi-99-apigateway-gww2g.ondigitalocean.app/Issue/GetIssueByAdminArea/$adminArea";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<Issue> issueList = parseIssues(response.body);
        if (issueList != null) {
          return issueList;
        } else {
          throw Exception("no issues found");
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future<List<Issue>> getIssuesByUid(String uid) async {
    try {
      List<Issue> issueList = await getIssues();
      List<Issue> issueListForUid = [];
      issueList.forEach((issue) {
        if (issue.uid == uid) {
          issueListForUid.add(issue);
        }
      });
      if (issueListForUid.isNotEmpty) {
        return issueListForUid;
      } else {
        throw Exception("you have not reported any issue yet");
      }
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future<bool> deleteIssue(String issueId) async {
    ApproveService approveService = ApproveService();
    String url =
        "https://hivi-99-apigateway-gww2g.ondigitalocean.app/Issue/$issueId";
    try {
      final http.Response response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        approveService.delteLikeList(issueId);
        return true;
      } else {
        throw Exception('${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<Issue> getIssueById(String issueId) async {
    String url =
        "https://hivi-99-apigateway-gww2g.ondigitalocean.app/Issue/$issueId";
    try {
      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Issue issue = issueFromJson(response.body);
        return issue;
      } else {
        throw Exception('${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<bool> isApproved(String issueId) async {
    Issue issue = await getIssueById(issueId);
    print("get is approved = ${issue.status}");
    if (issue.status == "approved") {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateStatus(String issueId, bool isApprove) async {
    String status;
    if (isApprove) {
      status = "approved";
    } else {
      status = "initial";
    }
    try {
      String url =
          "https://hivi-99-apigateway-gww2g.ondigitalocean.app/Issue/$issueId";

      final http.Response response = await http.put(
        Uri.parse(url),
      );
      print("response body ${response.body}");
      print("status code ${response.statusCode}");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("$e");
    }
  }
}
