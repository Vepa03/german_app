import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:german_quiz_app/service/Api_service.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {

  final _controller = TextEditingController();
  final List<String> _messages = [];
  bool _isLoading = false;

  void _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add("👤 $message");
      _isLoading = true;
      _controller.clear();
    });

    final result = await ApiService.getAIResponse(message);

    setState(() {
      _messages.add("🤖 $result");
      _isLoading = false;
    });
  }

  void reset(){
    showDialog(context: context, builder: (context)=> AlertDialog(
      title: Text("Do you want to reset?"),
      content: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width*0.3,
            child: OutlinedButton(onPressed: (){
              setState(() {
                _messages.clear();
              });
            }, child: Text("Yes", style: TextStyle(color: Colors.black, fontSize: 20),)))
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(_messages[index], style: TextStyle(fontSize: 15),),
                );
              },
            ),
          ),
          if (_isLoading) Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CircularProgressIndicator(),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Ask anything",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  SizedBox(width: 3),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.restart_alt, color: Colors.red,),
                        onPressed: (){
                          setState(() {
                          _messages.clear();
                        });
                        }
                      ),
                      IconButton(
                        icon: Icon(Icons.send_rounded, color: Colors.black,),
                        onPressed: _isLoading ? null : _sendMessage,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        
      ),
    );
  }
}