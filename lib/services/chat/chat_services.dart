import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // get user stream 
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individual user
        final user = doc.data();
        return user;
      }).toList();
    });
  }
  // send message
  Future<void> sendMessage(String receiverID, message) async {
    // get current user info 
    final User? currentUser = _firebaseAuth.currentUser;

    if (currentUser == null) {
      // Handle the case where the user is not logged in, perhaps throw an error
      return;
    }

    final String currentUserID = currentUser.uid;
    final String currentUserEmail = currentUser.email ?? "no-email@example.com";
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      message: message, 
      receiverID: receiverID, 
      senderEmail: currentUserEmail, 
      senderID: currentUserID, 
      timestamp: timestamp
    );

    // construct chat room ID for the two users
    // sort it to ensure uniqueness
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // add new message to database
    await _firestore
      .collection("chat_rooms")
      .doc(chatRoomID)
      .collection("messages")
      .add(newMessage.toMap());
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct a chatroom ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
      .collection("chat_rooms")
      .doc(chatRoomID)
      .collection("messages")
      .orderBy("timestamp", descending: false)
      .snapshots();
  }
}