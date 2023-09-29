import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:traveler/data/repository/database.dart';

class DeleteTravelListItem {
  final String destination;

  DeleteTravelListItem({required this.destination});
  Future<bool> deleteTravelList() async {
    try {
      DatabaseService.userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'upcomingtrips': FieldValue.arrayRemove([destination])
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
