import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:staggered_gridview_example/widget/basic_grid_widget.dart';
// import 'package:staggered_gridview_example/widget/custom_scroll_view_grid_widget.dart';
// import 'package:staggered_gridview_example/widget/dynamic_size_grid_widget.dart';
// import 'package:staggered_gridview_example/widget/tabbar_widget.dart';

import 'page/1menulevel_golf.dart';
import 'page/1menuonelevel_page.dart';
import 'page/1menuonelevel_page_p.dart';
import 'widget/tabbar_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'ENKORNESE';

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData.light(),
        home: MainPage(title: title),
      );
}

class MainPage extends StatelessWidget {
  final String title;

  const MainPage({
    required this.title,
  });

  Widget build(BuildContext context) => TabBarWidget(
        title: title,
        tabs: [
          Tab(
            text: ' 문장 ',
            // icon: Icon(Icons.feed_outlined),
          ),
          Tab(
            text: ' 단어 ',
            // icon: Icon(Icons.dynamic_feed),
          ),
          Tab(
            text: ' 골프 ',
            // icon: Icon(Icons.dynamic_form_sharp),
          ),
          Tab(
            text: ' 즐겨찾기 ',
            // icon: Icon(Icons.favorite_border),
          ),
        ],
        children: [
          MenuOnelevelPage(),
          MenuOnelevelPage(),
          OnelevelGolf(),
          MenuOnelevelPage(),
        ],
      );
}
