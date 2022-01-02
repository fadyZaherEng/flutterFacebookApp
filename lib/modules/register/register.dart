import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_firebase_app/layout/home_layout/home.dart';
import 'package:social_firebase_app/shared/components/components.dart';
import 'package:social_firebase_app/shared/network/local/cashe_helper.dart';
import 'bloc/cubit.dart';
import 'bloc/states.dart';


class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialAppRegisterCubit(),
      child: BlocConsumer<SocialAppRegisterCubit, SocialAppRegisterStates>(
        listener: (context, state) {
          if (state is SocialAppRegisterSuccessStates) {
            showToast(message: 'Create Account Successfully', state: ToastState.SUCCESS);
            SharedHelper.save(value:state.uid , key:'uid');
            navigateToWithoutReturn(context, HomeScreen());
          }
          if (state is SocialAppRegisterErrorStates) {
            showToast(message: state.error.toString(), state: ToastState.ERROR);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                      CircleAvatar(
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          radius: 90.0,
                          backgroundImage:const NetworkImage('https://image.freepik.com/free-vector/account-concept-illustration_114360-399.jpg')
                      ),
                        // GestureDetector(
                        //   onTap: () async {
                        //     var image = await ImagePicker()
                        //         .pickImage(source: ImageSource.gallery);
                        //     SocialAppRegisterCubit.get(context).resImage = image;
                        //     SocialAppRegisterCubit.get(context).changeImage();
                        //   },
                        //   child: CircleAvatar(
                        //     backgroundColor: Colors.white,
                        //     radius: 55.0,
                        //     backgroundImage:
                        //         SocialAppRegisterCubit.get(context).defaultImage,
                        //     child: SocialAppRegisterCubit.get(context).resImage ==
                        //             null
                        //         ? null
                        //         : Container(
                        //       clipBehavior: Clip.antiAlias,
                        //       decoration: BoxDecoration(
                        //
                        //         borderRadius: BorderRadius.all(Radius.circular(55)),
                        //       ),
                        //           child: Image.file(File(
                        //               SocialAppRegisterCubit.get(context)
                        //                   .resImage!
                        //                   .path),width: 110,height: 110,fit: BoxFit.cover,),
                        //         ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultTextForm(
                          context: context,
                            onChanged: () {},
                            type: TextInputType.text,
                            Controller: SocialAppRegisterCubit.get(context)
                                .nameController,
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.indigo,
                            ),
                            text: 'Name',
                            validate: (val) {
                              if (val.toString().isEmpty) {
                                return 'Please Enter Your Username';
                              }
                            },
                            onSubmitted: () {}),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextForm(
                            context: context,
                            onChanged: () {},
                            type: TextInputType.emailAddress,
                            Controller: SocialAppRegisterCubit.get(context)
                                .emailController,
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.indigo,
                            ),
                            text: 'Email',
                            validate: (val) {
                              if (val.toString().isEmpty) {
                                return 'Please Enter Your Email Address';
                              }
                            },
                            onSubmitted: () {}),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextForm(
                            context: context,
                            onChanged: () {},
                            type: TextInputType.phone,
                            Controller: SocialAppRegisterCubit.get(context)
                                .phoneController,
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Colors.indigo,
                            ),
                            text: 'Phone',
                            validate: (val) {
                              if (val.toString().isEmpty) {
                                return 'Please Enter Your Phone';
                              }
                            },
                            onSubmitted: () {}),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextForm(
                            context: context,
                            onChanged: () {},
                            type: TextInputType.text,
                            Controller: SocialAppRegisterCubit.get(context)
                                .gendreController,
                            prefixIcon: const Icon(
                              Icons.transgender_outlined,
                              color: Colors.indigo,
                            ),
                            text: 'Gender',
                            validate: (val) {
                              if (val.toString().isEmpty) {
                                return 'Please Enter Your Gender';
                              }
                            },
                            onSubmitted: () {}),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextForm(
                          context: context,
                          onChanged: () {},
                          type: TextInputType.visiblePassword,
                          Controller: SocialAppRegisterCubit.get(context)
                              .passwordController,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.indigo,
                          ),
                          text: 'Password',
                          validate: (val) {
                            if (val.toString().isEmpty) {
                              return 'Password is Very Short';
                            }
                          },
                          obscure: SocialAppRegisterCubit.get(context).obscure,
                          onSubmitted: () {},
                          suffixIcon: IconButton(
                              onPressed: () {
                                SocialAppRegisterCubit.get(context)
                                    .changeVisibilityOfEye();
                              },
                              icon:
                                  SocialAppRegisterCubit.get(context).suffixIcon),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        MaterialButton(
                          height: 50,
                          minWidth: double.infinity,
                          onPressed: () {  //register
                            if (formKey.currentState!.validate()) {
                              SocialAppRegisterCubit.get(context).signUp();
                              FocusScope.of(context).unfocus();
                            }
                          },
                          color:HexColor('180040'),
                          child: const Text(
                            'REGISTER NOW',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
