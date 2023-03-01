import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:message_encrypter/data/conversation.dart';

class ConversationsManager {
  static void appendConversation(Conversation conversation) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(conversation.firstEmail)
        .update({
      'conversations': FieldValue.arrayUnion([conversation.toJson()])
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(conversation.secondEmail)
        .update({
      'conversations': FieldValue.arrayUnion([conversation.toJson()])
    });
  }
  static List<Conversation> convertToConversations(List<dynamic> dynamicConversations){
    List<Conversation> conversations = [];
    for (int i = 0; i < dynamicConversations.length; i++) {
      conversations.add(Conversation(
        firstEmail: dynamicConversations[i]['firstEmail'],
        secondEmail: dynamicConversations[i]['secondEmail'],
        encryptionKey: dynamicConversations[i]['encryptionKey'],
      ));
    }
    return conversations;
  }
  static String createCryptoRandomString(Random random, [int length = 12]) {
    var values = List<int>.generate(length, (i) => random.nextInt(256));

    return base64Url.encode(values);
  }

  static Conversation createConversation(
      String firstEmailAddress, String secondEmailAddress) {
    final Random random = Random.secure();
    String encryptionKey =
        ConversationsManager.createCryptoRandomString(random);
    Conversation conversation = Conversation(
        firstEmail: firstEmailAddress,
        secondEmail: secondEmailAddress,
        encryptionKey: encryptionKey);
    return conversation;
  }
}
