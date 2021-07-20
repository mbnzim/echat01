import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whatsapp_clone/models/like.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/screens/calls_screen/calls_screen.dart';
import 'package:whatsapp_clone/screens/profile_screen/friend_profile_screen.dart';
import 'package:whatsapp_clone/services/repository.dart';
import 'package:whatsapp_clone/screens/comments/comments_screen.dart';
import 'package:whatsapp_clone/screens/likes/likes_screen.dart';

class PostDetailScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final User user, currentuser;

  PostDetailScreen({this.documentSnapshot, this.user, this.currentuser});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  var _repository = Repository();
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.black26,
        title: Text('Post',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: ListView(
       children: <Widget>[
        Column(
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
                    new Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(widget
                                .documentSnapshot.data['postOwnerPhotoUrl'])),
                      ),
                    ),
                    new SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          widget.documentSnapshot.data['postOwnerName'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        widget.documentSnapshot.data['location'] != null
                            ? new Row(children: <Widget>[
                                Icon(FontAwesomeIcons.retweet, size: 12),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.documentSnapshot.data['location'],
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
            imageUrl: widget.documentSnapshot.data['imgUrl'],
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
                            postLike(widget.documentSnapshot.reference);
                          } else {
                            setState(() {
                              _isLiked = false;
                            });
                            //saveLikeValue(_isLiked);
                            postUnlike(widget.documentSnapshot.reference);
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
                                      documentReference:
                                          widget.documentSnapshot.reference,
                                      user: widget.currentuser,
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
                //new Icon(FontAwesomeIcons.bookmark)
              ],
            ),
          ),
          Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
          FutureBuilder(
            future:
                _repository.fetchPostLikes(widget.documentSnapshot.reference),
            builder: ((context,
                AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
              if (likesSnapshot.hasData) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => LikesScreen(
                                  user: widget.currentuser,
                                  documentReference:
                                      widget.documentSnapshot.reference,
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
                          child: commentWidget(widget.documentSnapshot.reference)),
                        ]),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: widget.documentSnapshot.data['caption'] != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Wrap(
                          children: <Widget>[
                            /* Text(
                                  widget.documentSnapshot.data['postOwnerName'],
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),*/
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child:
                                  Text(widget.documentSnapshot.data['caption']),
                            )
                          ],
                        ),
                        /* Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: commentWidget(
                                  widget.documentSnapshot.reference))*/
                      ],
                    )
                  : commentWidget(widget.documentSnapshot.reference)),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text("1 Day Ago", style: TextStyle(color: Colors.grey)),
          )
        ],
      )]),
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
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            documentReference: reference,
                            user: widget.currentuser,
                          ))));
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  void postLike(DocumentReference reference) {
    var _like = Like(
        ownerName: widget.currentuser.username,
        ownerPhotoUrl: widget.currentuser.imageUrl,
        ownerUid: widget.currentuser.id,
        timeStamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .document(widget.currentuser.id)
        .setData(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  void postUnlike(DocumentReference reference) {
    reference
        .collection("likes")
        .document(widget.currentuser.id)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
  }
}
