import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/textfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key, 
    required this.receiverEmail,
    required this.receiverID
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  // textfield focus
  FocusNode focusNode = FocusNode();
  @override 
  void initState() {
    super.initState();
    // add a listener to focus node 
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        /* cause a delay so that the keyboard has time to
          show up. Then the amount of remaining space will 
          be calculated. Then scroll down*/
          Future.delayed(const Duration(milliseconds: 500),
          () => scrollDown(),);
      }
    });
    // wait a bit for listView to be built, then scroll to bottom
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override 
  void dispose() {
    focusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // scroll controller 
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, 
      duration: const Duration(seconds: 1), 
      curve: Curves.fastOutSlowIn
    );
  }

  // send message
  void sendMessage() async {
    // if there is something inside the textfield
    if (_messageController.text.isNotEmpty) {
      // send the message
      await _chatService.sendMessage(widget.receiverID, _messageController.text);

      // clear text controller
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: Column(children: [
        // display all messages 
        Expanded(
          child: _buildMessageList()
        ),

        // display user input
        _buildUserInput()
      ],)
    );
  }

  // build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        // errors
        if (snapshot.hasError) {
          return const Text("Error");
        }
        // loading 
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading ...");
        }

        // return list view
        return ListView(
          controller: _scrollController,
          children: 
            snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList()
        ); // ListView
      },
    ); // StreamBuilder
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    /* align messages to the right if send is 
    is current user else left */
    var alignment = isCurrentUser ? 
      Alignment.centerRight : 
      Alignment.centerLeft;
    
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: 
          isCurrentUser ? CrossAxisAlignment.end : 
          CrossAxisAlignment.start,
        children: [
          ChatBubble(
            isCurrentUser: isCurrentUser, 
            message: data["message"],
          )
        ],
      )
    );
  }

  // build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          // textfield take up most of the space
          Expanded(child: CustomTextField(
            hintText: "Type a message",
            controller: _messageController,
            focusNode: focusNode,
          ),),
          // send button
          Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,  
            ), // Box decoration 
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage, 
              icon: const Icon(Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}