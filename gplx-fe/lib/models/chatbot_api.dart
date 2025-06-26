import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gplx/models/base_url.dart';

class ChatbotAPI {
  Future<String> askChatbot(String prompt) async {
    final url = Uri.parse(BaseUrl.url + "chatbot/ask");
  print(url);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(prompt), // prompt là chuỗi đơn thuần, không phải object
    );
    print(response);
    if (response.statusCode == 200) {
      return response.body; // trả về response từ chatbot
    } else {
      throw Exception("Lỗi gọi API Chatbot: ${response.statusCode}");
    }
  }
}
