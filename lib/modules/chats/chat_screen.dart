import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/cubit.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/states.dart';
import 'package:social_firebase_app/models/user_profile.dart';
import 'package:social_firebase_app/modules/chat_screen/open_chat.dart';
import 'package:social_firebase_app/shared/components/components.dart';


class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getAllUsers();
        return BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return ConditionalBuilder(
                condition: SocialCubit.get(context).users.isNotEmpty,
                builder:(context)=> ListView.separated(
                    itemBuilder: (context,index)=>buildItem(context,SocialCubit.get(context).users[index]),
                    separatorBuilder:(context,index)=> Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ), itemCount: SocialCubit.get(context).users.length),
                fallback: (context)=>const Center(child: CircularProgressIndicator()),
              );
            });
      }
    );
  }
}
Widget buildItem(context,UserProfile profile)
=>InkWell(
  child:Padding(
    padding: const EdgeInsets.all(20.0),
    child:   Row(
      children:
      [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              backgroundImage:  NetworkImage(profile.defaultImage),
            ),
            if(SocialCubit.get(context).usersStatus[profile.uid]=='Online')
            const CircleAvatar(
              radius: 6,
              backgroundColor: Colors.green,
            ),
          ],
        ),
        const SizedBox(width: 20,),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 7,),
            if(SocialCubit.get(context).usersStatus[profile.uid]!='Online')
            Text('Last Seen: ${SocialCubit.get(context).usersStatus[profile.uid]}',
            style: Theme.of(context).textTheme.bodyText2,)
          ],
        ),
      ],
    ),
  ),
  onTap: (){
    print(profile.uid);
    navigateToWithReturn(context, OpenChatScreen(profile));
  },
);
