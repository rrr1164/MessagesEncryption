class Conversation {
  String firstEmail;

  String secondEmail;

  String encryptionKey;

  Conversation(
      {required this.firstEmail,
      required this.secondEmail,
      required this.encryptionKey});

  Map<String, dynamic> toJson() {
    return {
      "firstEmail": firstEmail,
      "secondEmail": secondEmail,
      "encryptionKey": encryptionKey
    };
  }
  factory Conversation.fromJson(Map<dynamic, dynamic> json) {
    return Conversation(
        encryptionKey: json['encryptionKey'],
        firstEmail: json['firstEmail'],
        secondEmail: json['secondEmail']);
  }
}
