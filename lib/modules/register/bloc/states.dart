abstract class SocialAppRegisterStates{}

class SocialAppRegisterInitialStates extends SocialAppRegisterStates{}
class SocialAppRegisterLoadingStates extends SocialAppRegisterStates{}
class SocialAppRegisterSuccessStates extends SocialAppRegisterStates{
  String uid;

  SocialAppRegisterSuccessStates(this.uid);
}
class SocialAppRegisterErrorStates extends SocialAppRegisterStates{
  String error;
  SocialAppRegisterErrorStates(this.error);
}

class SocialAppRegisterChangeEyeStates extends SocialAppRegisterStates{}
class SocialAppRegisterChangeImageStates extends SocialAppRegisterStates{}
//image
class SocialAppRegisterImageSuccessStates extends SocialAppRegisterStates{}
class SocialAppRegisterImageErrorStates extends SocialAppRegisterStates{}