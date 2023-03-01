import 'package:flutter/material.dart';
import 'package:message_encrypter/presentation/widgets/home/homeBody.dart';

import '../../../core/appRouter.dart';
import '../../../data/UserManager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const HomeBody();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!UserManager.userLoggedIn()){
      AppRouter.navigateToLogin(context);
    }
  }
}
