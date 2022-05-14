import 'package:flutter/material.dart';

import '../../data/requiredMethods.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with TickerProviderStateMixin {
  late AnimationController backAnimationController;
  @override
  void initState() {
    backAnimationController =
         AnimationController(vsync: this, duration: const Duration(seconds: 2));
    backAnimationController.forward();
    backAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        backAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        backAnimationController.forward();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    backAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMaskOperation(wantedImage: "asdf"),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: RequiredMethodForSignInPage(waitingController: backAnimationController),
          ),
        )
      ],
    );
  }
}