import 'package:flutter/material.dart';
import 'package:my_city/src/pages/login.dart';
import 'package:my_city/src/socpe%20model/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

class MyApp extends StatelessWidget {
  final MainModel mainModel = MainModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: mainModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "My CIty",
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        //home: MainScreen(model: mainModel),
        home: LogScreen(),
      ),
    );
  }
}
