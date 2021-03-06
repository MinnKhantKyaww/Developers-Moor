import 'package:developers_moor/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:developers_moor/database/developers_database.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (_) =>  AppDatabase().developersDao,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Developers Moor',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: HomePage(),
      ),
    );
  }
}
