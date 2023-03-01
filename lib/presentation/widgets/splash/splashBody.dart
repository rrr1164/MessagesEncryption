import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/Constants.dart';
import '../../../core/appRouter.dart';
import '../../../core/styles.dart';
import '../../../data/UserManager.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({Key? key}) : super(key: key);

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock,
            size: 72,
            color: Constants.kAppTheme,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(Constants.kAppName, style: Styles.kSize20))
        ],
      ),
    ));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(seconds: 2))
          .whenComplete(() => navigateToScreen(UserManager.userLoggedIn()));
    });
  }
  void navigateToScreen(bool isUserLoggedIn) {
    if (isUserLoggedIn) {
      AppRouter.navigateToHome(context);
    } else {
      AppRouter.navigateToLogin(context);
    }
  }
}
