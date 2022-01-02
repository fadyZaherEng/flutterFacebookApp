class UserProfile
{
  dynamic name,password,phone,email,uid,bio,cover,defaultImage,status,gender;
  UserProfile({required this.gender,required this.name,required this.password,required this.phone,required this.email,required this.uid,this.cover,this.defaultImage,this.bio});

  UserProfile.fromJson(Map<String,dynamic>?json)
  {
    name=json!['name'];
    phone=json['phone'];
    email=json['email'];
    password=json['password'];
    uid=json['uid'];
    bio=json['bio'];
    defaultImage=json['defaultImage'];
    cover=json['cover'];
    gender=json['gender'];
  }
  Map<String,dynamic> toMap(){
    return{
      'phone':phone,
      'password':password,
      'uid':uid,
      'email':email,
      'name':name,
      'defaultImage':defaultImage,
      'bio':bio,
      'cover':cover,
      'gender':gender,
    };
  }
}