import 'dart:convert';

import 'package:gplx/entities/Rank.dart';
import 'package:gplx/entities/TestDetail.dart';
import 'package:gplx/entities/TestSimulatorDetail.dart';
import 'package:gplx/entities/Test.dart';
import 'package:gplx/models/base_url.dart';
import 'package:http/http.dart' as http;
class TestSimulatorDetailsAPI {

  Future<List<TestSimulatortDetail>> findByTestId(int id) async {

    var respone = await http.get(Uri.parse(BaseUrl.url + "testSimulatorDetails/findByTestId/" + id.toString()));
    if (respone.statusCode == 200) {
      List<dynamic> res = jsonDecode(utf8.decode(respone.bodyBytes));
      return res.map((e) => TestSimulatortDetail.fromMap(e)).toList();
    } else {
      throw Exception("Bad request");
    }
  }

}