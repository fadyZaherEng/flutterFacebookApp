import 'package:social_firebase_app/models/user_profile.dart';

abstract class SocialStates{}

class SocialInitialStates extends SocialStates{}
class SocialLoadingStates extends SocialStates{}
class SocialSuccessStates extends SocialStates{
  UserProfile profile;

  SocialSuccessStates(this.profile);
}
class SocialErrorStates extends SocialStates{
  String error;

  SocialErrorStates(this.error);
}
class SocialBottomNavChangeStates extends SocialStates{}
class SocialBottomNavChangePostStates extends SocialStates{}

class SocialGetProfileImageSuccessStates extends SocialStates{}
class SocialGetProfileImageErrorStates extends SocialStates{}

class SocialUploadProfileSuccessStates extends SocialStates{}
class SocialUploadProfileImageErrorStates extends SocialStates{}

class SocialGetProfileCoverSuccessStates extends SocialStates{}
class SocialGetProfileCoverErrorStates extends SocialStates{}

class SocialUploadProfileCoverErrorStates extends SocialStates{}

class SocialUpdateProfileDataSuccessStates extends SocialStates{}
class SocialUpdateProfileDataErrorStates extends SocialStates{}

class SocialUpdateProfileDataWaitingToFinishUploadStates extends SocialStates{}
class SocialUpdateProfileDataWaitingImageToFinishUploadStates extends SocialStates{}
class SocialUpdateProfileDataWaitingCoverToFinishUploadStates extends SocialStates{}

//post
class SocialPostCreatedSuccessStates extends SocialStates{}
class SocialPostCreatedErrorStates extends SocialStates{}
//get image post
class SocialPostCreatedImageSuccessStates extends SocialStates{}
class SocialPostCreatedImageErrorStates extends SocialStates{}
class SocialPostCreatedImageLoadingStates extends SocialStates{}
//upload image post
class SocialPostUploadImageSuccessStates extends SocialStates{
  String imageUrl;

  SocialPostUploadImageSuccessStates(this.imageUrl);
}
class SocialPostUploadImageErrorStates extends SocialStates{}
class SocialPostUploadImageLoadingStates extends SocialStates{}
//close
class SocialPostImageCloseStates extends SocialStates{}

//get posts
class SocialGetPostsSuccessStates extends SocialStates{}
class SocialGetPostsErrorStates extends SocialStates{
  String error;

  SocialGetPostsErrorStates(this.error);
}
class SocialGetPostsLoadingStates extends SocialStates{}
//verify
class SocialVerifyStates extends SocialStates{}

//likes posts
class SocialLikesPostsSuccessStates extends SocialStates{}
class SocialLikesPostsErrorStates extends SocialStates{
  String error;

  SocialLikesPostsErrorStates(this.error);
}
class SocialLikesPostsLoadingStates extends SocialStates{}
//add comment posts
class SocialCommentsPostsSuccessStates extends SocialStates{}
class SocialCommentsPostsErrorStates extends SocialStates{
  String error;

  SocialCommentsPostsErrorStates(this.error);
}
class SocialCommentsPostsLoadingStates extends SocialStates{}
//add comment posts
class SocialGetCommentsPostsSuccessStates extends SocialStates{}
class SocialGetCommentsPostsErrorStates extends SocialStates{
  String error;

  SocialGetCommentsPostsErrorStates(this.error);
}
class SocialGetCommentsPostsLoadingStates extends SocialStates{}

//get all users
//add comment posts
class SocialGetAllUsersSuccessStates extends SocialStates{}
class SocialGetAllUsersErrorStates extends SocialStates{
  String error;

  SocialGetAllUsersErrorStates(this.error);
}
class SocialGetAllUsersLoadingStates extends SocialStates{}
//add likes posts
class SocialGetLikesSuccessStates extends SocialStates{}
class SocialGetLikesErrorStates extends SocialStates{
  String error;

  SocialGetLikesErrorStates(this.error);
}
class SocialGetLikesLoadingStates extends SocialStates{}
//comment delete
class SocialCommentDeletedSuccessStates extends SocialStates{}
class SocialCommentDeletedErrorStates extends SocialStates{
  String error;

  SocialCommentDeletedErrorStates(this.error);
}
class SocialCommentDeletedLoadingStates extends SocialStates{}
//post delete
class SocialPostDeletedSuccessStates extends SocialStates{}
class SocialPostDeletedErrorStates extends SocialStates{
  String error;

  SocialPostDeletedErrorStates(this.error);
}
class SocialPostDeletedLoadingStates extends SocialStates{}
//AddMassage
class SocialAddMassageSuccessStates extends SocialStates{}
class SocialAddMassageErrorStates extends SocialStates{
  String error;

  SocialAddMassageErrorStates(this.error);
}
//GetMassage
class SocialGetMassageSuccessStates extends SocialStates{}
class SocialGetMassageErrorStates extends SocialStates{
  String error;

  SocialGetMassageErrorStates(this.error);
}
//chat image
class SocialChatUploadImageLoadingSuccessStates extends SocialStates{}
//deleteMassage
class SocialDeleteMassageSuccessStates extends SocialStates{}
class SocialDeleteMassageErrorStates extends SocialStates{
  String error;

  SocialDeleteMassageErrorStates(this.error);
}
//update post
class SocialUpdatePostsOfCurrentUserWithNewProfileSuccessStates extends SocialStates{}
class SocialUpdatePostsOfCurrentUserWithNewProfileErrorStates extends SocialStates{
  String error;

  SocialUpdatePostsOfCurrentUserWithNewProfileErrorStates(this.error);
}
//search post
class SocialSearchPostLoadingStates extends SocialStates{}
class SocialSearchPostSuccessStates extends SocialStates{}
class SocialSearchPostErrorStates extends SocialStates{
  String error;

  SocialSearchPostErrorStates(this.error);
}
//change mode
class SocialSChangeModeStates extends SocialStates{}
//user status
class SocialGetUserStatusStates extends SocialStates{}
class SocialPostsNumberStates extends SocialStates{}

