
//•	Story: {username, uid, List<photo or video>, Travelstory, destination-rating,
class TravelStory {
  final String uid;
  final String userName;
  final String storyTitle;
  final List<String> photos;
  final String travelStory;
  final int destinationRating;
  TravelStory({
    required this.uid,
    required this.userName,
    required this.storyTitle,
    required this.photos,
    required this.travelStory,
    required this.destinationRating,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': userName,
      'storyTitle':storyTitle,
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
        photos: map['photos'],
        travelStory: map['travelStory'],
        destinationRating: map['destinationRating']);
  }
}
