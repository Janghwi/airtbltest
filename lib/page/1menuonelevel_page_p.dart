import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../model/menu.dart';
//import '2menutwolevel_page2.dart';
//import '2menutwolevel_page_p.dart';
import 'package:http/http.dart' as http;

class MenuOnelevelPageP extends StatelessWidget {
  List records = [];

  Future fetchMenus() async {
    final url = Uri.parse(
      "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=3&view=Grid%20view",
    );
    Map<String, String> header = {"Authorization": "Bearer keyyG7I9nxyG5SmTq"};
    final response = await http.get(url, headers: header);

    Map<String, dynamic> result = json.decode(response.body);
    records = result['records'];
    // .cast<Map<String, dynamic>>();
    print("print1");
    print(records);

    return records;

    //return body.map<User>(User.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // ignore: unnecessary_null_comparison
      body: FutureBuilder(
          future: fetchMenus(),
          builder: (context, snapshot) {
            print(snapshot);

            if (!snapshot.hasData)
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.amber),
              ));
            else {
              return StaggeredGridView.countBuilder(
                staggeredTileBuilder: (int idx) =>
                    new StaggeredTile.count(2, idx.isEven ? 3 : 2),
                physics: BouncingScrollPhysics(),
                itemCount: this.records.length,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                crossAxisCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.black54,
                    shadowColor: Colors.grey,
                    elevation: 8,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade600,
                              Colors.blue.shade200
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  this.records[index]['fields'].eng,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),

                                SizedBox(
                                  height: 12,
                                ),
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      this.records[index]['fields'].url),
                                  radius: 40,
                                ),
                                // Text(
                                //   menusOut.kor,
                                //   style: TextStyle(fontSize: 20, color: Colors.white),
                                // ),
                                // Text(
                                //   menusOut.jap,
                                //   style: TextStyle(fontSize: 20, color: Colors.white),
                                // ),
                              ],
                            )),
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
