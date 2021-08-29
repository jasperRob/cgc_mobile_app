import 'package:flutter/material.dart';

import 'intro_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        home: IntroPage()
    );
  }
}
