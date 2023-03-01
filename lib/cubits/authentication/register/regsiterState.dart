abstract class RegisterState {}
class RegisterLoading extends RegisterState{}
class RegisterError extends RegisterState{
  String errorMessage;
  RegisterError({required this.errorMessage});
}
class RegisterSuccess extends RegisterState{}
class RegisterInitial extends RegisterState{}