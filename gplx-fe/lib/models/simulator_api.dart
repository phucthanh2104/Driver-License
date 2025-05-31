import 'dart:convert';


import 'package:gplx/entities/Simulator.dart';
import 'package:gplx/models/base_url.dart';
import 'package:http/http.dart' as http;
class SimulatorAPI {



  Future<List<Simulator>> findAll() async {
    var response = await http.get(Uri.parse(BaseUrl.url + "simulator/findAll"));
    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(utf8.decode(response.bodyBytes));
      return res.map((e) => Simulator.fromMap(e)).toList();
    } else {
      throw Exception("Bad request when getting situations");
    }
  }
  Future<Simulator> findSimulatorById(int simulatorId) async {
    var response = await http.get(Uri.parse(BaseUrl.url + "simulator/findBySimulatorId/$simulatorId"));
    if (response.statusCode == 200) {
      dynamic res = jsonDecode(utf8.decode(response.bodyBytes));
      return Simulator.fromMap(res);
    } else {
      throw Exception("Bad request when getting simulator by ID");
    }
  }


}