import 'package:flutter/material.dart';
import '../../data/requiredMethods.dart';

class WomenCategory extends StatefulWidget {
  const WomenCategory({Key? key}) : super(key: key);

  @override
  _WomenCategoryState createState() => _WomenCategoryState();
}

class _WomenCategoryState extends State<WomenCategory> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMaskOperation(wantedImage: "asdf"),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: RequiredMethodsForCategories.appBarMethod(context,"Women's Category"),
          body: RequiredMethodsForCategories(incomingCategory: "women's clothing"),
        ),
      ],
    );
  }
}