import 'package:flutter/material.dart';
import '../../data/requiredMethods.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({Key? key}) : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  @override
  Widget build(BuildContext context) {
    String incomingOperation=ModalRoute.of(context)!.settings.arguments as String;
    return Stack(
      children: [
        ShaderMaskOperation(wantedImage: "asdf"),
        Scaffold(
          appBar: RequiredMethodForUpdatePage.appBarMethod(incomingOperation),
          backgroundColor: Colors.transparent,
          body: RequiredMethodForUpdatePage(incomingOperation: incomingOperation),
        ),
      ],
    );
  }
}