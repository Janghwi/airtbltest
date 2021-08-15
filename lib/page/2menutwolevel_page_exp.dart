import 'dart:convert';
import 'package:airtable_sheet_phrasestest/widget/color_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:expansion_tile_card/expansion_tile_card.dart';

import '1menuonelevel_page_p.dart';

class MenuTwolevelPageExp extends StatefulWidget {
  @override
  _MenuTwolevelPageExpState createState() => _MenuTwolevelPageExpState();
}

class _MenuTwolevelPageExpState extends State<MenuTwolevelPageExp> {
  List records = [];

  double topContainer = 0;

  Future fetchMenus1() async {
    var tblname = Get.arguments[0];

    final url = Uri.parse(
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&view=Grid%20view",
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&cat2=2",
      "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/$tblname?maxRecords=500&view=Grid%20view",
      //"https://api.airtable.com/v0/%2FappgEJ6eE8ijZJtAp/menus?%3D1&maxRecords=500&filterByFormula=({cat1}='2')&fields[]=id",
      //"https://api.airtable.com/v0/%2FappgEJ6eE8ijZJtAp/menus?fields%5B%5D=&filterByFormula=%7Bcat1%7D+%3D+%222%22',
    );
    print(url);
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

  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  // final GlobalKey<ExpansionTileCardState> cardB = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('앱바'),
        ),
        body: FutureBuilder(
            future: fetchMenus1(),
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
                    itemCount: this.records.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ExpansionTileCard(
                        // key: cardA,
                        leading: CircleAvatar(child: Text('A')),
                        title: Text(
                          this.records[index]['fields']['eng'].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                        subtitle: Text('I expand!'),
                        children: <Widget>[
                          Divider(
                            thickness: 1.0,
                            height: 1.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: Text(
                                """Hi there, I'm a drop-in replacement for Flutter's ExpansionTile.
              
              Use me any time you think your app could benefit from being just a bit more Material.
              
              These buttons control the next card down!""",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              }
            }));
  }
}
