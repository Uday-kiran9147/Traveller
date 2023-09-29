import 'package:traveler/data/repository/database.dart';

class DeleteTravelStory {
  final String storyid;
  DeleteTravelStory({required this.storyid});
  Future<String> deleteStory() async {
    try {
      await DatabaseService.travelStoryCollection.doc(storyid).delete();
      return 'Deleted Successfully';
    } catch (e) {
      return e.toString();
    }
  }
}
