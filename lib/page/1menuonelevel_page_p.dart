import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../model/menu.dart';
//import '2menutwolevel_page2.dart';
//import '2menutwolevel_page_p.dart';
import 'package:http/http.dart' as http;

import '2menutwolevel_page_p.dart';

class MenuOnelevelPageP extends StatelessWidget {
  List records = [];

  Future fetchMenus() async {
    final url = Uri.parse(
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&view=Grid%20view",
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&cat2=2",
      "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&view=Grid%20view",
      //"https://api.airtable.com/v0/%2FappgEJ6eE8ijZJtAp/menus?%3D1&maxRecords=500&filterByFormula=({cat1}='2')&fields[]=id",
      //"https://api.airtable.com/v0/%2FappgEJ6eE8ijZJtAp/menus?fields%5B%5D=&filterByFormula=%7Bcat1%7D+%3D+%222%22',
    );
    Map<String, String> header = {"Authorization": "Bearer keyyG7I9nxyG5SmTq"};
    final response = await http.get(url, headers: header);

    Map<String, dynamic> result = json.decode(response.body);
    records = result['records'];
    // .cast<Map<String, dynamic>>();
    // print("print1");
    // print(records);

    return records;

    //return body.map<User>(User.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      // ignore: unnecessary_null_comparison
      body: FutureBuilder(
          future: fetchMenus(),
          builder: (context, snapshot) {
            print('snapshot No.=>');
            print(this.records.length);

            if (!snapshot.hasData)
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.amber),
              ));
            else {
              return StaggeredGridView.countBuilder(
                staggeredTileBuilder: (int idx) =>
                    new StaggeredTile.count(2, idx.isEven ? 2.3 : 2),
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
                      onTap: () => Get.to(MenuTwolevelPage(),
                          arguments: [
                            this.records[index]['fields']['cat1'],
                            this.records[index]['fields']['eng']
                          ],
                          transition: Transition.zoom),
                      child: Stack(alignment: Alignment.center, children: [
                        Ink.image(
                          image: NetworkImage(
                              this.records[index]['fields']['url'].toString()),
                          child: InkWell(
                            onTap: () {},
                          ),
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          left: 16,
                          child: Text(
                            this.records[index]['fields']['eng'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ]),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}

