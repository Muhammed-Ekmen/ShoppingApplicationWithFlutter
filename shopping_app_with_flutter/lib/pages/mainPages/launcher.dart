import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/dataWareHouse.dart';
import '../../data/providers.dart';
import '../../data/requiredMethods.dart';
import 'accountPage.dart';
import 'bagPage.dart';
import 'favoritePage.dart';
import 'homepage.dart';

class Launcher extends StatefulWidget {
  const Launcher({Key? key}) : super(key: key);

  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  var pageList = [
    HomePage(
      key: DataForHomePage.homePageKey,
    ),
    FavotirePage(
      key: DataForHomePage.favoritePageKey,
    ),
    BagPage(
      key: DataForHomePage.bagPageKey,
    ),
    AccountPage(
      key: DataForHomePage.accountPageKey,
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Stack(
          children: [
            ShaderMaskOperation(wantedImage: "asdf"),
            Scaffold(
              backgroundColor: Colors.transparent,
              bottomNavigationBar: RequiredMethodForLauncherPage(),
              body: SafeArea(
                child: Center(
                  child: pageList[ref.watch(providerOfBottomBar).pageIndex!],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}