import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/cubit.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/states.dart';
import 'package:social_firebase_app/models/post_model.dart';
import 'package:social_firebase_app/modules/comments/comments_screen.dart';
import 'package:social_firebase_app/shared/components/components.dart';
import 'package:social_firebase_app/shared/styles/Icon_broken.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon:const Icon(IconBroken.Arrow___Left_2),
            onPressed: (){
                Navigator.pop(context);
            },
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  maxLines: 1000,
                  minLines: 1,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(IconBroken.Search),
                    label: const Text('Search'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {
                    SocialCubit.get(context).searchPost(val);
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => buildItem(
                        SocialCubit.get(context).searchPosts[index],
                        context,
                        state,
                        index),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: SocialCubit.get(context).searchPosts.length),
              )
            ],
          ),
        );
      },
    );
  }
  Widget buildItem(PostModel model, context, state, index) => Card(
        margin: const EdgeInsetsDirectional.all(7),
        clipBehavior: Clip.antiAlias,
        elevation: 15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundImage: NetworkImage(model.userImage),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          model.name,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        // IconButton(
                        //     onPressed: () {},
                        //     icon: const Icon(
                        //       Icons.check_circle,
                        //       size: 17,
                        //     )),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Align(
                      child: Text(
                        model.dateTime,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      alignment: Alignment.topCenter,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  alignment: Alignment.bottomCenter,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        title: Text(
                          'Delete Post',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        content: Text(
                          'Are You Sure ?',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        actions: [
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    SocialCubit.get(context).deletePost(
                                        postId: SocialCubit.get(context)
                                            .postsId[index]);
                                  },
                                  child: Text(
                                    'Confirm',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 16,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3),
              child: Container(
                color: Colors.grey,
                width: double.infinity,
                height: 0.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              child: Text(
                model.text,
                style: Theme.of(context).textTheme.bodyText2,
                // overflow: TextOverflow.ellipsis,
                // maxLines: 4,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            if(model.hashtag!=null)
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  children: [
                    SizedBox(
                      height: 20,
                      child: MaterialButton(
                        onPressed: () {},
                        minWidth: 1,
                        padding: EdgeInsets.zero,
                        child:  Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                             model.hashtag,
                            style: const TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (model.postImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                child: Image(
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.fitWidth,
                    image: NetworkImage(model.postImage)),
              ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Container(
                        height: 35,
                        child: Row(
                          children: [
                            const Icon(
                              IconBroken.Heart,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              SocialCubit.get(context)
                                  .postsNumberLikes[
                                      SocialCubit.get(context).postsId[index]]
                                  .toString(),
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: Container(
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              IconBroken.Chat,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              '${SocialCubit.get(context).postComments[SocialCubit.get(context).postsId[index]]!.length} Comment',
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3),
              child: Container(
                color: Colors.grey,
                width: double.infinity,
                height: 0.5,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(children: [
              Expanded(
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'write a comment...',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  onTap: () {
                    navigateToWithReturn(
                        context,
                        CommentsScreen(
                            SocialCubit.get(context).postsId[index]));
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 5, top: 5, bottom: 5),
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          'Love',
                          style: Theme.of(context).textTheme.bodyText2,
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    SocialCubit.get(context)
                        .addPostLikes(SocialCubit.get(context).postsId[index]);
                  },
                ),
              ),
            ]),
          ],
        ),
      );
}
