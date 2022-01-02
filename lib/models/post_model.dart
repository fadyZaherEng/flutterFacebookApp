class PostModel
{

  dynamic userImage,name,uid,text,dateTime,postImage,hashtag;
  PostModel({required this.hashtag,this.userImage,required this.name,required this.text,required this.dateTime,required this.uid,this.postImage});

  PostModel.fromJson(Map<String,dynamic>?json)
  {
    userImage=json!['userImage'];
    name=json['name'];
    text=json['text'];
    dateTime=json['dateTime'];
    uid=json['uid'];
    postImage=json['postImage'];
    hashtag=json['hashtag'];
  }
  Map<String,dynamic> toMap(){
    return{
      'userImage':userImage,
      'text':text,
      'uid':uid,
      'dateTime':dateTime,
      'name':name,
      'postImage':postImage,
      'hashtag':hashtag,

    };
  }
}