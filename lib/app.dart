import 'package:flutter/material.dart';

import '/app/view/start_view.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartView(
        key: UniqueKey(),
      ),
    );
  }
}
