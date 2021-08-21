import 'dart:convert';
import 'package:airtable_sheet_phrasestest/widget/color_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '1menu_phrase1.dart';
import 'bottomsheet.dart';

class TwoMenuPhrase extends StatefulWidget {
  @override
  _TwoMenuPhraseState createState() => _TwoMenuPhraseState();
}

class _TwoMenuPhraseState extends State<TwoMenuPhrase> {
  List records = [];

  double topContainer = 0;

  final style = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

  final style1 = TextStyle(
    fontSize: 18,
  );
  bool isVisible = true;

  final key = GlobalKey<ScaffoldState>();

  Future _fetchMenus() async {
    var tblname = Get.arguments[0];
    var viewname = Get.arguments[1];

    bool loadRemoteDatatSucceed = false;

    final url = Uri.parse(
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&view=Grid%20view",
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&cat2=2",
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/$tblname?maxRecords=500&view=$viewname",
      "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/$tblname?maxRecords=500&view=Gridview",
      //"https://api.airtable.com/v0/%2FappgEJ6eE8ijZJtAp/menus?%3D1&maxRecords=500&filterByFormula=({cat1}='2')&fields[]=id",
      //"https://api.airtable.com/v0/%2FappgEJ6eE8ijZJtAp/menus?fields%5B%5D=&filterByFormula=%7Bcat1%7D+%3D+%222%22',
    );
    print(url);
    Map<String, String> header = {"Authorization": "Bearer keyyG7I9nxyG5SmTq"};
    try {
      final response = await http.get(url, headers: header);

      Map<String, dynamic> result = json.decode(response.body);
      records = result['records'];
      // .cast<Map<String, dynamic>>();
      // print("print1");
      // print(records);
    } catch (e) {
      if (loadRemoteDatatSucceed == false) retryFuture(_fetchMenus, 2000);
    }
    return records;

    //return body.map<User>(User.fromJson).toList();
  }

  retryFuture(future, delay) {
    Future.delayed(Duration(milliseconds: delay), () {
      future();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(Get.arguments[1]),
      ),
      // ignore: unnecessary_null_comparison
      body: FutureBuilder(
          future: _fetchMenus(),
          builder: (context, snapshot) {
            print('snapshot No.=>');
            print(this.records.length);

            if (!snapshot.hasData)
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.amber),
              ));
            else {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: this.records.length,
                itemBuilder: (BuildContext context, int index) {
                  // if (this.records[index]['fields']['isOneLevel'].toString() ==
                  //     'yes') {
                  //   isVisible = true;
                  // }

                  if (index == 0 ||
                      this.records[index - 1]['fields']['id'] !=
                          this.records[index]['fields']['id']) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: new Icon(Icons.photo),
                          title: Text(
                            this.records[index]['fields']['eng'].toString(),
                            style: GoogleFonts.nanumGothic(
                              // backgroundColor: Colors.white70,
                              textStyle: style,
                              // fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // item,
                      ],
                      // item,
                      // Text(
                      //   this.records[index]['fields']['eng'].toString(),
                      //   style: GoogleFonts.nanumGothic(
                      //     // backgroundColor: Colors.white70,
                      //     textStyle: style,
                      //     // fontStyle: FontStyle.italic,
                      //     color: Colors.blue,
                      //   ),
                      // ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Text(
                        this.records[index]['fields']['eng'].toString(),
                        style: GoogleFonts.nanumGothic(
                          // backgroundColor: Colors.white70,
                          textStyle: style1,
                          // fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  }
                },
              );
            }
          }),
    );
  }
}
