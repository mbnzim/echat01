import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/models/post_model.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/models/user_data.dart';
import 'package:whatsapp_clone/providers/chat.dart';
import 'package:whatsapp_clone/screens/calls_screen/calls_screen.dart';
import 'package:whatsapp_clone/services/db.dart';
import 'package:whatsapp_clone/services/repository.dart';
import 'package:whatsapp_clone/services/storage.dart';
import 'package:whatsapp_clone/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_clone/consts.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:whatsapp_clone/screens/home.dart';

final StorageReference storageRef = FirebaseStorage.instance.ref();
final postsRef = Firestore.instance.collection('posts');
final DateTime timeStamp = DateTime.now();

class UploadPage extends StatefulWidget {
  final User currentUser;
  FirebaseUser user;
  File imageFile;
  UploadPage({this.currentUser, this.imageFile});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  bool isUploading = false;
  String postId = Uuid().v4();
  File file;
  final _repository = Repository();
  bool _isLoading = false;
  String _caption = '';
  String _location = '';

  handleTakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      this.file = file;
    });
  }

  handleGallaryPhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    final size = MediaQuery.of(context).size;
    return showDialog(
      context: parentContext,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: kBlackColor2,
        title: Text('Choose Image'),
        content: Container(
          height: size.height * 0.22,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: handleTakePhoto,
                    child: Wrap(
                      direction: Axis.vertical,
                      children: [
                        Image.asset('assets/images/camera.png',
                            width: 50, height: 50),
                        SizedBox(height: 10),
                        Text('Camera'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: handleGallaryPhoto,
                    child: Wrap(
                      direction: Axis.vertical,
                      children: [
                        Image.asset('assets/images/photos_android.png',
                            width: 50, height: 50),
                        SizedBox(height: 10),
                        Text('Gallery'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    width: size.width * 0.4,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kBaseWhiteColor,
                      ),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }

  Container displayUploadScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.add_photo_alternate,
            color: Colors.grey,
            size: 200.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.0),
              ),
              child: Text(
                "Upload Image",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () => selectImage(context),
            ),
          )
        ],
      ),
    );
  }

  clearPostInfo() {
    locationController.clear();
    captionController.clear();
    setState(() {
      file = null;
    });
  }

  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placeMarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark placeMark = placeMarks[0];
    // String addressinfo = '${placeMark.postalCode},${placeMark.subThoroughfare},${placeMark.thoroughfare}, ${placeMark.subLocality},${placeMark.administrativeArea},${placeMark.country}';
    String adress = '${placeMark.locality}, ${placeMark.country}';
    locationController.text = adress;
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(file.readAsBytesSync());
    //Im.copyResize(image);

    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      file = newim2;
    });
    print('done');
  }

  /*Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child('post_$postId.jpg').putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    return await storageSnap.ref.getDownloadURL();
  }
  

  createPostInFireStore({String mediaUrl, String location, String caption}) {
    postsRef
        .document((widget.currentUser.id))
        .collection('usersPosts')
        .document(postId)
        .setData({
      'postId': postId,
      'ownerId': widget.currentUser.id,
      'username': widget.currentUser.username,
      'mediaUrl': mediaUrl,
      'caption': caption,
      "location": location,
      'timeStamp': timeStamp,
      'likes': {}
    });
  }*/

  Future<String> uploadImage(var imageFile) async {
    var uuid = Uuid().v1();
    StorageReference ref =
        FirebaseStorage.instance.ref().child("post_$uuid.jpg");
    StorageUploadTask uploadTask = ref.putFile(file);

    String downloadUrl =
        await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl;
  }

  void postToFireStore(
      {String mediaUrl, String location, String caption}) async {
    var reference = Firestore.instance.collection('365_posts');

    reference.add({
      "username": currentUser.username,
      "location": location,
      "likes": {},
      "mediaUrl": mediaUrl,
      'caption': caption,
      "ownerId": currentUser.id,
      "timestamp": DateTime.now(),
    }).then((DocumentReference doc) {
      String docId = doc.documentID;
      reference.document(docId).updateData({"postId": docId});
    });
  }

  void postImage() {
    setState(() {
      isUploading = true;
    });
    uploadImage(file).then((String data) {
      postToFireStore(
          mediaUrl: data,
          caption: captionController.text,
          location: locationController.text);
    }).then((_) {
      setState(() {
        file = null;
        isUploading = false;
      });
    });
  }

 /* _submit() async {
    if (!_isLoading &&
        file != null &&
        _caption.isNotEmpty &&
        _location.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      // Create post
      String imageUrl = await Storage.uploadPost(file);
      PostModel post = PostModel(
        imageUrl: imageUrl,
        caption: captionController.text,
        location: locationController.text,
        likeCount: 0,
        authorId: Provider.of<UserData>(context).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      DB.createPost(post);
     Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: ((context) => Home())));

      // Reset data
      captionController.clear();
      locationController.clear();

      setState(() {
        captionController.text = '';
        locationController.text = '';
        file = null;
        _isLoading = false;
      });
    }
  }*/

  displayUploadFormScreen(BuildContext context, FirebaseUser user) {
    var imageUrl = Provider.of<Chat>(context).imageUrl;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => clearPostInfo(),
        ),
        title: Center(
            child: Text(
          'New Post',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
        )),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Post',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Theme.of(context).accentColor,
              ),
            ),
            onPressed: () => //_submit(), //isUploading ? null :  postImage,

            _repository.getCurrentUser().then((currentUser) {
                    if (currentUser != null) {
                      compressImage();
                      _repository.retrieveUserDetails(currentUser).then((user) {
                        _repository.uploadImageToStorage(file).then((url) {
                          _repository
                              .addPostToDb(user, url, captionController.text,
                                  locationController.text)
                              .then((value) {
                            print("Post added to db");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => Home())));
                          }).catchError((e) => print(
                                  "Error adding current post to db : $e"));
                        }).catchError((e) {
                          print("Error uploading image to storage : $e");
                        });
                      });
                    } else {
                      print("Current User is null");
                    }
                  })
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? LinearProgressIndicator() : Text(""),
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width * .8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(file),
                  )),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(imageUrl),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                  hintText: 'Write a caption ...',
                  border: InputBorder.none,
                ),
                onChanged: (input) => _caption = input,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              size: 36.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: 'Write the location here.',
                  border: InputBorder.none,
                ),
                onChanged: (input) => _location = input,
              ),
            ),
          ),
          Container(
            width: 220.0,
            height: 110.0,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              label: Text('Get current location'),
              icon: Icon(
                Icons.my_location,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Theme.of(context).accentColor,
              onPressed: () => getUserLocation(),
            ),
          )
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    final user = Provider.of<Chat>(context).getUser;
    return file == null
        ? displayUploadScreen()
        : displayUploadFormScreen(context, user);
  }
}
