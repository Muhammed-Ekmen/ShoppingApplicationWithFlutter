import 'package:flutter/material.dart';

import '../../data/requiredMethods.dart';

class FavotirePage extends StatefulWidget {
  const FavotirePage({Key? key}) : super(key: key);

  @override
  _FavotirePageState createState() => _FavotirePageState();
}

class _FavotirePageState extends State<FavotirePage> {
  @override
  Widget build(BuildContext context) {
    return RequiredMethodForFavoritePage();
  }
}