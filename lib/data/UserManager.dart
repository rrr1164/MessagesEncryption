import 'package:firebase_auth/firebase_auth.dart';

class UserManager{
  static bool userLoggedIn(){
    return FirebaseAuth.instance.currentUser != null;
  }
  static Future<bool> userEmailExists(String emailAddress) async {
    try {
      final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(
          emailAddress);

      if (list.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return true;
    }
  }
}