import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:whatsapp_clone/models/like.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/screens/calls_screen/widgets/repository/fake_repository.dart';
import 'package:whatsapp_clone/services/repository.dart';

class ListPosts extends StatefulWidget {
  List<DocumentSnapshot> list;
  User user;
  int index;

  ListPosts({this.list, this.user, this.index});

  @override
  _ListPostsState createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
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
             /* Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            documentReference: reference,
                            user: widget.user,
                          ))));*/
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

 Widget _rightSideButtonsWidgets() {
  return Positioned(
                    right: 10,
                    bottom: 40,
                    child: Column(
                      children: <Widget>[
         FutureBuilder(
          future:
              _repository.fetchPostLikes(widget.list[widget.index].reference),
          builder:
              ((context, AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
            if (likesSnapshot.hasData) {                  
                        SizedBox(
                          height: 15,
                        );
                        GestureDetector(
                                    child: _isLiked
                                        ? Icon(
                                              FontAwesomeIcons.fire,
                                              size: 38,
                                              color: Colors.orange[300],
                                            )
                                        : Icon(
                                            FontAwesomeIcons.fire,
                                            size: 38,
                                            color: Colors.white70
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
                                    });
                                    SizedBox(
                                      height: 5, );
                                      Container(
                                        child: likesSnapshot.data.length > 1
                                   ? Text("${(likesSnapshot.data.length - 1).toString()} Likes ",
                                    style:TextStyle(fontWeight: FontWeight.bold,color: Colors.white70 ))
                                  :  Text(likesSnapshot.data.length == 1
                                      ? "${(likesSnapshot.data.length).toString()} Likes  "
                                      : "0 Likes"),
                                      );
                                    
                                    
                                 }
                                 })
                               ),   
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Icon(FontAwesomeIcons.comment, size: 38, color: Colors.white70,),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                             child: commentWidget(
                              widget.list[widget.index].reference))
                                ],
                              )
                            
                           )
                        ],
                          ),
                    
                        );

                        SizedBox(
                          height: 25,
                        );
                        Container(
                          child: Icon(FontAwesomeIcons.shareAlt, size: 38,color: Colors.white70),
                        );
                        SizedBox(
                          height: 25,
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

  Widget _textDataWidgetBottom(SizingInformation sizingInformation, int index) {
    return Positioned(
      bottom: 20,
      left: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          
            child: Row(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                         child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: Image.asset(
                      widget.user.imageUrl,
                      fit: BoxFit.cover,
                    )),
              ),),
                SizedBox(
                  width: 10,
                ),
                Text(widget.user.username,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18,color: Colors.white70),)
              ],
            ),
          ),
          /*SizedBox(
            height: 10,
          ),*/
          /*Text(
            "Follow",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16,color: Colors.white70),
          ),*/
          SizedBox(
            height: 10,
          ),
          Container(
            width: sizingInformation.localWidgetSize.width * 0.80,
            child: widget.list[widget.index].data['caption'] != null
            ?
             Text(
              widget.list[widget.index].data['caption'],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14,color: Colors.white70),
            ):Container(),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.white70,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                 Container(
              width: sizingInformation.localWidgetSize.width * 0.70,
              child: widget.list[widget.index].data['location'] != null
              ? Text(widget.list[widget.index].data['location'],
              style: TextStyle(color: Colors.white70)):Container(),),
            
                 SizedBox(
            height: 25,
          ),

             

              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) {
        return Scaffold(
            body: Stack(
          children: <Widget>[
            PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: FakeRepository.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  children: <Widget>[ 
                    CachedNetworkImage(
                          imageUrl: widget.list[widget.index].data['imgUrl'],
                           placeholder: ((context, s) => Center(
                                 child: CircularProgressIndicator(),
                              )),
                                  fit: BoxFit.cover,
                    ),
                    _rightSideButtonsWidgets(),
                    _textDataWidgetBottom(sizingInformation, index),
                  ],
                );
              },
            ),
           // _topWidgetFollowingAndForYou(),
           // NavBar(),
          ],
          
        ));
      },
    );
  }
}
