import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message_encrypter/data/conversationsManager.dart';

import '../../../core/Constants.dart';
import '../../../core/appRouter.dart';
import '../../../core/styles.dart';
import '../../../core/utils.dart';
import '../../../data/UserManager.dart';
import '../../../data/conversation.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(Constants.kUsersCollection)
            .doc(FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final dynamicConversations = snapshot.data!['conversations'];
            List<Conversation> conversations =
                ConversationsManager.convertToConversations(
                    dynamicConversations);
            if (conversations.isNotEmpty) {
              return UsersListView(conversations: conversations);
            } else {
              return const Center(child: Text('Create A new Conversation'));
            }
          } else {
            return const Center(child: const Text('Create A new Conversation'));
          }
        },
      )),
      floatingActionButton: const Fab(),
      appBar: AppBar(),
      drawer: const NavBar(),
    );
  }
}

class UsersListView extends StatelessWidget {
  const UsersListView({
    super.key,
    required this.conversations,
  });

  final List<Conversation> conversations;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return ConversationAlertDialog(
                        conversation: conversations[index]);
                  });
            },
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                color: Constants.kAppTheme,
                child: Column(
                  children: [
                    ListTile(
                        leading: const Icon(Icons.list,color: Colors.white,),
                        title: Text(
                            "First User: ${conversations[index].firstEmail}",style: Styles.kSize17.copyWith(color: Colors.white),),),
                    ListTile(
                        leading: const Icon(null),
                        title: Text(
                            "Second User: ${conversations[index].secondEmail}",style: Styles.kSize17.copyWith(color: Colors.white))),
                    const SizedBox(height: 30,)
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class Fab extends StatelessWidget {
  const Fab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        buildCreateConversationDialog(context);
      },
      child: const Icon(Icons.add),
    );
  }
}

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouter.navigateToLogin(context);
        _signOut();
      },
      child: NavigationDrawer(
        children: [
          Column(
              children: const [
                SizedBox(
                  height: 20,
                ),
                Icon(Icons.account_circle),
                Center(child: Text("Sign out")),
              ],
            ),
        ],
      ),
    );
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

class ConversationAlertDialog extends StatefulWidget {
  const ConversationAlertDialog({Key? key, required this.conversation})
      : super(key: key);
  final Conversation conversation;

  @override
  State<ConversationAlertDialog> createState() =>
      _ConversationAlertDialogState();
}

class _ConversationAlertDialogState extends State<ConversationAlertDialog> {
  var textValue = '';

  @override
  Widget build(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    final TextEditingController textController = TextEditingController();
    return AlertDialog(
      title: const Text("Encrypt and decrypt"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: textController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Enter Text"),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {
                      String plainText = textController.text;
                      if (plainText.isNotEmpty) {
                        String keyString = widget.conversation.encryptionKey;
                        setState(() {
                          textValue = encryptText(keyString, plainText).base64;
                        });
                      }
                    },
                    child: const Text("Encrypt")),
                ElevatedButton(
                    onPressed: () {
                      String encryptedText = textController.text;
                      if (encryptedText.isNotEmpty) {
                        String keyString = widget.conversation.encryptionKey;

                        setState(() {
                          textValue = decryptText(keyString, encryptedText);
                        });
                      }
                    },
                    child: const Text("Decrypt")),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SelectableText(textValue)
          ],
        ),
      ),
      actions: [
        okButton,
      ],
    );
  }

  encrypt.Encrypted encryptText(String keyString, String plainText) {
    final key = encrypt.Key.fromUtf8(keyString);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final iv = encrypt.IV.fromLength(16);
    final encrypt.Encrypted encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted;
  }

  String decryptText(String keyString, String encryptedText) {
    final key = encrypt.Key.fromUtf8(keyString);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final iv = encrypt.IV.fromLength(16);
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }
}

Future<String?> buildCreateConversationDialog(BuildContext context) {
  TextEditingController emailController = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => Scaffold(
      backgroundColor: Colors.black12,
      body: AlertDialog(
        title: const Text('Create new conversation'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              String firstEmailAddress = emailController.text;
              if (EmailValidator.validate(firstEmailAddress)) {
                String? secondEmailAddress =
                    FirebaseAuth.instance.currentUser!.email;

                if (await UserManager.userEmailExists(firstEmailAddress) &&
                    secondEmailAddress != null &&
                    firstEmailAddress != secondEmailAddress) {
                  Conversation conversation =
                      ConversationsManager.createConversation(
                          firstEmailAddress, secondEmailAddress);
                  ConversationsManager.appendConversation(conversation);
                  if (context.mounted) Navigator.pop(context, 'Create');
                } else {
                  if (context.mounted)
                    Utils.showSnackbar("chatter's email doesn't exist in App", context);
                }
              } else {
                Utils.showSnackbar(
                    "couldn't validate chatter's email", context);
              }
            },
            child: const Text('Create'),
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "chatter's Email"),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
