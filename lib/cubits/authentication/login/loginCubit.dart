import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'loginState.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> authenticateUser(String email, String password) async {
    emit(LoginLoading());

    String errorMessage = '';

    if (_validateForm(email, password)) {
      List userValidated = await _validateUser(email, password);
      if (userValidated[0] == true) {
        emit(LoginSuccess());
      }
      else {
        errorMessage = userValidated[1];
        emit(LoginError(errorMessage: errorMessage));
      }
    }
    else {
      errorMessage = "error validating form";
      emit(LoginError(errorMessage: errorMessage));
    }
  }

  bool _validateForm(String email, String password) {
    return email.isNotEmpty &&
        password.isNotEmpty &&
        EmailValidator.validate(email);
  }

  Future<List> _validateUser(String emailAddress, String password) async {
    bool validated = false;
    String errorMessage = '';
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      validated = true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message.toString();
    }
    return [validated, errorMessage];
  }
}
