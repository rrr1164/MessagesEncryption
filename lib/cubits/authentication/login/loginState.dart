abstract class LoginState {}
class LoginLoading extends LoginState{}
class LoginError extends LoginState{
  String errorMessage;
  LoginError({required this.errorMessage});
}
class LoginSuccess extends LoginState{}
class LoginInitial extends LoginState{}