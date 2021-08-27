import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flip_card/flip_card.dart';

class ListPhrasesFlip extends StatelessWidget {
  List records = [];

  Future _fetchMenus() async {
    var tblName = Get.arguments[0];
    var viewName = Get.arguments[1];
    var appbarName = Get.arguments[2];

    bool loadRemoteDatatSucceed = false;

    final url = Uri.parse(
      "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/$tblName?maxRecords=500&view=$viewName",
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
        title: Text(Get.arguments[2]),
      ),
      primary: true,
      body: FutureBuilder(
          future: _fetchMenus(),
          builder: (context, snapshot) {
            print('snapshot No.=>');

            if (!snapshot.hasData)
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.amber),
              ));
            else {
              return PageView.builder(
                controller: PageController(viewportFraction: 0.8),
                itemCount: this.records.length,
                itemBuilder: (BuildContext context, int index) {
                  return CardWidget(
                      this.records[index]['fields']['eng'],
                      this.records[index]['fields']['kor'],
                      this.records[index]['fields']['jap'],
                      'assets/images/012.png');
                },
              );
            }
          }),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String _localImage;
  final String texteng;
  final String textkor;
  final String textjap;

  CardWidget(this.texteng, this.textkor, this.textjap, this._localImage);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _listCard(),
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => DetailScreen(Eng, _localImage) )
      //   );
      // },
    );
  }

  Widget _listCard() {
    return Card(
      elevation: 0,
      // clipBehavior: Clip.antiAlias,
      clipBehavior: Clip.hardEdge,
      child: FlipCard(
        front: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _displayImageFront(),
            Column(
              children: <Widget>[
                Container(margin: EdgeInsets.only(top: 10)),
                _createHeader(),
                Expanded(child: Container()),
                _phraseDisplayFront()
              ],
            )
          ],
        ),
        back: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _displayImageBack(),
            Column(
              children: <Widget>[
                Container(margin: EdgeInsets.only(top: 10)),
                _createHeader(),
                Expanded(child: Container()),
                _phraseDisplayBack()
              ],
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      // shape: RoundedRectangleBorder(
      // borderRadius: BorderRadius.circular(50))
    );
  }

  Widget _createHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Column(
            children: <Widget>[
              Text('16',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Text('Oct', style: TextStyle(color: Colors.white)),
              Text('2021', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        Container(
          child: Icon(Icons.favorite, color: Colors.white, size: 50),
          margin: EdgeInsets.only(right: 10),
        )
      ],
    );
  }

  Widget _displayImageFront() {
    return Hero(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_localImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
      ),
      tag: texteng,
    );
  }

  Widget _displayImageBack() {
    return Hero(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_localImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.4), BlendMode.dstATop),
          ),
        ),
      ),
      tag: texteng,
    );
  }

  Widget _phraseDisplayFront() {
    return Container(
      color: Colors.amber,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(bottom: 30, left: 20),
      child: Column(
        children: [
          Text(
            texteng,
            style: TextStyle(color: Colors.black87, fontSize: 24),
          ),
          // Text(
          //   textkor,
          //   style: TextStyle(color: Colors.black87, fontSize: 24),
          // ),
          // Text(
          //   textjap,
          //   style: TextStyle(color: Colors.black87, fontSize: 24),
          // ),
          // Text(
          //   texteng,
          //   style: TextStyle(color: Colors.black87, fontSize: 24),
          // ),
          // Text(
          //   textkor,
          //   style: TextStyle(color: Colors.black87, fontSize: 24),
          // ),
          // Text(
          //   textjap,
          //   style: TextStyle(color: Colors.black87, fontSize: 24),
          // ),
        ],
      ),
    );
  }

  Widget _phraseDisplayBack() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(bottom: 30, left: 20),
      child: Column(
        children: [
          // Text(
          //   texteng,
          //   style: TextStyle(color: Colors.black87, fontSize: 24),
          // ),
          Text(
            textkor,
            style: TextStyle(color: Colors.black87, fontSize: 24),
          ),
          Text(
            textjap,
            style: TextStyle(color: Colors.black87, fontSize: 24),
          ),
        ],
      ),
    );
  }
}
