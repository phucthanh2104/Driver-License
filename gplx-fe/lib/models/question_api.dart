import 'dart:convert';

import 'package:gplx/entities/Question.dart';
import 'package:gplx/entities/Rank.dart';
import 'package:gplx/entities/Test.dart';
import 'package:gplx/models/base_url.dart';
import 'package:http/http.dart' as http;
class QuestionAPI {

  Future<List<Question>> findAll() async {
    try {
      var response = await http.get(Uri.parse(BaseUrl.url + "question/findAll"));
      if (response.statusCode == 200) {
        List<dynamic> res = jsonDecode(utf8.decode(response.bodyBytes));
        return res.map((e) => Question.fromMap(e)).toList();
      } else {
        throw Exception("Yêu cầu không thành công: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Lỗi khi gọi API: $e");
    }
  }

  Future<List<Rank>> findAllRank() async {

    var respone = await http.get(Uri.parse(BaseUrl.url + "test/findAllRank"));
    if (respone.statusCode == 200) {
      List<dynamic> res = jsonDecode(utf8.decode(respone.bodyBytes));
      return res.map((e) => Rank.fromMap(e)).toList();
    } else {
      throw Exception("Bad request");
    }
  }

  Future<List<Question>> findAllFailed() async {
    try {
      var response = await http.get(Uri.parse(BaseUrl.url + "question/findAllFailed"));
      if (response.statusCode == 200) {
        List<dynamic> res = jsonDecode(utf8.decode(response.bodyBytes));
        return res.map((e) => Question.fromMap(e)).toList();
      } else {
        throw Exception("Yêu cầu không thành công: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Lỗi khi gọi API: $e");
    }
  }

  Future<List<Question>> findAllFailedByRankA() async {
    try {
      var response = await http.get(Uri.parse(BaseUrl.url + "question/findAllFailedOfRankA"));
      if (response.statusCode == 200) {
        List<dynamic> res = jsonDecode(utf8.decode(response.bodyBytes));
        return res.map((e) => Question.fromMap(e)).toList();
      } else {
        throw Exception("Yêu cầu không thành công: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Lỗi khi gọi API: $e");
    }
  }

}