import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/cubit.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/states.dart';
import 'package:social_firebase_app/models/postComment.dart';
import 'package:social_firebase_app/shared/styles/Icon_broken.dart';

class CommentsScreen extends StatelessWidget {
  var commentController = TextEditingController();
  String postId;
  var scrollController = ScrollController();
  var keyComment = GlobalKey<FormState>();

  CommentsScreen(this.postId);

  @override
  Widget build(BuildContext context) {
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                buildPar(context),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: keyComment,
                child: Column(
                  children: [
                    ConditionalBuilder(
                      condition: SocialCubit.get(context)
                          .postComments[postId]!
                          .isNotEmpty,
                      builder: (context) => Expanded(
                        child: ListView.separated(
                            controller: scrollController,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => buildCommentItems(context,
                                SocialCubit.get(context).postComments[postId]![index]),
                               separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10,
                                ),
                            itemCount: SocialCubit.get(context)
                                .postComments[postId]!
                                .length),
                      ),
                      fallback: (context) => Expanded(
                        child: Center(
                          child: Text(
                            'No Comments Until Now...',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildBottom(postId, context),
                  ],
                ),
              ),
            ),
          );
        },
      );
  }

  buildCommentItems(context, PostComments postComments)=> Dismissible(
        key: UniqueKey(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: AlignmentDirectional.topStart,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                backgroundImage: NetworkImage(postComments.userImage),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsetsDirectional.only(
                    start: 5, end: 5, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(20),
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      postComments.username,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      postComments.comment,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 5,
                  end: 5,
                ),
                child: Text(
                  getTime(postComments.dateTime),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            )
          ],
        ),
        onDismissed: (direction) {
          SocialCubit.get(context).deleteComment(
            name: postComments.username,
            text: postComments.comment,
            time: postComments.dateTime,
            postId: postId,
          );
        },
      );
  buildPar(BuildContext context) => TextButton(
        onPressed: () {},
        child: Row(
          children: [
            const Icon(
              IconBroken.Heart,
              color: Colors.red,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'Like',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      );
  buildBottom(String postId, context) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.grey[100],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  maxLines: 1000,
                  minLines: 1,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'comment must not be empty';
                    }
                    return null;
                  },
                  controller: commentController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'write comment...',
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: MaterialButton(
                  height: 50,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (keyComment.currentState!.validate()) {
                      SocialCubit.get(context).addPostComments(
                          postId, commentController.text, context);
                      commentController.text = '';
                      if (SocialCubit.get(context)
                              .postComments[postId]!
                              .length >
                          1) {
                        scrollController.jumpTo(scrollController.position.maxScrollExtent);
                      }
                    }
                  },
                  child: Icon(
                    IconBroken.Send,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    size: 25,
                  )),
            ),
          ],
        ),
      );
  String getTime(dateTime) {
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
    } else if (differenceHours < 24) {
      return '$differenceHours h';
    } else if (differenceDays < 30) {
      return '$differenceDays day';
    } else if (differenceDays > 30 && differenceDays <= 365) {
      return '${differenceDays / 30} month';
    } else {
      return '${differenceDays / 365} year';
    }
  }
}
