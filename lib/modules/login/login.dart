import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_firebase_app/layout/home_layout/home.dart';
import 'package:social_firebase_app/modules/register/register.dart';
import 'package:social_firebase_app/shared/components/components.dart';
import 'package:social_firebase_app/shared/network/local/cashe_helper.dart';

import 'bloc/cubit.dart';
import 'bloc/states.dart';


class LogInScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialAppLoginCubit(),
      child: BlocConsumer<SocialAppLoginCubit, SocialAppLogInStates>(
        listener: (context, state) {
          if (state is SocialAppLogInSuccessStates) {
            showToast(message: 'Logged Successfully', state: ToastState.SUCCESS);
            SharedHelper.save(value:state.uid , key:'uid');
            navigateToWithoutReturn(context, HomeScreen());
          }
          if (state is SocialAppLogInErrorStates) {
            showToast(message: state.error.toString(), state: ToastState.ERROR);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
                child: Center(
                    child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                      CircleAvatar(
                      radius: 100,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      backgroundImage: AssetImage('assets/images/chat.jpg'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    defaultTextForm(
                        context: context,
                        type: TextInputType.emailAddress,
                        Controller: emailController,
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.indigo,
                        ),
                        onChanged: (){},
                        text: 'Email',
                        validate: (val) {
                          if (val.toString().isEmpty) {
                            return 'Please Enter Your Email Address';
                          }
                        },
                        onSubmitted: () {}),
                    const SizedBox(
                      height: 30,
                    ),
                    defaultTextForm(
                      context: context,
                      onChanged: (){},
                      type: TextInputType.visiblePassword,
                      Controller: passwordController,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.indigo,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            SocialAppLoginCubit.get(context)
                                .changeVisibilityOfEye();
                          },
                          icon: SocialAppLoginCubit.get(context).suffixIcon),
                      text: 'Password',
                      validate: (val) {
                        if (val.toString().isEmpty) {
                          return 'Password is Very Short';
                        }
                      },
                      obscure: SocialAppLoginCubit.get(context).obscure,
                      onSubmitted: () {},
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ConditionalBuilder(
                      condition: state is! SocialAppLogInLoadingStates,
                      builder: (context) => MaterialButton(
                        height: 50,
                        minWidth: double.infinity,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            //log in
                            SocialAppLoginCubit.get(context).LogIn(
                                email: emailController.text,
                                password: passwordController.text);
                            FocusScope.of(context).unfocus();
                          }
                        },
                        color:HexColor('180040'),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      fallback: (context) => const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.indigo),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(
                          'Don\'t have an account?',
                          style: Theme.of(context).textTheme.bodyText1
                        ),
                        TextButton(
                          onPressed: () {
                            navigateToWithReturn(context, RegisterScreen());
                          },
                          child: Text(
                            'REGISTER',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ))),
          );
        },
      ),
    );
  }
}
