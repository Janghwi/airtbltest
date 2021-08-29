import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:easy_rich_text/easy_rich_text.dart';

class ListPhrases extends StatelessWidget {
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
                controller: PageController(viewportFraction: 0.85),
                itemCount: this.records.length,
                itemBuilder: (BuildContext context, int index) {
                  return CardWidget(
                      'assets/images/012.png',
                      this.records[index]['fields']['eng'],
                      this.records[index]['fields']['engc'],
                      this.records[index]['fields']['kor'],
                      this.records[index]['fields']['korc'],
                      this.records[index]['fields']['jap'],
                      this.records[index]['fields']['japc']);
                },
              );
            }
          }),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String _localImage;
  final String? texteng;
  final String? textengc;
  final String? textkor;
  final String? textkorc;
  final String? textjap;
  final String? textjapc;

  CardWidget(this._localImage, this.texteng, this.textengc, this.textkor,
      this.textkorc, this.textjap, this.textjapc);

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
    return Center(
      child: SizedBox(
        width: 350,
        height: 500,
        child: Container(
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Color.fromARGB(30, 0, 0, 0),
                    offset: Offset(0.0, 10.0),
                    spreadRadius: 0,
                    blurRadius: 10)
              ]),
          child: Card(
            elevation: 0,
            // clipBehavior: Clip.antiAlias,
            clipBehavior: Clip.hardEdge,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _displayImage(),
                Column(
                  children: <Widget>[
                    Container(margin: EdgeInsets.only(top: 10)),
                    _createHeader(),
                    Expanded(child: Container()),
                    _phraseDisplay()
                  ],
                )
              ],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            // shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.circular(50))
          ),
        ),
      ),
    );
  }

  Widget _createHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Row(
            children: <Widget>[
              Text('16',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              Text('Oct', style: TextStyle(color: Colors.white)),
              Text('2019', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        Container(
          child: Icon(Icons.favorite, color: Colors.white, size: 30),
          margin: EdgeInsets.only(right: 10),
        )
      ],
    );
  }

  Widget _displayImage() {
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
      tag: texteng!,
    );
  }

  Widget _phraseDisplay() {
    return Column(
      children: [
        EasyRichText(texteng!,
            defaultStyle: TextStyle(fontSize: 20, color: Colors.grey),
            patternList: [
              EasyRichTextPattern(
                targetString: textengc ?? '',
                style: TextStyle(color: Colors.blue),
              ),
            ]),
        Divider(
          height: 20,
        ),
        EasyRichText(textkor!,
            defaultStyle: TextStyle(fontSize: 20, color: Colors.grey),
            patternList: [
              EasyRichTextPattern(
                targetString: textkorc ?? '',
                style: TextStyle(color: Colors.blue),
              ),
            ]),
        Divider(
          height: 20,
        ),
        EasyRichText(textjap!,
            defaultStyle: TextStyle(fontSize: 20, color: Colors.grey),
            patternList: [
              EasyRichTextPattern(
                targetString: textjapc ?? '',
                style: TextStyle(color: Colors.blue),
              ),
            ]),
      ],
    );
  }
}
