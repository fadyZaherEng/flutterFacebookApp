class PostComments
{
  dynamic userImage,username,comment,dateTime;
  PostComments({required this.userImage,required this.username,required this.comment,required this.dateTime});

  PostComments.fromJson(Map<String,dynamic>?json)
  {
    userImage=json!['image'];
    username=json['username'];
    comment=json['comment'];
    dateTime=json['time'];

  }
  Map<String,dynamic> toMap(){
    return{
      'image':userImage,
      'comment':comment,
      'time':dateTime,
      'username':username,
    };
  }
}