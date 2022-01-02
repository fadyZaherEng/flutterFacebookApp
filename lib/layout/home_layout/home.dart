import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/cubit.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/states.dart';
import 'package:social_firebase_app/modules/login/login.dart';
import 'package:social_firebase_app/modules/search/search_screen.dart';
import 'package:social_firebase_app/modules/upload_post/add_post_screen.dart';
import 'package:social_firebase_app/shared/components/components.dart';
import 'package:social_firebase_app/shared/network/local/cashe_helper.dart';
import 'package:social_firebase_app/shared/styles/Icon_broken.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    SocialCubit.get(context).getCurrentUser();
    WidgetsBinding.instance!.addObserver(this);
    setUserStatus('Online');
  }
  void setUserStatus(String status)async{
   await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('userStatus')
        .doc('status').set({'userStatus':status});
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state==AppLifecycleState.resumed)
      {
       setUserStatus('Online');
    //   showToast(message: 'Online', state: ToastState.SUCCESS);
      }else{
      setUserStatus(DateFormat('dd,MM yyyy hh:mm a').format(DateTime.now()));
    //  showToast(message: 'Offline', state: ToastState.SUCCESS);
    }
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Builder(builder: (context) {
            return BlocConsumer<SocialCubit, SocialStates>(
              listener: (context, state) {
                if (state is SocialBottomNavChangePostStates) {
                  navigateToWithReturn(context, UploadPostScreen());
                }
              },
              builder: (context, state) {
                var cubit = SocialCubit.get(context);
                return Scaffold(
                  appBar: AppBar(
                    titleSpacing: 7,
                    title: Text(
                      cubit.listTitles[cubit.currentIndex],
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    actions: [
                      // IconButton(
                      //   onPressed: (){},
                      //   icon: const Icon(IconBroken.Notification),
                      // ),
                      IconButton(
                        onPressed: () {
                          navigateToWithReturn(context, SearchScreen());
                        },
                        icon: const Icon(IconBroken.Search),
                      ),
                    ],
                  ),
                  body: cubit.listScreen[cubit.currentIndex],
                  bottomNavigationBar: BottomNavigationBar(
                    items: cubit.bottomNavList,
                    currentIndex: cubit.currentIndex,
                    onTap: (idx) {
                      cubit.changeNav(idx);
                    },
                    type: BottomNavigationBarType.fixed,
                  ),
                  drawer: Drawer(
                    //end drawer right w drawer left
                    child: Column(
                      children: [
                        if (cubit.profile != null)
                          UserAccountsDrawerHeader(
                            accountName: Text(
                              cubit.profile!.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                            accountEmail: Text(
                              cubit.profile!.email,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 17,
                                  color: Colors.white),
                            ),
                            currentAccountPicture: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: CircleAvatar(
                                radius: 45,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                backgroundImage: NetworkImage(
                                  cubit.profile!.defaultImage,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(cubit.profile!.cover),
                                    fit: BoxFit.cover)),
                          ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 22, bottom: 10, top: 22),
                            child: Row(
                              children: [
                                CircleAvatar(
                                    radius: 11,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child:  Icon(
                                      Icons.dark_mode_outlined,
                                      color:cubit.modeColor,
                                      size: 15,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  cubit.modeName,
                                  style: Theme.of(context).textTheme.bodyText2,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            cubit.modeChange();
                          },
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 22, bottom: 10, top: 10),
                            child: Row(
                              children: [
                                const Icon(
                                  IconBroken.Setting,
                                  size: 20,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Settings',
                                  style: Theme.of(context).textTheme.bodyText2,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            cubit.changeSettings(context);
                          },
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 22, bottom: 10, top: 10),
                            child: Row(
                              children: [
                                const Icon(
                                  IconBroken.Logout,
                                  size: 20,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'LogOut',
                                  style: Theme.of(context).textTheme.bodyText2,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            setUserStatus('${DateFormat('dd,MM yyyy hh:mm a').format(DateTime.now())}}');
                            FirebaseAuth.instance.signOut();
                            SharedHelper.remove(key: 'uid');
                            navigateToWithoutReturn(context, LogInScreen());
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          });
        });
  }
}
