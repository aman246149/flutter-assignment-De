
import 'package:cloud_firestore/cloud_firestore.dart';


class HomeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getGoals() {
    try {
      return _firestore
          .collection('goals')
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

}
