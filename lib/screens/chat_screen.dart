import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

final _fireStore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const String id = 'chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();


  String? messageText;

  Future<void> getCurrentUser() async {
    try {
      final user = _auth.currentUser!;
      final uid = user.uid;
      if (uid.isNotEmpty) {
        loggedInUser = user;
        print(loggedInUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

/*  Future<void> getMessages() async {
  final messages = await _fireStore.collection('messages').get();
  for(var message in messages.docs){
    print(message.data());
  }
  }*/

  void messagesStream() async {
    await for (var snapshot in _fireStore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // messagesStream();
                // getMessages();
                //Implement logout functionality
                   _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      //Implement send functionality.
                      messageTextController.clear();
                      _fireStore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser!.email,
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        MessageBubble messageBubble;
        List<MessageBubble> messageBubbles = [];
        final messages = snapshot.data!.docs.reversed;
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');

          final currentUser = loggedInUser!.email;

          messageBubble = MessageBubble(
            sender:messageSender ,
            text:messageText ,
            isMe: currentUser == messageSender?true:false,
          );

          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  final String? sender;
  final String? text;
  final bool? isMe;
  const MessageBubble({Key? key,this.sender,this.text,this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe!?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(sender!,style: const TextStyle(
            fontSize: 12,
            color: Colors.black54
          ),),
          Material(
              elevation: 5.0,
              borderRadius: isMe!?BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight:Radius.circular(30)
              ):BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight:Radius.circular(30),
                topRight: Radius.circular(30)
              ),
              color: isMe!?Colors.lightBlueAccent:Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal:20 ),
                child: Text('$text',style:  TextStyle(
                    color: isMe!?Colors.white:Colors.black54,
                    fontSize: 15.0
                ),),
              )
          ),
        ],
      ),
    );
  }
}

