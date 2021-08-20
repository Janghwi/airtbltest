import 'dart:convert';
import 'package:airtable_sheet_phrasestest/widget/color_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '1menuonelevel_page_p.dart';
import 'bottomsheet.dart';

class MenuTwolevelPage1 extends StatelessWidget {
  List records = [];
  double topContainer = 0;

  Future _fetchMenus() async {
    var tblname = Get.arguments[0];
    var viewname = Get.arguments[1];

    bool loadRemoteDatatSucceed = false;

    final url = Uri.parse(
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&view=Grid%20view",
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&cat2=2",
      "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/$tblname?maxRecords=500&view=$viewname",
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
                  double scale = 1.0;
                  if (topContainer > 0.5) {
                    scale = index + 0.5 - topContainer;
                    if (scale < 0) {
                      scale = 0;
                    } else if (scale > 1) {
                      scale = 1;
                    }
                  }
                  return Card(
                    shadowColor: Colors.grey,
                    elevation: 3,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Ink.image(
                          image: NetworkImage(
                            this
                                .records[index]['fields']['image_url']
                                .toString(),
                          ),
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.7), BlendMode.dstATop),
                          // colorFilter: ColorFilters.greyscale,
                          child: InkWell(
                            onTap: () => Get.bottomSheet(Container(
                              height: 400,
                              color: Colors.grey,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  ListTile(
                                    leading: new Icon(Icons.photo),
                                    title: new Text('Photo'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(Icons.music_note),
                                    title: new Text('Music'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(Icons.videocam),
                                    title: new Text('Video'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(Icons.share),
                                    title: new Text('Share'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            )),
                          ),
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          left: 16,
                          child: Text(
                            this.records[index]['fields']['eng'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
