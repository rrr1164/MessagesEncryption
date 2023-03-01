import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_encrypter/core/constants.dart';
import 'package:message_encrypter/cubits/authentication/register/regsiterState.dart';

import '../../../data/AppUser.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> addUser(String emailAddress, String password) async {
    emit(RegisterLoading());

    if (_validateForm(emailAddress, password)) {
      List createdUser = await _createUser(emailAddress, password);
      if (createdUser[0] == false) {
        String errorMessage = createdUser[1];
        emit(RegisterError(errorMessage: errorMessage));
      } else {
        bool stored = _storeUserInDatabase(emailAddress);
        if (stored) {
          emit(RegisterSuccess());
        } else {
          String errorMessage = "Error Storing user";
          emit(RegisterError(errorMessage: errorMessage));
        }
      }
    } else {
      String errorMessage = "Error Validating Form";
      emit(RegisterError(errorMessage: errorMessage));
    }
  }

  bool _storeUserInDatabase(String emailAddress) {
    bool stored = true;
    AppUser user = AppUser();
    FirebaseFirestore.instance
        .collection(Constants.kUsersCollection)
        .doc(emailAddress)
        .set(user.toJson())
        .onError((error, stackTrace) => stored = false);
    return stored;
  }

  Future<List> _createUser(String emailAddress, String password) async {
    bool createdUser = false;
    String errorMessage = '';
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      createdUser = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    return [createdUser, errorMessage];
  }

  bool _validateForm(String email, String password) {
    return email.isNotEmpty &&
        password.isNotEmpty &&
        EmailValidator.validate(email);
  }
}
