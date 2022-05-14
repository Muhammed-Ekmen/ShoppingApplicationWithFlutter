import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../data/requiredMethods.dart';


class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  IntroductionPageState createState() => IntroductionPageState();
}

class IntroductionPageState extends State<IntroductionPage>
    with TickerProviderStateMixin {
  late AnimationController firstConroller;
  @override
  void initState() {
    firstConroller =
        new AnimationController(vsync: this, duration: Duration(seconds: 2));
    firstConroller.forward();
    firstConroller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        firstConroller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        firstConroller.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    firstConroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
        showDoneButton: true,
        showSkipButton: true,
        showNextButton: true,
        next:const Text("Next"),
        skip:const Text("Skip"),
        done:const Text("Done"),
        onSkip: () {
          RequiredMethodForIntroPage.introductionPageNextMethod(context);
        },
        onDone: () {
          RequiredMethodForIntroPage.introductionPageNextMethod(context);
        },
        pages: RequiredMethodForIntroPage.introductionPageListOfPages(
            context, firstConroller));
  }
}