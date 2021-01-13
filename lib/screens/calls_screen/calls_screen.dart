import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:marquee/marquee.dart';
import 'package:responsive_builder/responsive_builder.dart';
//import 'package:whatsapp_clone/screens/calls_screen/widgets/repository/data.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp_clone/models//story_model.dart';
//import 'package:three_six_five/navigationbar/nav_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_clone/models/user.dart';
//import 'package:whatsapp_clone/screens/calls_screen/gallery.dart';
import 'package:whatsapp_clone/screens/calls_screen/uploadpage.dart';
//import 'package:three_six_five/dashboard/influencer/video_page.dart';
//import 'add_video_page.dart';
import 'widgets/repository/fake_repository.dart';

User currentUser; 
class FeedScreen extends StatefulWidget {
//final List<Story> stories;

 // const FeedScreen({@required this.stories});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  PageController _pageController;
  AnimationController _animController;
  VideoPlayerController _videoController;
  int _currentIndex = 0;
  // ignore: unused_field
  int _followingForYouController = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(vsync: this);

    //final Story firstStory = widget.stories.first;
    //_loadStory(story: firstStory, animateToPage: false);

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController.stop();
        _animController.reset();
       /*setState(() {
          if (_currentIndex + 1 < widget.stories.length) {
         //   _currentIndex += 1;
            _loadStory(story: widget.stories[_currentIndex]);
          } else {
            // Out of bounds - loop story
            // You can also Navigator.of(context).pop() here
            _currentIndex = 0;
            _loadStory(story: widget.stories[_currentIndex]);
          }
        });*/
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    _videoController?.dispose();
    super.dispose();
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
                          imageUrl: 'https://wallpapercave.com/wp/AYWg3iu.jpg',
                          imageBuilder: (context, index) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: index,
                                  fit: BoxFit.cover,
                                  /*colorFilter:
                                      ColorFilter.mode(Colors.red, BlendMode.colorBurn)*/),
                            ),
                          )),
                                 
                    _rightSideButtonsWidgets(index),
                    _textDataWidgetBottom(sizingInformation, index),
                  ],
                );
              },
            ),
            _topWidgetFollowingAndForYou(),
           // NavBar(),
          ],
          
        ));
      },
    );
  }

  Widget _topWidgetFollowingAndForYou() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 0.2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
     
        
          SizedBox(
              width: 350,
            ),
              

          IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UploadPage(currentUser: currentUser,)));
            
          },
        ),   
       ],
        ),
      ),
    );
  }

  Widget _rightSideButtonsWidgets(int index) {
    return Positioned(
      right: 10,
      bottom: 40,
      child: Column(
        children: <Widget>[
        
          SizedBox(
            height: 15,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.fire,
                  size: 38,
                  color: Colors.white70
                ),
                SizedBox(
                  height: 5,
                ),
                Text("${FakeRepository.data[index].likesCount}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold,color: Colors.white70 ))
              ],
            ),
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
                Text("${FakeRepository.data[index].messagesCount}",
                       style:
                          TextStyle(fontWeight: FontWeight.bold,color: Colors.white70 ))
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            child: Icon(FontAwesomeIcons.shareAlt, size: 38,color: Colors.white70),
          ),
          SizedBox(
            height: 25,
          ),
          
        ],
      ),
    );
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
                      FakeRepository.data[index].profileUrl,
                      fit: BoxFit.cover,
                    )),
              ),),
                SizedBox(
                  width: 10,
                ),
                Text("${FakeRepository.data[index].name}",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18,color: Colors.white70),)
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Follow",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16,color: Colors.white70),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: sizingInformation.localWidgetSize.width * 0.80,
            child: Text(
              "${FakeRepository.data[index].description}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14,color: Colors.white70),
            ),
          ),
          SizedBox(
            height: 10,
          ),
         /* Container(
              width: sizingInformation.localWidgetSize.width * 0.70,
              child: Text("${FakeRepository.data[index].location}", style: TextStyle(color: Colors.white70),)),*/
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
              child: Text("${FakeRepository.data[index].location}", style: TextStyle(color: Colors.white70),)),
               /* Container(
                  height: 25,
                  width: sizingInformation.localWidgetSize.width * 0.40,
                  child: Marquee(
                    text: "${FakeRepository.data[index].musicName}",
                    pauseAfterRound: Duration(seconds: 1),
                    startPadding: 10.0,
                    accelerationDuration: Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: Duration(seconds: 1),
                    decelerationCurve: Curves.easeOut,
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    blankSpace: 20.0,
                    velocity: 100.0,
                  ),
                  
                ),*/
                 SizedBox(
            height: 25,
          ),

              /*AnimatedBuilder(
                          builder: (BuildContext context, Widget child) {
                            return Transform.rotate(
                                angle: _animController.value * 6.3, child: child);
                          },
                          animation: _animController,
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: EdgeInsets.all(10),
                           
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
                                    FakeRepository.data[index].profileUrl,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                        ),*/

              ],
            ),
          ),
        ],
      ),
    );
  }

  void _loadStory({Story story, bool animateToPage = true}) {
    _animController.stop();
    _animController.reset();
    switch (story.media) {
      case MediaType.image:
        _animController.duration = story.duration;
        _animController.forward();
        break;
      case MediaType.video:
   
    }
    if (animateToPage) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}

class AnimatedBar extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const AnimatedBar({
    Key key,
    @required this.animController,
    @required this.position,
    @required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                        animation: animController,
                        builder: (context, child) {
                          return _buildContainer(
                            constraints.maxWidth * animController.value,
                            Colors.white,
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildContainer(double width, Color color) {
    return Container(
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}


