import 'package:flutter/material.dart';
import 'package:gplx/models/chatbot_api.dart';

class ChatbotAI extends StatefulWidget {
  const ChatbotAI({Key? key}) : super(key: key);

  @override
  _ChatbotAIState createState() => _ChatbotAIState();
}

class _ChatbotAIState extends State<ChatbotAI> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  final List<_ChatMessage> _messages = [];

  void _sendQuestion() async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _isLoading = true;
      _messages.add(_ChatMessage(sender: "user", message: question));
    });

    _controller.clear();

    final fullPrompt =
        "Bạn là trợ lý pháp luật giao thông Việt Nam. Trả lời ngắn gọn, chính xác, không thêm thông tin nếu không chắc chắn. "
        "Chỉ trả lời dựa trên Luật Giao thông đường bộ hiện hành và Luật Xử lý vi phạm hành chính. "
        "Không suy đoán hoặc tạo ra luật nếu không có thật. Nếu không hỏi về luật giao thông thì không cần trả lời. Câu hỏi: $question";


    try {
      final api = ChatbotAPI();
      final result = await api.askChatbot(fullPrompt);

      setState(() {
        _messages.add(_ChatMessage(sender: "bot", message: result));
      });
    } catch (e) {
      setState(() {
        _messages.add(_ChatMessage(sender: "bot", message: "Lỗi: ${e.toString()}"));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildChatBubble(_ChatMessage msg) {
    bool isUser = msg.sender == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),
        child: Text(
          msg.message,
          style: TextStyle(
            fontSize: 17,
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trợ lý Giao Thông AI'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                reverse: false,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildChatBubble(_messages[index]);
                },
              ),
            ),
          ),
          if (_isLoading) ...[
            const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text(
                    "Bạn hãy đợi AI trả lời nhé...",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  )
                ],
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: 3,
                    minLines: 1,
                    decoration: const InputDecoration(
                      hintText: 'Nhập câu hỏi của bạn...',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendQuestion,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(14)),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String sender; // "user" or "bot"
  final String message;

  _ChatMessage({required this.sender, required this.message});
}
