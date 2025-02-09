import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

String apiKey = "YOUR_API_KEY";

// Suggested code may be subject to a license. Learn more: ~LicenseLog:3783361899.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1308165798.
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3223477464.
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessages> _messages = [];

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(model: "gemini-1.5-flash", apiKey: apiKey);
    _chat = _model.startChat();
  }

// Suggested code may be subject to a license. Learn more: ~LicenseLog:1442068912.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:17211689.
  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 750),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      _messages.add(ChatMessages(text: message, isUser: true));
    });

    try {
      final response = await _chat.sendMessage(Content.text(message));
      final text = response.text;
      setState(() {
        _messages.add(ChatMessages(text: text!, isUser: false));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessages(text: "Error occured", isUser: false));
      });
    } finally {
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("AI"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            controller: _scrollController,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return ChatBubble(messages: _messages[index]);
            },
          )),
          Padding(
              padding: EdgeInsets.all(8),
              child: Row(children: [
                Expanded(
                    child: TextField(
                  onSubmitted: _sendChatMessage,
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: "Masukan Pesan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )),
                IconButton(
                  onPressed: () => _sendChatMessage(_textController.text),
                  icon: Icon(Icons.send),
                )
              ]))
        ],
      ),
    );
  }
}

class ChatMessages {
  final String text;
  final bool isUser;
  ChatMessages({required this.text, required this.isUser});
}

class ChatBubble extends StatelessWidget {
  final ChatMessages messages;

  const ChatBubble({super.key, required this.messages});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      alignment: messages.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width / 1.25,
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: messages.isUser ? Colors.blue[200] : Colors.green[200],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: messages.isUser ? Radius.circular(12) : Radius.zero,
            bottomRight: messages.isUser ? Radius.zero : Radius.circular(12),
          ),
        ),
        child: Text(
          messages.text,
          style: TextStyle(
            fontSize: 16,
            color: messages.isUser ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
