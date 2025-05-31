import 'dart:convert';

import 'package:gplx/entities/ChapterSimulator.dart';
import 'package:gplx/entities/Simulator.dart';
import 'package:gplx/models/base_url.dart';
import 'package:http/http.dart' as http;
class ChapterSimulatorAPI {

  Future<List<ChapterSimulator>> findAllChapterSimulator() async {

    var respone = await http.get(Uri.parse(BaseUrl.url + "chapter_simulator/findAll"));
    if (respone.statusCode == 200) {
      List<dynamic> res = jsonDecode(utf8.decode(respone.bodyBytes));
      return res.map((e) => ChapterSimulator.fromMap(e)).toList();
    } else {
      throw Exception("Bad request");
    }
  }

  Future<List<Simulator>> findSituationsByChapterId(int chapterId) async {
    var response = await http.get(Uri.parse(BaseUrl.url + "chapter_simulator/findByChapterId/$chapterId"));
    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(utf8.decode(response.bodyBytes));
      return res.map((e) => Simulator.fromMap(e)).toList();
    } else {
      throw Exception("Bad request when getting situations");
    }
  }
  Future<Simulator> findSimulatorById(int simulatorId) async {
    var response = await http.get(Uri.parse(BaseUrl.url + "chapter_simulator/findBySimulatorId/$simulatorId"));
    if (response.statusCode == 200) {
      dynamic res = jsonDecode(utf8.decode(response.bodyBytes));
      return Simulator.fromMap(res);
    } else {
      throw Exception("Bad request when getting simulator by ID");
    }
  }


}