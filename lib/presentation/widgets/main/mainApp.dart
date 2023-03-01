import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/Constants.dart';
import '../../../core/appRouter.dart';
import '../../../cubits/main/initiationCubit.dart';
import '../../../cubits/main/initiationState.dart';
import '../loading/Loading.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InitCubit(),
      child: BlocBuilder<InitCubit, InitiationState>(
        builder: (BuildContext context, state) {
          if (state is InitiationLoading) {
            return const Loading();
          } else if (state is InitiationError) {
            return const Scaffold(
              body: Center(child: Text("An Error Occurred,please make sure you're connected to the internet")),
            );
          } else {
            return MaterialApp.router(
              theme: ThemeData.light().copyWith(
                  textTheme:
                      GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
                  colorScheme: ColorScheme.fromSwatch()
                      .copyWith(primary: Constants.kAppTheme)),
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
            );
          }
        },
      ),
    );
  }
}
