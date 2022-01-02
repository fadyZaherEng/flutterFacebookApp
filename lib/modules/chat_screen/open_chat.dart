import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/cubit.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/states.dart';
import 'package:social_firebase_app/models/massage_model.dart';
import 'package:social_firebase_app/models/user_profile.dart';
import 'package:social_firebase_app/shared/styles/Icon_broken.dart';

class OpenChatScreen extends StatelessWidget {
  UserProfile? receiverProfile;

  var textController = TextEditingController();
  var scrollController = ScrollController();
  OpenChatScreen(this.receiverProfile);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      //equal on start android
     SocialCubit.get(context).getMassage(receiverId: receiverProfile!.uid);
      return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {}
      , builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(IconBroken.Arrow___Left_2)),
              titleSpacing: 0,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      backgroundImage:
                          NetworkImage(receiverProfile!.defaultImage),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          receiverProfile!.name,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          SocialCubit.get(context).usersStatus[receiverProfile!.uid]=='Online'?'Online':'Offline',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsetsDirectional.only(
                  top: 20, start: 20, end: 20, bottom: 8),
              child: Column(
                children:
                 [
                  if(SocialCubit.get(context).massages.isNotEmpty)
                  ConditionalBuilder(
                      condition: SocialCubit.get(context).massages.isNotEmpty,
                      builder: (context) => Expanded(
                            child: ListView.separated(
                                controller: scrollController,
                                itemBuilder: (context, index) {
                                  var massage =SocialCubit.get(context).massages[index];
                                  if(massage.text!=''){
                                    if (SocialCubit.get(context).profile!.uid == massage.senderId) {
                                      return buildSenderMassage(massage, context,index);
                                    }
                                    else {
                                      return buildReceiverMassage(massage, context,index);
                                    }
                                  }
                                  else{
                                    if (SocialCubit.get(context).profile!.uid == massage.senderId) {
                                      return buildSenderImageMassage(massage, context,index);
                                    }
                                    else {
                                      return buildReceiverImageMassage(massage, context,index);
                                    }
                                  }
                                },
                                separatorBuilder: (context, index) => const SizedBox(
                                      height: 15,
                                    ),
                                itemCount: SocialCubit.get(context).massages.length),
                          ),
                      fallback: (context) => Expanded(
                              child: Center(
                                  child: Text(
                            'No Massages',
                            style: Theme.of(context).textTheme.bodyText2,
                          )))),
                  if(SocialCubit.get(context).massages.isEmpty)
                  const Spacer(),
                  buildBottom(context,state),
                ],
              ),
            ));
      });
    });
  }
  Widget buildSenderImageMassage(MassageModel massageModel, context,index)=> InkWell(
    child: Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Image(
        image:NetworkImage(massageModel.image),
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      ),
    ),
    onTap: (){
      showDialog(
        barrierDismissible: false,//prevent close
        context: context,
        builder:(context)=> AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Delete Massage',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
            [
              TextButton(onPressed: (){
                showDialog(
                  context: context,
                  builder:(context)=> AlertDialog(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Text(
                      'Delete Massage',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    content: Text(
                      'Are You Sure ?',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    actions:
                    [
                      Row(
                        children:
                        [
                          Expanded(
                            child: TextButton(onPressed: (){
                              SocialCubit.get(context).deleteMassageFromMe(
                                  receiverId: receiverProfile!.uid,
                                  massageId: SocialCubit.get(context).massagesId[index]);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text(
                              'Confirm',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(onPressed: (){
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }, child: Text('Delete Massage From Me',style: Theme.of(context).textTheme.bodyText2,)),
              const SizedBox(height: 6,),
              TextButton(onPressed: (){
                showDialog(
                  context: context,
                  builder:(context)=> AlertDialog(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Text(
                      'Delete Massage',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    content: Text(
                      'Are You Sure ?',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    actions:
                    [
                      Row(
                        children:
                        [
                          Expanded(
                            child: TextButton(onPressed: (){
                              SocialCubit.get(context).deleteMassageFromAll(
                                  receiverId: receiverProfile!.uid,
                                  massageId: SocialCubit.get(context).massagesId[index]);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text(
                              'Confirm',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(onPressed: (){
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }, child: Text('Delete Massage From All',style: Theme.of(context).textTheme.bodyText2,)),
            ],
          ),
        ),
      );
    },
  );
  Widget buildReceiverImageMassage(MassageModel massageModel, context,index)=> InkWell(
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child:Image(
        image:NetworkImage(massageModel.image),
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      ),

    ),
    onTap: (){
      showDialog(
        barrierDismissible: false,//prevent close
        context: context,
        builder:(context)=> AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Delete Massage',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
            [
              TextButton(onPressed: (){
                showDialog(
                  context: context,
                  builder:(context)=> AlertDialog(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Text(
                      'Delete Massage',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    content: Text(
                      'Are You Sure ?',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    actions:
                    [
                      Row(
                        children:
                        [
                          Expanded(
                            child: TextButton(onPressed: (){
                              SocialCubit.get(context).deleteMassageFromMe(
                                  receiverId: receiverProfile!.uid,
                                  massageId: SocialCubit.get(context).massagesId[index]);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text(
                              'Confirm',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(onPressed: (){
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }, child: Text('Delete Massage From Me',style: Theme.of(context).textTheme.bodyText2,)),
              const SizedBox(height: 6,),
              TextButton(onPressed: (){
                showDialog(
                  context: context,
                  builder:(context)=> AlertDialog(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Text(
                      'Delete Massage',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    content: Text(
                      'Are You Sure ?',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    actions:
                    [
                      Row(
                        children:
                        [
                          Expanded(
                            child: TextButton(onPressed: (){
                              SocialCubit.get(context).deleteMassageFromAll(
                                  receiverId: receiverProfile!.uid,
                                  massageId: SocialCubit.get(context).massagesId[index]);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text(
                              'Confirm',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(onPressed: (){
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }, child: Text('Delete Massage From All',style: Theme.of(context).textTheme.bodyText2,)),
            ],
          ),
        ),
      );
    },
  );
  Widget buildSenderMassage(MassageModel massageModel, context,index) => InkWell(
    child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 5,
                    end: 5,
                  ),
                  child: Text(
                    getTime(massageModel.dateTime),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    borderRadius: const BorderRadiusDirectional.only(
                      topStart: Radius.circular(10),
                      topEnd: Radius.circular(10),
                      bottomStart: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    massageModel.text,
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: 1000,
                    softWrap: true,
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                backgroundImage:
                    NetworkImage(SocialCubit.get(context).profile!.defaultImage),
              ),
            ],
          ),
        ),
    onTap: (){
      showDialog(
        barrierDismissible: false,//prevent close
        context: context,
        builder:(context)=> AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Delete Massage',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
            [
              TextButton(onPressed: (){
                showDialog(
                  context: context,
                  builder:(context)=> AlertDialog(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Text(
                      'Delete Massage',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    content: Text(
                      'Are You Sure ?',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    actions:
                    [
                      Row(
                        children:
                        [
                          Expanded(
                            child: TextButton(onPressed: (){
                              SocialCubit.get(context).deleteMassageFromMe(
                                  receiverId: receiverProfile!.uid,
                                  massageId: SocialCubit.get(context).massagesId[index]);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text(
                              'Confirm',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(onPressed: (){
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }, child: Text('Delete Massage From Me',style: Theme.of(context).textTheme.bodyText2,)),
              const SizedBox(height: 6,),
              TextButton(onPressed: (){
                showDialog(
                  context: context,
                  builder:(context)=> AlertDialog(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Text(
                      'Delete Massage',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    content: Text(
                      'Are You Sure ?',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    actions:
                    [
                      Row(
                        children:
                        [
                          Expanded(
                            child: TextButton(onPressed: (){
                              SocialCubit.get(context).deleteMassageFromAll(
                                  receiverId: receiverProfile!.uid,
                                  massageId: SocialCubit.get(context).massagesId[index]);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text(
                              'Confirm',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(onPressed: (){
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }, child: Text('Delete Massage From All',style: Theme.of(context).textTheme.bodyText2,)),
            ],
          ),
        ),
      );
    },
  );
  Widget buildReceiverMassage(MassageModel massageModel, context,index) => InkWell(
    child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                backgroundImage: NetworkImage(receiverProfile!.defaultImage),
              ),
              const SizedBox(
                width: 4,
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadiusDirectional.only(
                      topStart: Radius.circular(10),
                      topEnd: Radius.circular(10),
                      bottomEnd: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    massageModel.text,
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: 1000,
                    softWrap: true,
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 5,
                    end: 5,
                  ),
                  child: Text(
                    getTime(massageModel.dateTime),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
            ],
          ),
        ),
    onTap: (){
      showDialog(
        barrierDismissible: false,//prevent close
        context: context,
        builder:(context)=> AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Delete Massage',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
            [
              TextButton(onPressed: (){
                showDialog(
                  context: context,
                  builder:(context)=> AlertDialog(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Text(
                      'Delete Massage',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    content: Text(
                      'Are You Sure ?',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    actions:
                    [
                      Row(
                        children:
                        [
                          Expanded(
                            child: TextButton(onPressed: (){
                              SocialCubit.get(context).deleteMassageFromMe(
                                  receiverId: receiverProfile!.uid,
                                  massageId: SocialCubit.get(context).massagesId[index]);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text(
                              'Confirm',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(onPressed: (){
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }, child: Text('Delete Massage From Me',style: Theme.of(context).textTheme.bodyText2,)),
              const SizedBox(height: 6,),
              TextButton(onPressed: (){
                showDialog(
                  context: context,
                  builder:(context)=> AlertDialog(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Text(
                      'Delete Massage',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    content: Text(
                      'Are You Sure ?',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    actions:
                    [
                      Row(
                        children:
                        [
                          Expanded(
                            child: TextButton(onPressed: (){
                              SocialCubit.get(context).deleteMassageFromAll(
                                  receiverId: receiverProfile!.uid,
                                  massageId: SocialCubit.get(context).massagesId[index]);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text(
                              'Confirm',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(onPressed: (){
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }, child: Text('Delete Massage From All',style: Theme.of(context).textTheme.bodyText2,)),
            ],
          ),
        ),
      );
    },
  );
  buildBottom(context,state) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.grey[100],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                maxLines: 1000,
                minLines: 1,
                validator: (val) {
                  if (val!.isEmpty) {
                    return '';
                  }
                  return null;
                },
                controller: textController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'write here your massage...',
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
            if(state is SocialChatUploadImageLoadingSuccessStates)
             const CircularProgressIndicator(),
            if(state is ! SocialChatUploadImageLoadingSuccessStates)
              IconButton(onPressed: () {
              SocialCubit.get(context).getChatImage(
                receiverId: receiverProfile!.uid,
                dateTime: DateTime.now().toString(),
                text: textController.text,
              );
              scrollController.jumpTo(scrollController.position.maxScrollExtent);
             }, icon: const Icon(IconBroken.Camera)
            ),
            MaterialButton(
                height: 50,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (textController.text != '') {
                    SocialCubit.get(context).addMassage(
                        receiverId: receiverProfile!.uid,
                        text: textController.text,
                        dateTime: DateTime.now().toString());
                    textController.text = '';
                    scrollController.jumpTo(scrollController.position.maxScrollExtent);
                  }
                },
                child: Icon(
                  IconBroken.Send,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  size: 25,
                )),
          ],
        ),
      );
  String getTime(dateTime) {
    print( DateFormat('dd,MM yyyy hh:mm a').format(DateTime.parse(dateTime)));
    DateTime lastTime = DateTime.parse(dateTime);
    DateTime currentTime = DateTime.now();
    int differenceMinutes = currentTime.difference(lastTime).inMinutes;
    int differenceHours = currentTime.difference(lastTime).inHours;
    int differenceDays = currentTime.difference(lastTime).inDays;
    if (differenceMinutes < 60) {
      if(differenceMinutes==0){
        return 'now';
      }
      return '$differenceMinutes m';
    }
    else if (differenceHours < 24) {
      return '$differenceHours h';
    }
    else if (differenceDays < 30) {
      return DateFormat('dd,MM yyyy hh:mm a').format(DateTime.parse(dateTime));
    }
    else if (differenceDays > 30 && differenceDays <= 365) {
      return DateFormat('dd,MM yyyy hh:mm a').format(DateTime.parse(dateTime));//'${differenceDays / 30} month';
    }
    else {
      return DateFormat('dd,MM yyyy hh:mm a').format(DateTime.parse(dateTime));// '${differenceDays / 365} year';
    }
  }
}
