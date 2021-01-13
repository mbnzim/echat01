import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

enum MediaType {
  Photo,
  Video,
}

enum MessageType {
  Text,
  Media,
}

final String ALL_MESSAGES_COLLECTION = 'MESSAGES';
final String USERS_COLLECTION = 'USERS';
final String CHATS_COLLECTION = 'CHATS';
final String MEDIA_COLLECTION = 'MEDIA';
final String POSTS_COLLECTION = 'POSTS';
final String CHATS_MEDIA_STORAGE_REF = 'ChatsMedia';



///////////////////////////////////////////////////////////////
final _firestore = Firestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final usersRef = _firestore.collection(USERS_COLLECTION);
final postsRef = _firestore.collection(POSTS_COLLECTION);
final followersRef = _firestore.collection('followers');
final followingRef = _firestore.collection('following');
final feedsRef = _firestore.collection('feeds');
final likesRef = _firestore.collection('likes');
final commentsRef = _firestore.collection('comments');
final activitiesRef = _firestore.collection('activities');

/////////////////////////////////////////////////////////////


Color kBorderColor1 = Colors.white.withOpacity(0.1);
Color kBorderColor2 = Colors.white.withOpacity(0.07);
Color kBorderColor3 = Colors.white.withOpacity(0.2);
Color kBorderColor4 = Colors.white.withOpacity(0.2);
Color kBaseWhiteColor = Colors.white.withOpacity(0.87);

Color kBlackColor = Colors.black; //('#1C1C1E');
Color kBlackColor2 = HexColor('#121212'); // Hexcolor('#161616');
Color kBlackColor3 = HexColor('#1C1C1E'); // Hexcolor('#2C2C2E');

TextStyle kWhatsAppStyle = TextStyle(
  fontSize: 21,
  fontWeight: FontWeight.bold,
  color: Colors.black.withOpacity(0.95),
);

TextStyle kSelectedTabStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.black.withOpacity(0.95),
);

TextStyle kUnselectedTabStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.black.withOpacity(0.4),
);

TextStyle kChatItemTitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);

TextStyle kChatItemSubtitleStyle = TextStyle(
  fontSize: 14,
  color: Colors.white.withOpacity(0.7),
);

TextStyle kAppBarTitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: kBaseWhiteColor,
);

TextStyle kChatBubbleTextStyle = TextStyle(
  fontSize: 17,
  color: kBaseWhiteColor,
);

TextStyle kReplyTitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: HexColor('#FF0266'),
);

TextStyle kReplySubtitleStyle = TextStyle(
  fontSize: 14,
  color: kBaseWhiteColor,
);

class ReplyColorPair {
  final Color user;
  final Color peer;
  ReplyColorPair({this.user, this.peer});
}

List<ReplyColorPair> replyColors = [
  ReplyColorPair(user: HexColor('#09af00'), peer: HexColor('#FF0266')),
  ReplyColorPair(user: HexColor('#C62828'), peer: HexColor('#d602ee')),
  ReplyColorPair(user: HexColor('#f47100'), peer: HexColor('#61d800')),
  ReplyColorPair(user: HexColor('#4E342E'), peer: HexColor('#BF360C')),
];

String myPic =
    'https://firebasestorage.googleapis.com/v0/b/flutter-whatsapp-1ab58.appspot.com/o/profilePictures%2FBn2lfah2dRRXfp3uZankMDJcgqs1.png?alt=media&token=2d633673-c650-4947-aff2-f0c8287abd31';
