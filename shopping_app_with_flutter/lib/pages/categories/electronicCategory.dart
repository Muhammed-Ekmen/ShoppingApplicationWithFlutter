import 'package:flutter/material.dart';
import '../../data/requiredMethods.dart';

class ElectronicCategory extends StatefulWidget {
  const ElectronicCategory({Key? key}) : super(key: key);

  @override
  _ElectronicCategoryState createState() => _ElectronicCategoryState();
}

class _ElectronicCategoryState extends State<ElectronicCategory> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMaskOperation(wantedImage: "asdf"),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: RequiredMethodsForCategories.appBarMethod(context,"Electronic Category"),
          body: RequiredMethodsForCategories(incomingCategory: "electronics"),
        ),
      ],
    );
  }
}