import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/models/posts.dart';
import 'package:whatsapp_clone/providers/chat.dart';
//import 'package:socialize/widgets/custom_image.dart';
//import 'package:socialize/widgets/post.dart';
//import 'package:socialize/pages/post_screen.dart';
import 'package:whatsapp_clone/screens/profile_screen/widgets/post.dart';

class PostTile extends StatelessWidget {
  final Post post;
  showPost(context){
   // Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen(userId: post.ownerId,postId: post.postId,)));
  }
  PostTile(this.post);
  @override
  Widget build(BuildContext context) {
    var imageUrl = Provider.of<Post>(context).imgUrl;
    return GestureDetector(
      child: Image.network(imageUrl),
      onTap:()=> showPost(context),
    );
  }
}
