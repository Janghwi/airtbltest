import 'dart:convert';
import 'dart:io';
import 'package:airtable_sheet_phrasestest/widget/color_filters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
//import '2menutwolevel_page2.dart';
//import '2menutwolevel_page_p.dart';
import 'package:http/http.dart' as http;

import '2menutwolevel_page_exp.dart';
import '2menutwolevel_page_exp1.dart';
import '2menutwolevel_page_p.dart';

class OnelevelGolf extends StatelessWidget {
  List records = [];
  final style = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  final style1 = TextStyle(
    fontSize: 15,
  );

  Future _fetchMenus() async {
    bool loadRemoteDatatSucceed = false;
    final url = Uri.parse(
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&view=Gridview",
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&cat2=2",
      "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/golfmenus?maxRecords=500&view=Gridview",
      //"https://api.airtable.com/v0/%2FappgEJ6eE8ijZJtAp/menus?%3D1&maxRecords=500&filterByFormula=({cat1}='2')&fields[]=id",
      //"https://api.airtable.com/v0/%2FappgEJ6eE8ijZJtAp/menus?fields%5B%5D=&filterByFormula=%7Bcat1%7D+%3D+%222%22',
    );
    Map<String, String> header = {"Authorization": "Bearer keyyG7I9nxyG5SmTq"};
    try {
      final response = await http.get(url, headers: header);
      Map<String, dynamic> result = json.decode(response.body);
      records = result['records'];
    } catch (e) {
      if (loadRemoteDatatSucceed == false) retryFuture(_fetchMenus, 2000);
    }

    return records;
  }

  retryFuture(future, delay) {
    Future.delayed(Duration(milliseconds: delay), () {
      future();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
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
              return StaggeredGridView.countBuilder(
                staggeredTileBuilder: (int idx) =>
                    new StaggeredTile.count(2, idx.isEven ? 1.3 : 2),
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
                    child: Stack(alignment: Alignment.center, children: [
                      Ink.image(
                        image: NetworkImage(
                          this.records[index]['fields']['image_url'].toString(),
                        ),
                        // colorFilter: ColorFilters.greyscale,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.dstATop),
                        child: InkWell(
                          onTap: () => Get.to(MenuTwolevelPageExp1(),
                              arguments: [
                                this.records[index]['fields']['go_tbl'],
                                this.records[index]['fields']['go_view'],
                                //this.records[index]['fields']['cat1'],
                                this.records[index]['fields']['eng']
                              ],
                              transition: Transition.zoom),
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
                          style: GoogleFonts.nanumGothic(
                            // backgroundColor: Colors.white70,
                            textStyle: style,
                            // fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 5,
                        // left: 16,
                        child: Text(
                          this.records[index]['fields']['topic_no'].toString(),
                          style: GoogleFonts.nanumGothic(
                            // backgroundColor: Colors.white70,
                            textStyle: style1,
                            // fontStyle: FontStyle.italic,
                            color: Colors.white70,
                          ),
                        ),
                      )
                    ]),
                  );
                },
              );
            }
          }),
    );
  }
}
