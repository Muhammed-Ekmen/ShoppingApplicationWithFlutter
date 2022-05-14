import 'package:flutter/material.dart';
import '../../data/requiredMethods.dart';

class MenCategory extends StatefulWidget {
  const MenCategory({Key? key}) : super(key: key);

  @override
  _MenCategoryState createState() => _MenCategoryState();
}

class _MenCategoryState extends State<MenCategory> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMaskOperation(wantedImage: "asdf"),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: RequiredMethodsForCategories.appBarMethod(context,"Men's Clothing"),
          body: RequiredMethodsForCategories(incomingCategory: "men's clothing"),
        ),
      ],
    );
  }
}