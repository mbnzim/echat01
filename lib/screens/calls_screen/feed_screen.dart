import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whatsapp_clone/models/like.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/screens/calls_screen/calls_screen.dart';
import 'package:whatsapp_clone/screens/calls_screen/uploadpage.dart';
import 'package:whatsapp_clone/screens/contacts_screen/contacts_screen.dart';
import 'package:whatsapp_clone/services/repository.dart';
//import 'package:whatsapp_clone/ui/chat_screen.dart';
import 'package:whatsapp_clone/screens/comments/comments_screen.dart';
import 'package:whatsapp_clone/screens/profile_screen/friend_profile_screen.dart';
import 'package:whatsapp_clone/screens/likes/likes_screen.dart';

class InstaFeedScreen extends StatefulWidget {
  @override
  _InstaFeedScreenState createState() => _InstaFeedScreenState();
}

class _InstaFeedScreenState extends State<InstaFeedScreen> {
  var _repository = Repository();
  User currentUser, user, followingUser;
  IconData icon;
  Color color;
  List<User> usersList = List<User>();
  Future<List<DocumentSnapshot>> _future;
  bool _isLiked = false;
  List<String> followingUIDs = List<String>();

  @override
  void initState() {
    super.initState();
    fetchFeed();
  }

  void fetchFeed() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();

    User user = await _repository.fetchUserDetailsById(currentUser.uid);
    setState(() {
      this.currentUser = user;
    });

    followingUIDs = await _repository.fetchFollowingUids(currentUser);

    for (var i = 0; i < followingUIDs.length; i++) {
      print("DSDASDASD : ${followingUIDs[i]}");
      // _future = _repository.retrievePostByUID(followingUIDs[i]);
      this.user = await _repository.fetchUserDetailsById(followingUIDs[i]);
      print("user : ${this.user.id}");
      usersList.add(this.user);
      print("USERSLIST : ${usersList.length}");

      for (var i = 0; i < usersList.length; i++) {
        setState(() {
          followingUser = usersList[i];
          print("FOLLOWING USER : ${followingUser.id}");
        });
      }
    }
    _future = _repository.fetchFeed(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        centerTitle: true,
        elevation: 1.0,
        leading: new IconButton(
          icon: Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UploadPage(
                      currentUser: currentUser,
                    )));
          },
        ),
        title: SizedBox(height: 35.0, child: Text("")),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => FeedScreen())));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => ContactsScreen())));
              },
            ),
          )
        ],
      ),
      body: currentUser != null
          ? Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: postImagesWidget(),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget postImagesWidget() {
    return FutureBuilder(
      future: _future,
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          print("FFFF : ${followingUser.id}");
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                //shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: ((context, index) => listItem(
                      list: snapshot.data,
                      index: index,
                      user: followingUser,
                      currentUser: currentUser,
                    )));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  Widget listItem(
      {List<DocumentSnapshot> list, User user, User currentUser, int index}) {
    print("dadadadad : ${user.id}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => InstaFriendProfileScreen(
                                    name: list[index].data['postOwnerName'],
                                  ))));
                    },
                    child: new Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                                list[index].data['postOwnerPhotoUrl'])),
                      ),
                    ),
                  ),
                  new SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      InstaFriendProfileScreen(
                                        name: list[index].data['postOwnerName'],
                                      ))));
                        },
                        child: new Text(
                          list[index].data['postOwnerName'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      list[index].data['location'] != null
                          ? new Row(children: <Widget>[
                              Icon(FontAwesomeIcons.retweet, size: 12),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                list[index].data['location'],
                                style: TextStyle(color: Colors.grey),
                              )
                            ])
                          : Container(),
                    ],
                  )
                ],
              ),
              new IconButton(
                icon: Icon(Icons.keyboard_control),
                onPressed: null,
              )
            ],
          ),
        ),
        CachedNetworkImage(
          imageUrl: list[index].data['imgUrl'],
          placeholder: ((context, s) => Center(
                child: CircularProgressIndicator(),
              )),
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Icon(FontAwesomeIcons.retweet, size: 28),
                  new SizedBox(
                    width: 230,
                  ),
                  GestureDetector(
                      child: _isLiked
                          ? Icon(
                              FontAwesomeIcons.fire,
                              color: Colors.orange,
                              size: 28,
                            )
                          : Icon(
                              FontAwesomeIcons.fire,
                              color: null,
                              size: 28,
                            ),
                      onTap: () {
                        if (!_isLiked) {
                          setState(() {
                            _isLiked = true;
                          });
                          // saveLikeValue(_isLiked);
                          postLike(list[index].reference, currentUser);
                        } else {
                          setState(() {
                            _isLiked = false;
                          });
                          //saveLikeValue(_isLiked);
                          postUnlike(list[index].reference, currentUser);
                        }
                      }),
                  new SizedBox(
                    width: 16.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => CommentsScreen(
                                    documentReference: list[index].reference,
                                    user: currentUser,
                                  ))));
                    },
                    child: new Icon(
                      FontAwesomeIcons.comment,
                      size: 28,
                    ),
                  ),
                  new SizedBox(
                    width: 16.0,
                  ),
                  new Icon(
                    FontAwesomeIcons.shareAlt,
                    size: 28,
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
          FutureBuilder(
          future: _repository.fetchPostLikes(list[index].reference),
          builder:
              ((context, AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
            if (likesSnapshot.hasData) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => LikesScreen(
                                user: currentUser,
                                documentReference: list[index].reference,
                              ))));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: likesSnapshot.data.length > 1
                      ? Text(
                          "${(likesSnapshot.data.length - 1).toString()} Likes ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Text(likesSnapshot.data.length == 1
                          ? "${(likesSnapshot.data.length).toString()} Likes  "
                          : "0 Likes"),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
        ),
                 Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: commentWidget(list[index].reference)),
                        ]),
      
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: list[index].data['caption'] != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                         /* Text(list[index].data['postOwnerName'],
                              style: TextStyle(fontWeight: FontWeight.bold)),*/
                         Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Text(list[index].data['caption']),
                          )
                        ],
                      ),
                     /* Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: commentWidget(list[index].reference))*/
                    ],
                  )
                : commentWidget(list[index].reference)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text("1 Day Ago", style: TextStyle(color: Colors.grey)),
        )
      ],
    );
  }

  Widget commentWidget(DocumentReference reference) {
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              '${snapshot.data.length} Comments',
              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            documentReference: reference,
                            user: currentUser,
                          ))));
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  void postLike(DocumentReference reference, User currentUser) {
    var _like = Like(
        ownerName: currentUser.username,
        ownerPhotoUrl: currentUser.imageUrl,
        ownerUid: currentUser.id,
        timeStamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .document(currentUser.id)
        .setData(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  void postUnlike(DocumentReference reference, User currentUser) {
    reference
        .collection("likes")
        .document(currentUser.id)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
  }
}
