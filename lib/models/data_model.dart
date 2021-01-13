
class DataModel{
  final String name;
  final String likesCount;
  final String messagesCount;
  final String forwardCount;
  final String description;
  final String location;
  final String musicName;
  final String profileUrl;

  DataModel({this.name, this.likesCount, this.messagesCount, this.forwardCount, this.description, this.location, this.musicName,this.profileUrl});
}

class VideoModel {
  String img;
  VideoModel(this.img);
}

List<VideoModel> videos = [
  VideoModel("assets/images/gucci.jpg"),
  VideoModel("assets/images/mk.png"),
  VideoModel("assets/images/nike.png"),
  VideoModel("assets/images/vers.png"),
  VideoModel("assets/images/zara.png"),
];