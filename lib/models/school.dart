import 'package:cloud_firestore/cloud_firestore.dart';

class School {
  int npsn;
  String name;
  double lat;
  double long;
  String desc;
  DocumentReference ref;
  School({this.desc, this.lat, this.long, this.name, this.npsn,this.ref});
  factory School.fromJson(Map json) => School(
      npsn: json['npsn'],
      name: json['nama'],
      desc: json['desc'],
      lat: json['lat'],
      long: json['long']);
  get map =>
      {'npsn': npsn, 'nama': name, 'desc': desc, 'lat': lat, 'long': long};
}
