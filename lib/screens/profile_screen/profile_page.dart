import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/models/posts.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/providers/chat.dart';
//import 'package:whatsapp_clone/screens/calls_screen/calls_screen.dart';
//import 'package:whatsapp_clone/screens/profile_screen/ListPost.dart';
//import 'package:whatsapp_clone/screens/profile_screen/widgets/post.dart';
import 'package:whatsapp_clone/services/db.dart';
import 'package:whatsapp_clone/services/repository.dart';
//import 'package:three_six_five/profile/edit_profile.dart';
//import 'package:three_six_five/profile_screen/settings.dart';
import '../../consts.dart';
import 'LIstItems.dart';
import 'profile_info.dart';

User currentUser;

class ProfilePage extends StatefulWidget {
  final User contact;
  final String groupId;
  final profileId;

  const ProfilePage({Key key, this.contact, this.groupId, this.profileId})
      : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentUserId = currentUser?.id;
  String postOrientation = 'grid';
  List<Post> posts = [];
  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;
  bool isLoading = false;
  bool isFollowing = false;
  DB db;
  var _repository = Repository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser currentuser;
  User details;
  String _userId;
  Future<List<DocumentSnapshot>> _future;
  int _displayPosts = 0;
  bool _isGridActive = true;

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
    initUser();
  }

  initUser() async {
    currentuser = await _auth.currentUser();
    details = await _repository.retrieveUserDetails(currentuser);
    setState(() {
      currentUser = details;
    });
  }

  retrieveUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retrieveUserDetails(currentUser);
    setState(() {
      details = user;
    });
    _future = _repository.retrieveUserPosts(details.id);
  }

  _buildTilePost(Post post) {
    return GridTile(
      child: Image(
        image: CachedNetworkImageProvider(post.imgUrl),
        fit: BoxFit.cover,
      ),
      //  ),
    );
  }


   _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on,),
          iconSize: 30.0,
          color:_isGridActive == true
              ? Theme.of(context).accentColor
              : Colors.black,
          onPressed: () => setState(() {
            _isGridActive = true;
          }),
        ),
        IconButton(
          icon: Icon(Icons.list),
          iconSize: 30.0,
          color: _isGridActive == false
              ? Theme.of(context).accentColor
              : Colors.black,
          onPressed: () => setState(() {
            _isGridActive = false;
          }),
        ),
      ],
    );
  }

  Widget postImagesWidget() {
    return _isGridActive == true
        ? FutureBuilder(
            future: _future,
            builder:
                ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0),
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data[index].data['imgUrl'],
                          placeholder: ((context, s) => Center(
                                child: CircularProgressIndicator(),
                              )),
                          width: 125.0,
                          height: 125.0,
                          fit: BoxFit.cover,
                        ),
                        onTap: () {
                          print(
                              "SNAPSHOT : ${snapshot.data[index].reference.path}");
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => PostDetailScreen(
                                        user: _user,
                                        currentuser: _user,
                                        documentSnapshot: snapshot.data[index],
                                      ))));*/
                        },
                      );
                    }),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('No Posts Found'),
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
          )
        : FutureBuilder(
            future: _future,
            builder:
                ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                      height: 600.0,
                      child: ListView.builder(
                          //shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: ((context, index) => ListItem(
                              list: snapshot.data,
                              index: index,
                              user: details))));
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

  Column buildCountColumn(
    String count,
    String label,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  getInfo(BuildContext context, FirebaseUser currentuser) {
    var imageUrl = Provider.of<Chat>(context).imageUrl;
    Size size = MediaQuery.of(context).size;
    //User _user;
    // User user = User.fromMap();
    db = DB();
    return Container(
      height: size.height * 0.40,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageUrl.isEmpty
              ? AssetImage("assets/no_image.png")
              : CachedNetworkImageProvider(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 36,
          ),
          CircleAvatar(
            radius: 48,
            backgroundImage: imageUrl.isEmpty
                ? AssetImage("assets/no_image.png")
                : CachedNetworkImageProvider(imageUrl),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            currentuser.displayName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          _About(contact: currentUser),

          /*Text(
            details.email,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),*/
          Expanded(
            child: Container(),
          ),
          Container(
            height: 64,
            color: Colors.black.withOpacity(0.4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                StreamBuilder(
                  stream: _repository
                      .fetchStats(uid: details.id, label: 'POSTS')
                      .asStream(),
                  builder: ((context,
                      AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          width: 110,
                          child: buildCountColumn(
                              'Posts', snapshot.data.length.toString()));
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
                ),
                StreamBuilder(
                  stream: _repository
                      .fetchStats(uid: details.id, label: 'following')
                      .asStream(),
                  builder: ((context,
                      AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          width: 110,
                          child: buildCountColumn(
                              'Following', snapshot.data.length.toString()));
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
                ),
                StreamBuilder(
                  stream: _repository
                      .fetchStats(uid: details.id, label: 'followers')
                      .asStream(),
                  builder: ((context,
                      AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          width: 110,
                          child: buildCountColumn(
                              'Followers', snapshot.data.length.toString()));
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
                ),
                Expanded(
                  child: Container(),
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
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: details != null 
          ? SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      getInfo(context, currentuser),
                      _buildToggleButtons(),
                      Divider(),
                      postImagesWidget(),
                    ],
                  ),
                  Positioned(
                    top: 10,
                    left: 16,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileInfo()),
                        );
                      },
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        /* Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingsPage()),
                            );*/
                      },
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(),
    );
  }
}

class _About extends StatelessWidget {
  final User contact;
  const _About({
    Key key,
    this.contact,
  }) : super(key: key);

  /* String getAboutChangeDate(DateTime changeDate) {
    if (changeDate == null) return 'Not Available';
    return DateFormat('MMMM dd yyyy').format(changeDate);
  }*/

  @override
  Widget build(BuildContext context) {
    return Text(
      currentUser.about ?? 'Not Available.',
      style: TextStyle(fontSize: 16, color: kBaseWhiteColor),
    );

    /*Text(
            getAboutChangeDate(contact.aboutChangeDate),
            style: kChatItemSubtitleStyle,
          ),*/
  }
}

class PostTile extends StatelessWidget {
  final Post post;

  showPost(context) {
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen(userId: post.ownerId,postId: post.postId,)));
  }
  PostTile(this.post);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.network(post.imgUrl),
      onTap: () => showPost(context),
    );
  }
}
