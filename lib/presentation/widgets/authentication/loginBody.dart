import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:message_encrypter/core/Constants.dart';
import 'package:message_encrypter/cubits/authentication/login/loginCubit.dart';
import 'package:message_encrypter/cubits/authentication/login/loginState.dart';

import '../../../core/AssetsData.dart';
import '../../../core/appRouter.dart';
import '../../../core/styles.dart';
import '../../../core/utils.dart';
import '../loading/Loading.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return const Loading();
          } else {
            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Image.asset(
                        AssetsData.login,
                        width: deviceWidth,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: "Email"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password"),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<LoginCubit>(context).authenticateUser(
                                  emailController.text,
                                  passwordController.text);
                            },
                            child: Container(
                                width: deviceWidth,
                                height: 70,
                                alignment: Alignment.center,
                                child: Text(
                                  "Login",
                                  style: Styles.kSize24,
                                )),
                          )),
                      const NoAccountRegister()
                    ],
                  ),
                ),
              ),
            );
          }
        },
        listener: (BuildContext context, Object? state) {
          if (state is LoginSuccess) {
            AppRouter.navigateToHome(context);
          } else if (state is LoginError) {
            Utils.showSnackbar(state.errorMessage, context);
          }
        },
      ),
    );
  }
}

class NoAccountRegister extends StatelessWidget {
  const NoAccountRegister({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
              text: "Don't have an Account ? ",
              style: Styles.kSize20,
            ),
            TextSpan(
              text: 'Register',
              style: Styles.kSize20.copyWith(color: Constants.kAppTheme),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  AppRouter.navigateToRegister(context);
                },
            ),
          ],
        ),
      ),
    );
  }
}
