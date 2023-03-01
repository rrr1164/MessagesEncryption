import 'conversation.dart';

class AppUser{

  List<Conversation> conversations = [];


  Map<String, dynamic> toJson() {
    return {
      "conversations": conversations
    };
  }
}