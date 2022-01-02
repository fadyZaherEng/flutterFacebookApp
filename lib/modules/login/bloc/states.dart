abstract class SocialAppLogInStates{}

class SocialAppLogInInitialStates extends SocialAppLogInStates{}
class SocialAppLogInLoadingStates extends SocialAppLogInStates{}
class SocialAppLogInSuccessStates extends SocialAppLogInStates{
String uid;

SocialAppLogInSuccessStates(this.uid);
}
class SocialAppLogInErrorStates extends SocialAppLogInStates{
  String error;

  SocialAppLogInErrorStates(this.error);
}

class SocialAppLogInChangeEyeStates extends SocialAppLogInStates{}
