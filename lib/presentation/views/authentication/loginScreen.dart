import 'package:flutter/material.dart';

import '../../widgets/authentication/loginBody.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
      child: LoginBody(),
    ));
  }
}
