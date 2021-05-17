import 'dart:convert';
import 'dart:io';

import 'package:my_city/src/models/approve_model.dart';
import 'package:http/http.dart' as http;

class ApproveService {
  List<Approve> parseLikes(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Approve>((json) => Approve.fromJson(json)).toList();
  }

  Future<List<Approve>> getAllLikes() async {
    try {
      String url =
          "https://hivi-99-apigateway-gww2g.ondigitalocean.app/Approve";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<Approve> likeList = parseLikes(response.body);
        return likeList;
      } else {
        throw Exception('${response.statusCode}');
      }
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future<bool> isUserLiked(String userId, String issueId) async {
    try {
      String url =
          "https://hivi-99-apigateway-gww2g.ondigitalocean.app/Approve/GetApprovalByIds/$userId/$issueId";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<Approve> likeList = parseLikes(response.body);
        if (likeList.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      } else {
        throw Exception('${response.statusCode}');
      }
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future<Approve> getLikeByUidIid(String userId, String issueId) async {
    try {
      String url =
          "https://hivi-99-apigateway-gww2g.ondigitalocean.app/Approve/GetApprovalByIds/$userId/$issueId";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<Approve> likeList = parseLikes(response.body);
        if (likeList.isNotEmpty) {
          return likeList[0];
        } else {
          throw Exception("can not find specific data");
        }
      } else {
        throw Exception('${response.statusCode}');
      }
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future<List<Approve>> likesForIssue(String issueId) async {
    try {
      List<Approve> likeList = await getAllLikes();
      if (likeList.isNotEmpty) {
        List<Approve> listForIssue = [];
        likeList.forEach((like) {
          if (like.issueId == issueId) {
            listForIssue.add(like);
          }
        });
        return listForIssue;
      } else {
        throw Exception("no likes found..");
      }
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future<int> likeCountForIssue(String issueId) async {
    try {
      List<Approve> likeList = await likesForIssue(issueId);
      return likeList.length;
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future<bool> likeIssue(Approve approve) async {
    String url = "https://hivi-99-apigateway-gww2g.ondigitalocean.app/Approve";
    try {
      final http.Response response = await http.post(Uri.parse(url),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: approveToJson(approve));
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<bool> disLikeIssue(String userId, String issueId) async {
    Approve approve = await getLikeByUidIid(userId, issueId);
    String url =
        "https://hivi-99-apigateway-gww2g.ondigitalocean.app/Approve/${approve.id}";
    try {
      final http.Response response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> delteLikeList(String issueId) async {
    try {
      List<Approve> likeList = await likesForIssue(issueId);
      likeList.forEach((like) async {
        String url =
            "https://hivi-99-apigateway-gww2g.ondigitalocean.app/Approve/${like.id}";
        final http.Response response = await http.delete(Uri.parse(url));
        if (response.statusCode == 200) {
          return true;
        } else {
          throw Exception('${response.statusCode}');
        }
      });
    } catch (e) {
      throw Exception('$e');
    }
  }
}
