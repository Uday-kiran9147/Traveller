import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:traveler/data/repository/database.dart';

class AddTravelItem {
  final String destination;
  AddTravelItem({required this.destination});
  Future<bool> addTravelList() async {
    try {
      DatabaseService.userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'upcomingtrips': FieldValue.arrayUnion([destination])
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
