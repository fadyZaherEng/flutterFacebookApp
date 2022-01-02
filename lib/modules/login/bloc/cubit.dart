import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_firebase_app/modules/login/bloc/states.dart';


class SocialAppLoginCubit extends Cubit<SocialAppLogInStates>{
  SocialAppLoginCubit() : super(SocialAppLogInInitialStates());

  static SocialAppLoginCubit get(context)=>BlocProvider.of(context);

  void LogIn({
  required String email,
  required String password,
}){
    emit(SocialAppLogInLoadingStates());
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email:email,
      password:password,
    ).then((value) {
      emit(SocialAppLogInSuccessStates(value.user!.uid));
      print(value.user!.email);
    }).catchError((onError){
      emit(SocialAppLogInErrorStates(onError.toString()));
    });
  }
  Icon suffixIcon=const Icon(Icons.visibility_outlined,color: Colors.indigo,);
  bool obscure=true;
  void changeVisibilityOfEye(){
    obscure=!obscure;
    if(obscure){
      suffixIcon=Icon(Icons.remove_red_eye,color: Colors.indigo,);
    }else{
      suffixIcon=Icon(Icons.visibility_off_outlined,color: Colors.indigo,);
    }
    emit(SocialAppLogInChangeEyeStates());
  }


}