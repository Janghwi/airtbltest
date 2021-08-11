import 'dart:convert';

class MenuFields {
  static final String id = 'id';
  static final String catid = 'catid';
  static final String eng = 'eng';
  static final String kor = 'kor';
  static final String jap = 'jap';
  static final String url = 'url';
  static final String cat1 = 'cat1';
  static final String cat2 = 'cat2';
  static final String date = 'date';
  //static final String url = 'https://picsum.photos/id/237/200/300';

  static Future<List<String>> getMenus() async =>
      [id, catid, eng, kor, jap, url, cat1, cat2, date];
}

class Menu {
  final String id;
  final String catid;
  final String eng;
  final String kor;
  final String jap;
  final String url;
  final String cat1;
  final String cat2;
  final String date;

  const Menu({
    required this.id,
    required this.catid,
    required this.eng,
    required this.kor,
    required this.jap,
    required this.url,
    required this.cat1,
    required this.cat2,
    required this.date,
  });

  Menu copy({
    id,
    catid,
    eng,
    kor,
    jap,
    url,
    cat1,
    cat2,
    date,
  }) =>
      Menu(
        id: id ?? this.id,
        catid: catid ?? this.catid,
        eng: eng ?? this.eng,
        kor: kor ?? this.kor,
        jap: jap ?? this.jap,
        url: url ?? this.url,
        cat1: cat1 ?? this.cat1,
        cat2: cat2 ?? this.cat2,
        date: date ?? this.date,
      );

  static Menu fromJson(Map<String, dynamic> json) => Menu(
        id: json[MenuFields.id].toString(),
        catid: json[MenuFields.catid].toString(),
        eng: json[MenuFields.eng].toString(),
        kor: json[MenuFields.kor].toString(),
        jap: json[MenuFields.jap].toString(),
        url: json[MenuFields.url].toString(),
        cat1: json[MenuFields.cat1].toString(),
        cat2: json[MenuFields.cat2].toString(),
        date: json[MenuFields.date].toString(),
      );
  //   eng, engc, kor,    korc, korprn, korprnc, jap, japc, japprn,japprnc, level, cat1, st, stk, stj,place, isq ,qtp isall,date,
//
//
  Map<String, dynamic> toJson() => {
        MenuFields.id: id,
        MenuFields.catid: catid,
        MenuFields.eng: eng,
        MenuFields.kor: kor,
        MenuFields.jap: jap,
        MenuFields.url: url,
        MenuFields.cat1: cat1,
        MenuFields.cat2: cat2,
        MenuFields.date: date,
      };
}
