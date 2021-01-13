import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String currentUserid;
  String imgUrl;
  String caption;
  String location;
  FieldValue time;
  String postOwnerName;
  String postOwnerPhotoUrl;
  //int likeCount;

  Post({
    this.currentUserid,
    this.imgUrl,
    this.caption,
    this.location,
    this.time,
    this.postOwnerName,
    this.postOwnerPhotoUrl,
    //this.likeCount,
  });

  Map toMap(Post post) {
    var data = Map<String, dynamic>();
    data['ownerUid'] = post.currentUserid;
    data['imgUrl'] = post.imgUrl;
    data['caption'] = post.caption;
    data['location'] = post.location;
    data['time'] = post.time;
    data['postOwnerName'] = post.postOwnerName;
    data['postOwnerPhotoUrl'] = post.postOwnerPhotoUrl;
   // data['likeCount'] = post.likeCount;
    return data;
  }

  Post.fromMap(Map<String, dynamic> mapData) {
    this.currentUserid = mapData['ownerUid'];
    this.imgUrl = mapData['imgUrl'];
    this.caption = mapData['caption'];
    this.location = mapData['location'];
    this.time = mapData['time'];
    this.postOwnerName = mapData['postOwnerName'];
    this.postOwnerPhotoUrl = mapData['postOwnerPhotoUrl'];
   // this.likeCount = mapData['likeCount'];
  }

  factory Post.fromDoc(DocumentSnapshot doc) {
    return Post(
      currentUserid : doc['ownerUid'],
      imgUrl: doc['imageUrl'],
      caption: doc['caption'],
      location: doc['location'],
      time: doc['time'],
      postOwnerName: doc['postOwnerName'],
      postOwnerPhotoUrl: doc['postOwnerPhotoUrl'],
    ///  likeCount: doc['likeCount'],
      
    );
  }
}
