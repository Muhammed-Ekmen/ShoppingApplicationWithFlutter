import 'package:flutter/material.dart';
import '../../data/requiredMethods.dart';

class JewelleryCategory extends StatefulWidget {
  const JewelleryCategory({Key? key}) : super(key: key);

  @override
  _JewelleryCategoryState createState() => _JewelleryCategoryState();
}

class _JewelleryCategoryState extends State<JewelleryCategory> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
          ShaderMaskOperation(wantedImage: "asdf"),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: RequiredMethodsForCategories.appBarMethod(context,"Jewellery"),
            body: RequiredMethodsForCategories(incomingCategory: "jewelery"),
          ),

      ],
    );
  }
}