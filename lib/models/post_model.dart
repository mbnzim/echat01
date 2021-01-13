import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String imageUrl;
  final String caption;
  String location; 
  final int likeCount;
  final String authorId;
  final Timestamp timestamp;

  PostModel({
    this.id,
    this.imageUrl,
    this.caption,
    this.location,
    this.likeCount,
    this.authorId,
    this.timestamp,
  });

  factory PostModel.fromDoc(DocumentSnapshot doc) {
    return PostModel(
      id: doc.documentID,
      imageUrl: doc['imageUrl'],
      caption: doc['caption'],
      location: doc['location'],
      likeCount: doc['likeCount'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
    );
  }
}
