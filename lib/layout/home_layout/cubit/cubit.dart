import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_firebase_app/models/massage_model.dart';
import 'package:social_firebase_app/models/postComment.dart';
import 'package:social_firebase_app/models/post_model.dart';
import 'package:social_firebase_app/modules/upload_post/add_post_screen.dart';
import 'package:social_firebase_app/shared/components/components.dart';
import 'package:social_firebase_app/shared/styles/Icon_broken.dart';
import 'package:social_firebase_app/layout/home_layout/cubit/states.dart';
import 'package:social_firebase_app/models/user_profile.dart';
import 'package:social_firebase_app/modules/chats/chat_screen.dart';
import 'package:social_firebase_app/modules/feeds/feed_screen.dart';
import 'package:social_firebase_app/modules/setting/setting_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialStates());

  @override
  Future<void> close() async {
    Bloc.observer.onClose(this);
    showToast(message: 'Closed', state: ToastState.SUCCESS);
  }

  static SocialCubit get(context) => BlocProvider.of(context);
  UserProfile? profile;

  void getCurrentUser() {
    emit(SocialLoadingStates());
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid) //uid
        .get()
        .then((value) {
      profile = UserProfile.fromJson(value.data());
      emit(SocialSuccessStates(profile!));
    }).catchError((onError) {
      emit(SocialErrorStates(onError.toString()));
    });
  }

  int currentIndex = 0;
  List<Widget> listScreen = [
    FeedsScreen(),
    ChatsScreen(),
    UploadPostScreen(),
    SettingsScreen(),
  ];
  List<String> listTitles = [
    'Home',
    'Users',
    'Posts',
    'Settings',
  ];
  List<BottomNavigationBarItem> bottomNavList = const [
    BottomNavigationBarItem(icon: Icon(IconBroken.Home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(IconBroken.User), label: 'Chats'),
    BottomNavigationBarItem(icon: Icon(IconBroken.Upload), label: 'Post'),
    BottomNavigationBarItem(icon: Icon(IconBroken.Setting), label: 'Settings'),
  ];

  void changeNav(idx) {
    if (idx == 2) {
      emit(SocialBottomNavChangePostStates());
    } else {
      currentIndex = idx;
      emit(SocialBottomNavChangeStates());
    }
  }

  File? profileImage;

  void getProfileImage() async {
    //emit(SocialUpdateProfileDataWaitingToFinishUploadStates());
    emit(SocialUpdateProfileDataWaitingImageToFinishUploadStates());
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      uploadProfileImage();
      //   emit(SocialGetProfileImageSuccessStates());
    } else {
      showToast(message: 'No Image Selected', state: ToastState.WARNING);
      emit(SocialGetProfileImageErrorStates());
    }
  }

  File? profileCover;

  void getProfileCover() async {
    //  emit(SocialUpdateProfileDataWaitingToFinishUploadStates());
    emit(SocialUpdateProfileDataWaitingCoverToFinishUploadStates());
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileCover = File(pickedFile.path);
      uploadProfileCover();
    } else {
      showToast(message: 'No Cover Selected', state: ToastState.WARNING);
      emit(SocialGetProfileCoverErrorStates());
    }
  }

  String? profileImageUrl;

  void uploadProfileImage() {
    FirebaseStorage.instance
        .ref()
        .child(
            'users/${Uri.file(profileImage!.path).pathSegments.length / DateTime.now().millisecond}')
        .putFile(profileImage!)
        .then((val) {
      val.ref.getDownloadURL().then((value) {
        profileImageUrl = value;
        emit(SocialUploadProfileSuccessStates());
      }).catchError((onError) {
        emit(SocialUploadProfileImageErrorStates());
      });
    }).catchError((onError) {
      emit(SocialUploadProfileImageErrorStates());
    });
  }

  String? profileCoverUrl;

  void uploadProfileCover() {
    FirebaseStorage.instance
        .ref()
        .child(
            'users/${Uri.file(profileCover!.path).pathSegments.length / DateTime.now().millisecondsSinceEpoch}')
        .putFile(profileCover!)
        .then((val) {
      val.ref.getDownloadURL().then((value) {
        profileCoverUrl = value;
        emit(SocialUploadProfileSuccessStates());
      }).catchError((onError) {
        emit(SocialUploadProfileCoverErrorStates());
      });
    }).catchError((onError) {
      emit(SocialUploadProfileCoverErrorStates());
    });
  }

  void updateUserProfile({
    required String name,
    required String bio,
    required String phone,
    required String gender,
  }) {
    UserProfile userProfile = UserProfile(
      name: name,
      password: profile!.password,
      phone: phone,
      email: profile!.email,
      uid: profile!.uid,
      bio: bio,
      gender: gender
    );
    if (profileImage != null && profileCover != null) {
      userProfile.defaultImage = profileImageUrl;
      userProfile.cover = profileCoverUrl;
    } else if (profileImage == null && profileCover == null) {
      userProfile.defaultImage = profile!.defaultImage;
      userProfile.cover = profile!.cover;
    } else if (profileImage != null && profileCover == null) {
      userProfile.defaultImage = profileImageUrl;
      userProfile.cover = profile!.cover;
    } else if (profileImage == null && profileCover != null) {
      userProfile.defaultImage = profile!.defaultImage;
      userProfile.cover = profileCoverUrl;
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(profile!.uid)
        .update(userProfile.toMap())
        .then((value) {
      getCurrentUser();
      showToast(
          message: 'Profile Edited Successfully', state: ToastState.SUCCESS);
      updatePostsOfCurrentUserWithNewProfile(
          name: userProfile.name, userImage: userProfile.defaultImage);
      //   emit(SocialUpdateProfileDataSuccessStates());
    }).catchError((onError) {
      showToast(
          message: 'Profile Edited Error :${onError.toString()}',
          state: ToastState.SUCCESS);
      emit(SocialUpdateProfileDataErrorStates());
    });
  }

  void updatePostsOfCurrentUserWithNewProfile({
    required String name,
    required String userImage,
  }) {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) async {
        if (element.data()['uid'] == profile!.uid) {
          String postId = element.id;
          PostModel postModel = PostModel(
            name: name,
            text: element.data()['text'],
            dateTime: element.data()['dateTime'],
            uid: element.data()['uid'],
            userImage: userImage,
            postImage: element.data()['postImage'],
            hashtag: element.data()['hashtag'],
          );
          await FirebaseFirestore.instance
              .collection('posts')
              .doc(postId)
              .update(postModel.toMap());
        }
      });
      emit(SocialUpdatePostsOfCurrentUserWithNewProfileSuccessStates());
    }).catchError((error) {
      emit(SocialUpdatePostsOfCurrentUserWithNewProfileErrorStates(
          error.toString()));
    });
  }

  void createPost(
      {required String text,
      required context,
      required String dateTime,
      String? postImage,
      required String? hashtag}) {
    PostModel postModel = PostModel(
      userImage: profile!.defaultImage,
      name: profile!.name,
      dateTime: dateTime,
      uid: profile!.uid,
      text: text,
      postImage: postImage,
      hashtag: hashtag,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
      getCurrentUserPosts();
      changeNav(0);
      showToast(
          message: 'Post Created Successfully', state: ToastState.SUCCESS);
      //getPosts();
      emit(SocialPostCreatedSuccessStates());
    }).catchError((onError) {
      showToast(
          message: 'Post Created Error :${onError.toString()}',
          state: ToastState.SUCCESS);
      emit(SocialPostCreatedErrorStates());
    });
  }

  double heightImageAddPost = 480;
  File? postImage;

  void getPostImage() async {
    emit(SocialPostCreatedImageLoadingStates());
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      // emit(SocialPostCreatedImageSuccessStates());
      heightImageAddPost = 280;
      uploadPostImage();
    } else {
      showToast(message: 'No Post Image Selected', state: ToastState.WARNING);
      emit(SocialPostCreatedImageErrorStates());
    }
  }

  void uploadPostImage() {
    FirebaseStorage.instance
        .ref()
        .child(
            'posts/${Uri.file(postImage!.path).pathSegments.length / DateTime.now().millisecondsSinceEpoch}')
        .putFile(postImage!)
        .then((val) {
      val.ref.getDownloadURL().then((value) {
        emit(SocialPostUploadImageSuccessStates(value.toString()));
      }).catchError((onError) {
        emit(SocialPostUploadImageErrorStates());
      });
    }).catchError((onError) {
      emit(SocialPostUploadImageErrorStates());
    });
  }

//close
  void closeImage() {
    heightImageAddPost = 480;
    postImage = null;
    emit(SocialPostImageCloseStates());
  }

  //get posts
  List<PostModel> posts = [];
  List<String> postsId = [];
  Map<String, int> postsNumberLikes = {};
  int postsNumber=0;
  getCurrentUserPosts()
  {
    postsNumber=0;
    for(var post in posts)
      {
        if(post.uid==profile!.uid)
          {
            postsNumber++;
          }
      }
    emit(SocialPostsNumberStates());
  }
  void getLikes() {
    emit(SocialGetLikesLoadingStates());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').snapshots().listen((event) {
          postsNumberLikes[element.id] = event.docs.length;
          emit(SocialGetLikesSuccessStates());
        }).onError((handleError) {
          emit(SocialGetLikesErrorStates(handleError.toString()));
        });
      });
    }).catchError((onError) {
      emit(SocialGetLikesErrorStates(onError.toString()));
    });
  }

  void getPosts() {
    emit(SocialGetPostsLoadingStates());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      posts = [];
      postsId = [];
      for (var element in event.docs) {
        posts.add(PostModel.fromJson(element.data()));
        postsId.add(element.id);
        if (!postsNumberLikes.containsKey(element.id)) {
          postsNumberLikes[element.id] = 0;
        }
        if (!postComments.containsKey(element.id)) {
          getPostComments();
        }
      }
      emit(SocialGetPostsSuccessStates());
    }).onError((handleError) {
      emit(SocialGetPostsErrorStates(handleError.toString()));
    });
  }

  //verify account
  verifyClose() => emit(SocialVerifyStates());

  //likes
  void addPostLikes(String postId) {
    DocumentReference reference = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(profile!.uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      if (snapshot.exists) {
        transaction.delete(reference);
        postsNumberLikes[postId] = (postsNumberLikes[postId]! - 1);
        emit(SocialLikesPostsSuccessStates());
      } else {
        transaction.set(reference, {'like': true});
        postsNumberLikes[postId] = (postsNumberLikes[postId]! + 1);
        emit(SocialLikesPostsSuccessStates());
      }
    }).catchError((onError) {
      emit(SocialLikesPostsErrorStates(onError.toString()));
    }); //work atomic if more than person update in the time this jop of transaction
    //another solution
    // FirebaseFirestore.instance
    //     .collection('posts')
    //     .doc(postId)
    //     .collection('likes')
    //     .doc(profile.uid)
    //     .get()
    //     .then((value) {
    //   if (value.exists) {
    //     FirebaseFirestore.instance
    //         .collection('posts')
    //         .doc(postId)
    //         .collection('likes')
    //         .doc(profile.uid)
    //         .delete()
    //         .then((value) {
    //       postsNumberLikes[postId]= (postsNumberLikes[postId]!-1);
    //       emit(SocialLikesPostsSuccessStates());
    //     }).catchError((onError) {
    //       emit(SocialLikesPostsErrorStates(onError.toString()));
    //     });
    //   } else {
    //     FirebaseFirestore.instance
    //         .collection('posts')
    //         .doc(postId)
    //         .collection('likes')
    //         .doc(profile.uid)
    //         .set({'like': true}).then((value) {
    //           postsNumberLikes[postId]=(postsNumberLikes[postId]!+1);
    //           emit(SocialLikesPostsSuccessStates());
    //     }).catchError((onError) {
    //       emit(SocialLikesPostsErrorStates(onError.toString()));
    //     });
    //   }
    // }).catchError((onError) {
    //   emit(SocialLikesPostsErrorStates(onError.toString()));
    // });
  }

  //add comment
  void addPostComments(String postId, String comment, context) {
    emit(SocialCommentsPostsLoadingStates());
    PostComments postComments = PostComments(
        username: profile!.name,
        comment: comment,
        dateTime: DateTime.now().toString(),
        userImage: profile!.defaultImage);
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(postComments.toMap())
        .then((value) {
      //  getPostComments(context, postId);
      emit(SocialCommentsPostsSuccessStates());
    }).catchError((onError) {
      emit(SocialCommentsPostsErrorStates(onError));
    });
  }

  // List<PostComments> postComments = [];//map of id,list of comment call in main
  Map<String, List<PostComments>> postComments = {};

  void getPostComments() async {
    // emit(SocialGetCommentsPostsLoadingStates());
    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference
            .collection('comments')
            .orderBy('time')
            .snapshots()
            .listen((event) {
          List<PostComments> temp = [];
          event.docs.forEach((val) {
            temp.add(PostComments.fromJson(val.data()));
          });
          postComments[element.id] = temp;
          emit(SocialGetCommentsPostsSuccessStates());
        }).onError((handleError) {
          emit(SocialGetCommentsPostsErrorStates(handleError));
        });
      });
      emit(SocialGetCommentsPostsSuccessStates());
    }).catchError((onError) {
      emit(SocialGetCommentsPostsErrorStates(onError));
    });
  }

  //get all users
  List<UserProfile> users = [];

  void getAllUsers() {
    users = [];
    emit(SocialGetAllUsersLoadingStates());
    FirebaseFirestore.instance
        .collection('users')
        .orderBy('name') //uid
        .get()
        .then((value) async {
      for (var element in value.docs) {
        if (element.data()['uid'] != profile!.uid) {
          DocumentSnapshot<Map<String, dynamic>> Status =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(element.data()['uid'])
                  .collection('userStatus')
                  .doc('status')
                  .get();
          users.add(UserProfile.fromJson(element.data()));
          usersStatus[element.data()['uid']] = Status['userStatus'];
        }
      }
      getUserStatus();
      emit(SocialGetAllUsersSuccessStates());
    }).catchError((onError) {
      print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee${onError.toString()}');
      emit(SocialGetAllUsersErrorStates(onError.toString()));
    });
  }

  //delete comment
  void deleteComment(
      {required String name,
      required String text,
      required String time,
      required String postId}) {
    //   emit(SocialCommentDeletedLoadingStates());
    String commentIdDeleted = '';
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        if (element.exists) {
          if (element.data()['username'] == name &&
              element.data()['time'] == time &&
              element.data()['comment'] == text) {
            commentIdDeleted = element.id;
            await FirebaseFirestore.instance
                .collection('posts')
                .doc(postId)
                .collection('comments')
                .doc(commentIdDeleted)
                .delete();
            showToast(
                message: 'Comment Deleted Successfully..',
                state: ToastState.SUCCESS);
            emit(SocialCommentDeletedSuccessStates());
            break;
          }
        }
      }
    }).catchError((onError) {
      emit(SocialCommentDeletedErrorStates(onError.toString()));
    });
  }

  //delete post
  void deletePost({required String postId}) {
    emit(SocialPostDeletedLoadingStates());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
          postComments.remove(postId);
          getCurrentUserPosts();
      showToast(
          message: 'Post Deleted Successfully..', state: ToastState.SUCCESS);
      emit(SocialPostDeletedSuccessStates());
    }).catchError((onError) {
      emit(SocialPostDeletedErrorStates(onError.toString()));
    });
  }

//like another way
// List<int>likes=[];
// void getPosts2(){
// //  emit(SocialGetPostsLoadingStates());
//   posts=[];
//   postsId=[];
//   likes=[];
//   FirebaseFirestore.instance.collection('posts')
//       .orderBy('dateTime',descending: true)
//       .get()
//       .then((value)async {
//     for (var element in value.docs) {
//       var x=await element.reference.collection('likes').get();
//       likes.add(x.docs.length);
//       posts.add(PostModel.fromJson(element.data()));
//       postsId.add(element.id);
//     }
//     emit(SocialGetPostsSuccessStates());
//   }).catchError((onError){
//     emit(SocialGetPostsErrorStates(onError.toString()));
//   });
// }

  //add massage
  void addMassage(
      {required String receiverId,
      required String? text,
      required String dateTime,
      String? chatImage}) {
    MassageModel model = MassageModel(
        senderId: profile!.uid,
        receiverId: receiverId,
        text: text,
        dateTime: dateTime,
        image: chatImage);
    FirebaseFirestore.instance
        .collection('users')
        .doc(profile!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('massages')
        .add(model.toMap())
        .then((value) {
      emit(SocialAddMassageSuccessStates());
    }).catchError((onError) {
      emit(SocialAddMassageErrorStates(onError.toString()));
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(profile!.uid)
        .collection('massages')
        .add(model.toMap())
        .then((value) {
      emit(SocialAddMassageSuccessStates());
    }).catchError((onError) {
      emit(SocialAddMassageErrorStates(onError.toString()));
    });
  }

  List<MassageModel> massages = [];
  List<String> massagesId = [];

  //get massages
  void getMassage({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(profile!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('massages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      massages = [];
      massagesId = [];
      event.docs.forEach((element) {
        massages.add(MassageModel.fromJson(element.data()));
        massagesId.add(element.id);
      });
      emit(SocialGetMassageSuccessStates());
    }).onError((error) {
      emit(SocialGetMassageErrorStates(error.toString()));
    });
  }

  void getChatImage({
    required String receiverId,
    required String? text,
    required String dateTime,
  }) async {
    emit(SocialChatUploadImageLoadingSuccessStates());
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      uploadChatImage(
        chatImage: File(pickedFile.path),
        text: text,
        dateTime: dateTime,
        receiverId: receiverId,
      );
    } else {
      showToast(message: 'No Chat Image Selected', state: ToastState.WARNING);
      emit(SocialPostCreatedImageErrorStates());
    }
  }

  void uploadChatImage({
    required File chatImage,
    required String receiverId,
    required String? text,
    required String dateTime,
  }) {
    FirebaseStorage.instance
        .ref()
        .child(
            'chats/${Uri.file(chatImage.path).pathSegments.length / DateTime.now().millisecondsSinceEpoch}')
        .putFile(chatImage)
        .then((val) {
      val.ref.getDownloadURL().then((value) {
        addMassage(
            receiverId: receiverId,
            text: text,
            dateTime: dateTime,
            chatImage: value.toString());
      }).catchError((onError) {
        emit(SocialPostUploadImageErrorStates());
      });
    }).catchError((onError) {
      emit(SocialPostUploadImageErrorStates());
    });
  }

  //delete massage from me
  void deleteMassageFromMe({
    required String receiverId,
    required String massageId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(profile!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('massages')
        .doc(massageId)
        .delete()
        .then((value) {
      emit(SocialDeleteMassageSuccessStates());
    }).catchError((onError) {
      emit(SocialDeleteMassageErrorStates(onError.toString()));
    });
  }

//delete massage from all
  void deleteMassageFromAll({
    required String receiverId,
    required String massageId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(profile!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('massages')
        .doc(massageId)
        .delete()
        .then((value) {
      emit(SocialDeleteMassageSuccessStates());
    }).catchError((onError) {
      emit(SocialDeleteMassageErrorStates(onError.toString()));
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(profile!.uid)
        .collection('massages')
        .doc(massageId)
        .delete()
        .then((value) {
      emit(SocialDeleteMassageSuccessStates());
    }).catchError((onError) {
      emit(SocialDeleteMassageErrorStates(onError.toString()));
    });
  }

  List<PostModel> searchPosts = [];

  //search Post
  void searchPost(String text) {
    emit(SocialSearchPostLoadingStates());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .get()
        .then((value) {
      searchPosts = [];
      for (var element in value.docs) {
        if (element.data()['text'].toString().toUpperCase().contains(text.toUpperCase())) {
          searchPosts.add(PostModel.fromJson(element.data()));
        }
      }
      emit(SocialSearchPostSuccessStates());
    }).catchError((onError) {
      emit(SocialSearchPostErrorStates(onError.toString()));
    });
  }

  //mode theme
  String modeName = 'Light Theme';
  Color? modeColor = Colors.white;
  ThemeMode modeType = ThemeMode.light;

  void modeChange() {
    if (modeName == 'Light Theme') {
      modeName = 'Dark Theme';
      modeColor = Colors.black;
      modeType = ThemeMode.dark;
    } else {
      modeName = 'Light Theme';
      modeColor = Colors.white;
      modeType = ThemeMode.light;
    }
    emit(SocialSChangeModeStates());
  }

  void changeSettings(context) {
    Navigator.pop(context);
    changeNav(3);
  }

  Map<String, String> usersStatus = {};

  //get user status
  void getUserStatus() {
    FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .get()
        .then((event) {
      event.docs.forEach((element) {
        var documentReference = FirebaseFirestore.instance
            .collection('users')
            .doc(element.id)
            .collection('userStatus')
            .doc('status')
            .snapshots()
            .listen((event) {
          if (element.data()['uid'] != profile!.uid) {
            usersStatus[element.data()['uid']] = event['userStatus'];
            emit(SocialGetUserStatusStates());
          }
        });
      });
      emit(SocialGetUserStatusStates());
    });
  }
}
//https://image.freepik.com/free-photo/restaurant-interior_1127-3394.jpg
//https://image.freepik.com/free-photo/attractive-business-woman-working-computer-cafe_1303-27435.jpg
