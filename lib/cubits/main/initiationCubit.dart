
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'initiationState.dart';

class InitCubit extends Cubit<InitiationState>{
  InitCubit() : super(InitiationLoading()) {
    init_app();
  }
  Future<void> init_app() async {
    emit(InitiationLoading());
    print("initiating app");
    try{
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();

      emit(InitiationSuccess());
    }
    catch (e){
      print("exception: $e");
      emit(InitiationError());
    }
  }
}