import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/cubit.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/states.dart';
import 'package:social_firebase_app/shared/styles/Icon_broken.dart';

class UploadPostScreen extends StatelessWidget {
  var postController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  dynamic imagePostUrl;

  var hashtagController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(IconBroken.Arrow___Left_2),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Create Post',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            actions: [
              state is SocialPostCreatedImageLoadingStates
                  ? const Center(
                      child: SizedBox(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: LinearProgressIndicator(),
                      ),
                      width: 45,
                    ))
                  : TextButton(
                      onPressed: () {
                        if (state is SocialPostUploadImageSuccessStates) {
                          imagePostUrl = state.imageUrl;
                        }
                        if (formKey.currentState!.validate()) {
                          SocialCubit.get(context).createPost(
                            context: context,
                              text: postController.text,
                              dateTime: DateFormat('dd,MM yyyy hh:mm a')
                                  .format(DateTime.now())
                                  .toString(),
                              postImage: imagePostUrl,
                             hashtag: hashtagController.text==''?null:hashtagController.text,
                          );

                        }
                      },
                      child: const Text(
                        'POST',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      )),
            ],
          ),
          body: ConditionalBuilder(
            condition:SocialCubit.get(context).profile!=null,
            builder: (context)=> SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                            backgroundImage:  NetworkImage(
                                SocialCubit.get(context).profile!.defaultImage),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            SocialCubit.get(context).profile!.name,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: SocialCubit.get(context).heightImageAddPost,
                        child: TextFormField(
                          controller: postController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'text must not be empty';
                            }
                            return null;
                          },
                          maxLines:1000000,
                          minLines: 1,
                          //  expands: true,
                          decoration: const InputDecoration(
                            hintText: 'what is on your mind...',
                            border: InputBorder.none,
                          ),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (SocialCubit.get(context).postImage != null &&
                          state is! SocialPostCreatedImageLoadingStates)
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Image.file(
                              File(SocialCubit.get(context).postImage!.path),
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                child: const CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  radius: 15,
                                  child: Icon(Icons.close),
                                ),
                                onTap: () {
                                  SocialCubit.get(context).closeImage();
                                },
                              ),
                            ),
                          ],
                        ),
                      if (state is SocialPostCreatedImageLoadingStates)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: LinearProgressIndicator()),
                        ),
                      Row(
                        children:
                        [
                          Expanded(
                            child: TextButton(
                                onPressed: () {
                                  SocialCubit.get(context).getPostImage();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      IconBroken.Image,
                                      color: Colors.blueAccent,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'add photos',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent),
                                    ),
                                  ],
                                )),
                          ),
                          Expanded(
                            child: TextButton(
                                onPressed: () {
                                  showDialog(context: context,
                                      builder:(context)=>AlertDialog(
                                        title: Text('Add Hash Tag',style: Theme.of(context).textTheme.bodyText1,),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children:
                                          [
                                            TextFormField(
                                              controller: hashtagController,
                                              keyboardType: TextInputType.text,
                                            ),
                                            TextButton(onPressed: (){
                                              Navigator.pop(context);
                                            }, child: Text('Done',style: Theme.of(context).textTheme.bodyText1,))
                                          ],
                                        ),
                                      ),
                                  );
                                },
                                child: const Text(
                                  '# tags',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            fallback: (context)=>const Center(child:  CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
