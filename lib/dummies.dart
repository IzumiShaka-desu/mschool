import 'models/school.dart';

List<School> schools =
    List.generate(12, (index) => School(npsn: index, name: "sekolah $index",desc: "ini sekolah ke $index",lat: 12312,long: 1233));
