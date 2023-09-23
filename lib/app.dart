import 'package:flutter/material.dart';

import '/app/view/check_app_update_view.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CheckAppUpdateView(
        key: UniqueKey(),
      ),
    );
  }
}
