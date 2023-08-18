
//•	Story: {username, uid, List<photo or video>, Travelstory, destination-rating,
class TravelStory {
  final String uid;
  final String userName;
  final String storyTitle;
  final String created_at;
  final int likes;
  final List<dynamic> photos;
  final String travelStory;
  final double destinationRating;
  TravelStory({
    required this.uid,
    required this.userName,
    required this.storyTitle,
    required this.likes,
    required this.created_at,
    required this.photos,
    required this.travelStory,
    required this.destinationRating,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': userName,
      'storyTitle':storyTitle,
      'created_at':created_at,
      'likes': likes,
      'photos': photos,
      'travelStory': travelStory,
      'destinationRating': destinationRating
    };
  }

  static TravelStory fromMap(Map<String, dynamic> map) {
    return TravelStory(
        uid: map['uid'],
        userName: map['username'],
        storyTitle:map['storyTitle'],
        likes: map['likes'],
        created_at:map['created_at'],
        photos: map['photos'],
        travelStory: map['travelStory'],
        destinationRating: map['destinationRating']);
  }
}
