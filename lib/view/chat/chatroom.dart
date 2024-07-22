import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/services/chatgpt.dart';
import 'package:todos/shared/state.dart';
import 'package:chatview/chatview.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({super.key});

  @override
  State<Chatroom> createState() => _ChatState();
}

class _ChatState extends State<Chatroom> {
  final UserController c = Get.put(UserController());
  var chatController;
  List<Message> messageList = [];
  String? threadid;
  void onSendTap(String message, ReplyMessage replyMessage,
      MessageType messageType) async {
    var messages = Message(
      id: '3',
      message: message,
      createdAt: DateTime.now(),
      sentBy: "me",
      replyMessage: replyMessage,
      messageType: messageType,
    );
    chatController.addMessage(messages);

    _showHideTypingIndicator();

    var response =
        await Chatgpt().gettodoslist(message: message, threadId: threadid);

    messages = Message(
      id: '4',
      message: response["message"],
      createdAt: DateTime.now(),
      sentBy: "bot",
      replyMessage: replyMessage,
      messageType: messageType,
    );
    threadid = response["threadId"];
    _showHideTypingIndicator();
    chatController.addMessage(messages);
  }

  @override
  void initState() {
    chatController = ChatController(
      initialMessageList: messageList,
      scrollController: ScrollController(),
      currentUser: ChatUser(id: 'me', name: 'me'),
      otherUsers: [ChatUser(id: 'bot', name: 'bot')],
    );
    super.initState();
  }

  void _showHideTypingIndicator() {
    chatController.setTypingIndicator = !chatController.showTypingIndicator;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatView(
        appBar: const ChatViewAppBar(
          chatTitle: "Chat",
        ),
        chatController: chatController,
        onSendTap: onSendTap,
        chatViewState: ChatViewState.hasMessages,
        sendMessageConfig: const SendMessageConfiguration(
          enableGalleryImagePicker: false,
          enableCameraImagePicker: false,
          allowRecordingVoice: false,
          textFieldConfig: TextFieldConfiguration(
            compositionThresholdTime: const Duration(seconds: 1),
            textStyle: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
