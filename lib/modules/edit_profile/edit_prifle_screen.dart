import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/cubit.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/states.dart';
import 'package:social_firebase_app/models/user_profile.dart';
import 'package:social_firebase_app/shared/components/components.dart';
import 'package:social_firebase_app/shared/styles/Icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  var formKey=GlobalKey<FormState>();

  var genderController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getCurrentUser();
        return BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {},
            builder: (context, state) {
              if(state is !SocialLoadingStates) {
                nameController.text = SocialCubit
                    .get(context)
                    .profile!.name;
                bioController.text = SocialCubit
                    .get(context)
                    .profile!.bio;
                phoneController.text = SocialCubit
                    .get(context)
                    .profile!.phone;
                genderController.text = SocialCubit
                    .get(context)
                    .profile!.gender;
              }
              var cubit = SocialCubit.get(context);
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(IconBroken.Arrow___Left_2),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    'Profile',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  actions: [
                    state is SocialUpdateProfileDataWaitingImageToFinishUploadStates||state is SocialUpdateProfileDataWaitingCoverToFinishUploadStates
                        ? Center(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  'Waiting...',
                                  style: Theme.of(context).textTheme.bodyText2,
                                )),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: TextButton(
                                onPressed: () {
                                 if(formKey.currentState!.validate()){
                                   cubit.updateUserProfile(
                                       name: nameController.text,
                                       bio: bioController.text,
                                       phone: phoneController.text,
                                       gender: genderController.text
                                   );
                                 }
                                },
                                child: const Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blueAccent),
                                )),
                          ),
                  ],
                ),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            height: 210,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Align(
                                  child:state is! SocialUpdateProfileDataWaitingCoverToFinishUploadStates?
                                  InkWell(
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          child: cubit.profileCover == null
                                                  ? Image(
                                                      height: 150,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          '${SocialCubit
                                                              .get(context)
                                                              .profile!.cover}'))
                                                  : Image.file(
                                                      File(cubit.profileCover!.path),
                                                      width: double.infinity,
                                                      height: 150,
                                                      fit: BoxFit.cover,
                                                    )
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.blueAccent,
                                            radius: 15,
                                            child: Icon(IconBroken.Camera),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      cubit.getProfileCover();
                                    },
                                  ):const Center(child: LinearProgressIndicator()),
                                  alignment: Alignment.topCenter,
                                ),
                                InkWell(
                                  child: state is! SocialUpdateProfileDataWaitingImageToFinishUploadStates?
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      CircleAvatar(
                                        radius: 64,
                                        backgroundColor:
                                            Theme.of(context).scaffoldBackgroundColor,
                                        child: CircleAvatar(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          backgroundImage:
                                              NetworkImage('${SocialCubit
                                                  .get(context)
                                                  .profile!.defaultImage}'),
                                          child: cubit.profileImage == null
                                              ? null
                                              : Container(
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(64)),
                                                  ),
                                                  child: Image.file(
                                                    File(cubit.profileImage!.path),
                                                    width: 128,
                                                    height: 128,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                          radius: 60,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.blueAccent,
                                          radius: 15,
                                          child: Icon(IconBroken.Camera),
                                        ),
                                      ),
                                    ],
                                  ):const Center(child: LinearProgressIndicator()),
                                  onTap: () {
                                    cubit.getProfileImage();
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          defaultTextForm(
                              context: context,
                              onChanged: () {},
                              type: TextInputType.text,
                              Controller: nameController,
                              prefixIcon: const Icon(
                                IconBroken.User,
                                color: Colors.indigo,
                              ),
                              text: 'Username',
                              validate: (val) {
                                if (val.toString().isEmpty) {
                                  return 'Please Enter Your Username';
                                }
                              },
                              onSubmitted: () {}),
                          const SizedBox(
                            height: 20,
                          ),
                          defaultTextForm(
                              context: context,
                              onChanged: () {},
                              type: TextInputType.text,
                              Controller: bioController,
                              prefixIcon: const Icon(
                                IconBroken.Info_Circle,
                                color: Colors.indigo,
                              ),
                              text: 'Bio',
                              validate: (val) {
                                if (val.toString().isEmpty) {
                                  return 'Please Enter Your Bio';
                                }
                              },
                              onSubmitted: () {}),
                          const SizedBox(
                            height: 20,
                          ),
                          defaultTextForm(
                              context: context,
                              onChanged: () {},
                              type: TextInputType.phone,
                              Controller: phoneController,
                              prefixIcon: const Icon(
                                IconBroken.Call,
                                color: Colors.indigo,
                              ),
                              text: 'Phone',
                              validate: (val) {
                                if (val.toString().isEmpty) {
                                  return 'Please Enter Your Phone';
                                }
                              },
                              onSubmitted: () {}),
                          defaultTextForm(
                              context: context,
                              onChanged: () {},
                              type: TextInputType.text,
                              Controller: genderController,
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
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      }
    );
  }
}
