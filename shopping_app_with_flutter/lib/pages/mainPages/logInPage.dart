import 'package:flutter/material.dart';
import '../../data/dataWareHouse.dart';
import '../../data/requiredMethods.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMaskOperation(wantedImage: "asdf"),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Form(
              key: DataForLogInPage.formKeyForLogInPage,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Welcome To App",
                        style: ConstantValues.fontTypeOfApp(
                            enteredFontSize:
                                MediaQuery.of(context).size.width / 10,
                            enteredFontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 5,
                        endIndent: MediaQuery.of(context).size.width / 10,
                        indent: MediaQuery.of(context).size.width / 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 200, top: 75),
                        child: Text(
                          "Sign In With Your Email And Password Or You Can Sign In With Google Account.",
                          style: ConstantValues.fontTypeOfApp(
                              enteredFontSize:
                                  MediaQuery.of(context).size.width / 30,
                              enteredFontWeight: FontWeight.w100),
                        ),
                      ),
                      for (var k = 0;
                          k< DataForLogInPage.listOfLogInPageFields.length;
                          k++)
                        BuildTextFormField(
                          about: DataForLogInPage.listOfLogInPageFields[k],
                          incomingController: DataForLogInPage.listOfContoller[k],
                          incomingKey: DataForSignInPage.keysOfSignInFieldss[k],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text(
                              "Forget Password?",
                              style: ConstantValues.fontTypeOfApp(
                                  enteredFontSize: 14,
                                  enteredFontWeight: FontWeight.bold,
                                  enteredColor: Colors.black),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: RequiredMethodForLogInPage
                                  .buildElevatedButton(
                                context,
                                "LogIn",
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 18,
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 5,
                        endIndent: MediaQuery.of(context).size.width / 10,
                        indent: MediaQuery.of(context).size.width / 10,
                      ),
                      Row(
                        children: [
                          TextButton(
                            child: Text(
                              "Don't you have an account?",
                              style: ConstantValues.fontTypeOfApp(
                                enteredFontSize:
                                    MediaQuery.of(context).size.width / 22,
                                enteredFontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/SignInPage", (route) => false);
                            },
                          ),
                          TextButton(
                            child: Text(
                              "Create Now!",
                              style: ConstantValues.fontTypeOfApp(
                                enteredFontSize:
                                    MediaQuery.of(context).size.width / 22,
                                enteredFontWeight: FontWeight.w900,
                                enteredColor: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/SignInPage", (route) => false);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}