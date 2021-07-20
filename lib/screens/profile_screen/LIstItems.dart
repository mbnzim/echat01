import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_clone/models/like.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/screens/comments/comments_screen.dart';
import 'package:whatsapp_clone/screens/likes/likes_screen.dart';
import 'package:whatsapp_clone/services/repository.dart';

class ListItem extends StatefulWidget {
  List<DocumentSnapshot> list;
  User user;
  int index;

  ListItem({this.list, this.user, this.index});

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  var _repository = Repository();
  bool _isLiked = false;
  Future<List<DocumentSnapshot>> _future;

  Widget commentWidget(DocumentReference reference) {
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              '${snapshot.data.length} comments',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            documentReference: reference,
                            user: widget.user,
                          ))));
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    print("INDEX : ${widget.index}");
    //_future =_repository.fetchPostLikes(widget.list[widget.index].reference);
  }

  @override
  Widget build(BuildContext context) {
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
                  new Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(widget.user.imageUrl)),
                    ),
                  ),
                  new SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        widget.user.username,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      widget.list[widget.index].data['location'] != null
                          ? new Row(children: <Widget>[
                              Icon(FontAwesomeIcons.retweet, color: Colors.grey,size: 12),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                 widget.list[widget.index].data['location'],
                    style: TextStyle(color: Colors.grey),
                  )])
                   : Container(),
                    ],
                  )
                ],
              ),
              new IconButton(
                icon: Icon(Icons.more_vert, color: Colors.grey),
                onPressed: null,
              )
            ],
          ),
        ),
        CachedNetworkImage(
          imageUrl: widget.list[widget.index].data['imgUrl'],
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
                   new Icon(FontAwesomeIcons.retweet,color: Colors.grey, size: 28),
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
                              color: Colors.grey,
                               size: 28,
                            ),
                      onTap: () {
                        if (!_isLiked) {
                          setState(() {
                            _isLiked = true;
                          });
                          // saveLikeValue(_isLiked);
                          postLike(widget.list[widget.index].reference);
                        } else {
                          setState(() {
                            _isLiked = false;
                          });
                          //saveLikeValue(_isLiked);
                          postUnlike(widget.list[widget.index].reference);
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
                                        widget.list[widget.index].reference,
                                    user: widget.user,
                                  ))));
                    },
                    child: new Icon(
                      FontAwesomeIcons.comment, color: Colors.grey,
                       size: 28,
                    ),
                  ),
                  new SizedBox(
                    width: 16.0,
                  ),
                new Icon( FontAwesomeIcons.shareAlt,color: Colors.grey,
                    size: 28,),
                ],
              ),
            //  new Icon(FontAwesomeIcons.bookmark, color: Colors.grey)
            ],
          ),
        ),
         Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
        FutureBuilder(
          future:
              _repository.fetchPostLikes(widget.list[widget.index].reference),
          builder:
              ((context, AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
            if (likesSnapshot.hasData) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => LikesScreen(
                                user: widget.user,
                                documentReference:
                                    widget.list[widget.index].reference,
                              ))));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: likesSnapshot.data.length > 1
                      ? Text(
                          "${(likesSnapshot.data.length - 1).toString()} Likes ",
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),
                        )
                      : Text(likesSnapshot.data.length == 1
                          ? "${(likesSnapshot.data.length).toString()} Likes  "
                          : "0 Likes", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),
                          ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
        ),
        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: commentWidget(widget.list[widget.index].reference)),
                        ]),
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: widget.list[widget.index].data['caption'] != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          /*Text(widget.user.username,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),*/
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child:
                                Text(widget.list[widget.index].data['caption'], 
                                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                          )
                        ],
                      ),
                     /* Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: commentWidget(
                              widget.list[widget.index].reference))*/
                    ],
                  )
                : commentWidget(widget.list[widget.index].reference)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text("1 Day Ago", style: TextStyle(color: Colors.grey)),
        )
        
      ],
    );
  }

  void postLike(DocumentReference reference) {
    var _like = Like(
        ownerName: widget.user.username,
        ownerPhotoUrl: widget.user.imageUrl,
        ownerUid: widget.user.id,
        timeStamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .document(widget.user.id)
        .setData(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  void postUnlike(DocumentReference reference) {
    reference
        .collection("likes")
        .document(widget.user.id)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
  }
}