import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_firebase_app/models/user_profile.dart';
import 'package:social_firebase_app/modules/register/bloc/states.dart';
import 'package:social_firebase_app/shared/components/components.dart';


class SocialAppRegisterCubit extends Cubit<SocialAppRegisterStates>
{
  var gendreController=TextEditingController();

  SocialAppRegisterCubit() : super(SocialAppRegisterInitialStates());
  static SocialAppRegisterCubit get(context)=>BlocProvider.of(context);
  Icon suffixIcon=const Icon(Icons.visibility_outlined,color: Colors.indigo,);
  bool obscure=true;
  void changeVisibilityOfEye(){
    obscure=!obscure;
    if(obscure){
      suffixIcon=Icon(Icons.remove_red_eye,color: Colors.indigo,);
    }else{
      suffixIcon=Icon(Icons.visibility_off_outlined,color: Colors.indigo,);
    }
    emit(SocialAppRegisterChangeEyeStates());
  }
  var passwordController=TextEditingController();
  var emailController=TextEditingController();
  var nameController=TextEditingController();
  var phoneController=TextEditingController();
  void signUp(){
    emit(SocialAppRegisterLoadingStates());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
    ).then((value)async {
      var x=value;
       showToast(message: 'Create Account Loading ....', state: ToastState.WARNING);
      await storeDatabaseFirestore(value.user!.uid.toString()).then((value) {
        emit(SocialAppRegisterSuccessStates(x.user!.uid.toString()));
      }).catchError((onError){
        emit(SocialAppRegisterErrorStates(onError.toString()));
      });
    }).catchError((onError){
        emit(SocialAppRegisterErrorStates(onError.toString()));
    });
  }

  Future storeDatabaseFirestore(String uid) {
    UserProfile profile=UserProfile(
        name: nameController.text,
        password: passwordController.text,
        phone: phoneController.text,
        email: emailController.text,
        uid: uid,
        bio:'write your bio...',
        gender: gendreController.text,
        cover:'https://image.freepik.com/free-vector/happy-new-year-greeting-card-design-with-fireworks_1308-37144.jpg',
        defaultImage: gendreController.text.toUpperCase()=='male'.toUpperCase()?
            'https://image.flaticon.com/icons/png/512/892/892781.png':'https://image.flaticon.com/icons/png/512/892/892770.png',
    );
    CollectionReference users = FirebaseFirestore.instance.collection('users');
   return users.doc(uid).set(profile.toMap());
  }
}
//https://image.flaticon.com/icons/png/512/892/892781.png //man
//https://image.flaticon.com/icons/png/512/892/892770.png //woman
//cover
//https://image.freepik.com/free-vector/happy-new-year-greeting-card-design-with-fireworks_1308-37144.jpg
//https://image.freepik.com/free-vector/account-concept-illustration_114360-399.jpg //register
//