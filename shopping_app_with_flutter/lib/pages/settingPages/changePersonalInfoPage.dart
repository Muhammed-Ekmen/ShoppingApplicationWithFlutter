import 'package:flutter/material.dart';
import '../../data/requiredMethods.dart';

class ChangePersonalPage extends StatefulWidget {
  const ChangePersonalPage({Key? key}) : super(key: key);

  @override
  _ChangePersonalPageState createState() => _ChangePersonalPageState();
}

class _ChangePersonalPageState extends State<ChangePersonalPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMaskOperation(wantedImage: "asdf"),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: RequiredMethodForChangeInfoPage(),
        ),
      ],
    );
  }
}