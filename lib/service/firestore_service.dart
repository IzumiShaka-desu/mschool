import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mschool/models/school.dart';

class FirestoreService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  addSchool(School school) async {
    var ref = _firestore.collection('school');
    ref.add(school.map);
  }

  Future<List<School>> getData() async {
    List<School> list = [];
    var ref = _firestore.collection('school');
    var result = await ref.get();
    if (result.docs.length > 0) {
      result.docs.forEach((element) {
        School sch=School.fromJson(element.data());
        sch.ref=element.reference;
        list.add(sch);
      });
    }
    return list;
  }
}
