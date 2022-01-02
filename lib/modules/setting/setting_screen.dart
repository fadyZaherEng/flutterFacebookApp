import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/cubit.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/states.dart';
import 'package:social_firebase_app/modules/edit_profile/edit_prifle_screen.dart';
import 'package:social_firebase_app/shared/components/components.dart';
import 'package:social_firebase_app/shared/styles/Icon_broken.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getCurrentUserPosts();
        return BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {
              if(state is SocialSuccessStates)
                {

                }
            },
            builder: (context, state) {
              return ConditionalBuilder(
                condition: SocialCubit.get(context).profile!=null,
                builder:(context)=> Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        height: 210,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                             Align(
                              child: Image(
                                fit: BoxFit.fitWidth,
                                height: 150,
                                width: double.infinity,
                                image: NetworkImage(
                                 '${SocialCubit.get(context).profile!.cover}'
                                ) ),
                              alignment: Alignment.topCenter,
                            ),
                            CircleAvatar(
                              radius: 64,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                backgroundImage: NetworkImage(
                                    '${SocialCubit.get(context).profile!.defaultImage}'),
                                radius: 60,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${SocialCubit.get(context).profile!.name}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${SocialCubit.get(context).profile!.bio}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              child: Column(
                                children: [
                                  Text(
                                    SocialCubit.get(context).postsNumber.toString(),
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    'Posts',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              child: Column(
                                children: [
                                  Text(
                                    '426',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    'Photos',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              child: Column(
                                children: [
                                  Text(
                                    '1000',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    'Followers',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              child: Column(
                                children: [
                                  Text(
                                    '105',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    'Following',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                                onPressed: () {},
                                child: Text(
                                  'Add Photos',
                                  style: Theme.of(context).textTheme.bodyText1,
                                )),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          OutlinedButton(
                              onPressed: () {
                                navigateToWithReturn(context, EditProfileScreen());
                              },
                              child: const Icon(
                                IconBroken.Edit,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                fallback: (context)=>const Center(child: CircularProgressIndicator()),
              );
            }
        );
      }
    );
  }
}
