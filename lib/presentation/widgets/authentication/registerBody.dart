import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:message_encrypter/core/utils.dart';
import 'package:message_encrypter/presentation/widgets/loading/Loading.dart';

import '../../../core/AssetsData.dart';
import '../../../core/Constants.dart';
import '../../../core/appRouter.dart';
import '../../../core/styles.dart';
import '../../../cubits/authentication/register/registerCubit.dart';
import '../../../cubits/authentication/register/regsiterState.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({Key? key}) : super(key: key);

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        builder: (context, state) {
          if (state is RegisterLoading) {
            return const Loading();
          } else {
            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Image.asset(
                        AssetsData.register,
                        width: deviceWidth,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          enableSuggestions: true,
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
                              BlocProvider.of<RegisterCubit>(context).addUser(
                                  emailController.text,
                                  passwordController.text);
                            },
                            child: Container(
                                width: deviceWidth,
                                height: 70,
                                alignment: Alignment.center,
                                child: Text(
                                  "Register",
                                  style: Styles.kSize24,
                                )),
                          )),
                      const HasAccountLogin()
                    ],
                  ),
                ),
              ),
            );
          }
        },
        listener: (BuildContext context, Object? state) {
          if (state is RegisterSuccess) {
            AppRouter.navigateToHome(context);
          } else if (state is RegisterError) {
            Utils.showSnackbar(state.errorMessage, context);
          }
        },
      ),
    );
  }
}

class HasAccountLogin extends StatelessWidget {
  const HasAccountLogin({
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
              text: "Already have an Account ? ",
              style: Styles.kSize20,
            ),
            TextSpan(
              text: 'Login',
              style: Styles.kSize20.copyWith(color: Constants.kAppTheme),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  AppRouter.navigateToLogin(context);
                },
            ),
          ],
        ),
      ),
    );
  }
}
