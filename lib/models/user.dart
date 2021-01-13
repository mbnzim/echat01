import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String id;
  String username; 
  String email; 
  String imageUrl;
  String about;
  DateTime aboutChangeDate;
  String followers;
  String following;
  String posts;

  User({
    @required this.id,
    @required this.username, 
    this.email,   
    this.imageUrl,
    this.about,
    this.aboutChangeDate,
    this.followers, 
    this.following,
     this.posts,
  });

  factory User.fromJson(Map<String, dynamic> data) {    
    return _$UserFromJson(data);
  }

  static Map<String, dynamic> toJson(User person) {    
    return _$UserToJson(person); 
  }

   Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['id'] = user.id;
    data['email'] = user.email;
    data['imageUrl'] = user.imageUrl;
    data['username'] = user.username;
    data['followers'] = user.followers;
    data['following'] = user.following;
    data['about'] = user.about;
    data['posts'] = user.posts;
    //data['phone'] = user.phone;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData,) {
    this.id = mapData['id'];
    this.email = mapData['email'];
    this.imageUrl = mapData['imageUrl'];
    this.username = mapData['username'];
    this.followers = mapData['followers'];
    this.following = mapData['following'];
    this.about = mapData['about'];
    this.posts = mapData['posts'];
   // this.phone = mapData['phone']; 
  }

  factory User.fromDoc(DocumentSnapshot doc)
  {
    return User(
      id: doc['id'],
      email: doc['email'],
      username: doc['username'],
      imageUrl: doc['imageUrl'],
      followers: doc['followers'],
      following : doc['following'],
      about: doc['about'],
      posts: doc['posts']
    );
  }

}
