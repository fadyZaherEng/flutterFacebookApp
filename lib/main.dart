import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/cubit.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/states.dart';
import 'package:social_firebase_app/layout/home_layout/home.dart';
import 'package:social_firebase_app/modules/chat_screen/open_chat.dart';
import 'package:social_firebase_app/modules/comments/comments_screen.dart';
import 'package:social_firebase_app/modules/login/login.dart';
import 'package:social_firebase_app/modules/splash/splash_screen.dart';
import 'package:social_firebase_app/shared/components/components.dart';
import 'package:social_firebase_app/shared/network/local/cashe_helper.dart';
import 'package:social_firebase_app/shared/styles/themes.dart';

import 'bloc_observer/observer.dart';
Future<void> firebaseMassageBackground(RemoteMessage message)async{
  print(message.data.toString());
  showToast(message: 'onMassageFirebaseMassageBackground', state: ToastState.SUCCESS);
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  await SharedHelper.init();
  var token =await FirebaseMessaging.instance.getToken();
  print(token);
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
    showToast(message: 'onMassage', state: ToastState.SUCCESS);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    showToast(message: 'onMessageOpenedApp', state: ToastState.SUCCESS);
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMassageBackground);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create:(context)=>SocialCubit()..getPosts()..getLikes()..getPostComments()),
        ],
        child: BlocConsumer<SocialCubit,SocialStates>(
          listener: (context,state){},
          builder: (context,state){
            return Sizer(
              builder:(a,b,c)=> Directionality(
                textDirection: TextDirection.ltr,
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  darkTheme: darkTheme(),
                  theme: lightTheme(),
                  themeMode:SocialCubit.get(context).modeType,
                  home:startScreen(),
                ),
              ),
            );
          },
        ));
  }

 Widget startScreen()
 {
   if(SharedHelper.get(key: 'uid')!=null) {
     return SplashScreen('home');
   }
   return SplashScreen('login');
 }
}
