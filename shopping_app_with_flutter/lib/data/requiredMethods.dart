import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:url_launcher/link.dart';
import 'package:timer_snackbar/timer_snackbar.dart';
import '../models/modelOfCategory.dart';
import 'dataWareHouse.dart';
import 'providers.dart';

class RequiredMethodForCartPage extends ConsumerWidget {
  static scaffoldMessengerMethod(BuildContext context, String operation) {
    return timerSnackbar(
      context: context,
      contentText: "Product Has ${operation}",
      afterTimeExecute: () {},
      second: 2,
      backgroundColor: Colors.transparent,
      buttonLabel: "",
      contentTextStyle: TextStyle(color: Colors.black),
    );
  }

  static Future<void> deleteMethodFromProductList(
      BuildContext context,
      int? id,
      Map<String, dynamic> itemsFromStream,
      DocumentReference<Map<String, dynamic>> documentId) async {
    try {
      List currentList = itemsFromStream["listOfProductId"];
      if (currentList.contains(id)) {
        currentList.remove(id);
        scaffoldMessengerMethod(context, "Removed");
      } else {
        currentList.add(id);
        scaffoldMessengerMethod(context, "Added");
      }
      Map<String, dynamic> toBeSent = {
        "listOfProductId": currentList,
      };
      await documentId.update(toBeSent);
    } catch (e) {
      return Future.error(e);
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var documentId = FirebaseFirestore.instance
        .collection("Users")
        .doc(DataForLogInPage.emailController.text);
    return StreamBuilder<DocumentSnapshot>(
      stream: documentId.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else {
          ///firebase datas
          var itemsFromStream = snapshot.data!.data() as Map<String, dynamic>;
          List exaList = itemsFromStream["listOfProductId"];
          return FutureBuilder(
            future: RequiredMethodsForCategories.getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              } else {
                /// api datas
                List<ModelOfCategory> itemsFromFuture =
                    snapshot.data as List<ModelOfCategory>;
                List<ModelOfCategory> toBeList = [];
                for (var k in itemsFromFuture) {
                  if (exaList.contains(k.id)) {
                    toBeList.add(k);
                  }
                }
                return toBeList.isNotEmpty == true
                    ? ListView.builder(
                        itemCount: toBeList == null ? 0 : toBeList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width / 3.9,
                            height: MediaQuery.of(context).size.width / 1.95,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: ConstantValues.borderRadiusMethod(context),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(10, 10),
                                    blurRadius: 12)
                              ],
                              border: Border.all(
                                width: 2,
                                color: Colors.grey,
                              ),
                              image: DecorationImage(
                                  image: AssetImage(
                                      "lib/data/images/finalBackground.jpg"),
                                  fit: BoxFit.cover),
                            ),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                5.62,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black,
                                                  offset: Offset(20, 20),
                                                  blurRadius: 12,
                                                ),
                                              ],
                                            ),
                                            child: Image.network(
                                              toBeList[index].image!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(toBeList[index].title!),
                                            Divider(
                                              color: Colors.black,
                                            ),
                                            Text(toBeList[index].description!),
                                            Row(
                                              children: [
                                                Text(
                                                  "Price:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(toBeList[index]
                                                    .price
                                                    .toString()),
                                                Icon(
                                                  Icons.attach_money,
                                                  color: Colors.green,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton.icon(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(ConstantValues.colorOfFields)),
                                      icon: Icon(
                                        Icons.money,
                                        color: Colors.green,
                                      ),
                                      label: Text("Buy"),
                                      onPressed: () {},
                                    ),
                                    ElevatedButton.icon(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(ConstantValues.colorOfFields)),
                                      icon: Icon(
                                        Icons.delete_outline_sharp,
                                        color: Colors.red,
                                      ),
                                      label: Text("Remove"),
                                      onPressed: () {
                                        deleteMethodFromProductList(
                                            context,
                                            toBeList[index].id,
                                            itemsFromStream,
                                            documentId);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hourglass_empty,
                              size: MediaQuery.of(context).size.width / 2,
                            ),
                            Text("There Is Nothing In The Shopping Cart"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Link(
                                  uri: Uri.parse("https://www.zara.com/tr/"),
                                  target: LinkTarget.self,
                                  builder: (context, followLink) {
                                    return TextButton(
                                      child: Text(
                                        "Click Here,",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: followLink,
                                    );
                                  },
                                ),
                                Text("For The Learn More!"),
                              ],
                            ),
                          ],
                        ),
                      );
              }
            },
          );
        }
      },
    );
  }
}

///favorite Screen methods
class RequiredMethodForFavoritePage extends ConsumerWidget {
  static scaffoldMessengerMethod(BuildContext context, String operation) {
    return timerSnackbar(
      context: context,
      contentText: "Product Has ${operation}",
      afterTimeExecute: () {},
      second: 2,
      backgroundColor: Colors.transparent,
      buttonLabel: "",
      contentTextStyle: TextStyle(color: Colors.black),
    );
  }

  static Future<void> deleteMethodFromFavorites(
      BuildContext context,
      int? id,
      Map<String, dynamic> itemsFromStream,
      DocumentReference<Map<String, dynamic>> documentId) async {
    try {
      List currentList = itemsFromStream["listOfFavoritesId"];
      if (currentList.contains(id)) {
        currentList.remove(id);
        scaffoldMessengerMethod(context, "Removed");
      } else {
        currentList.add(id);
        scaffoldMessengerMethod(context, "Added");
      }
      Map<String, dynamic> toBeSent = {
        "listOfFavoritesId": currentList,
      };
      await documentId.update(toBeSent);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var documentId = FirebaseFirestore.instance
        .collection("Users")
        .doc(DataForLogInPage.emailController.text);
    return StreamBuilder<DocumentSnapshot>(
      stream: documentId.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else {
          ///firebase datas
          var itemsFromStream = snapshot.data!.data() as Map<String, dynamic>;
          List exaList = itemsFromStream["listOfFavoritesId"];
          return FutureBuilder(
            future: RequiredMethodsForCategories.getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              } else {
                /// api datas
                List<ModelOfCategory> itemsFromFuture =
                    snapshot.data as List<ModelOfCategory>;
                List<ModelOfCategory> toBeList = [];
                for (var k in itemsFromFuture) {
                  if (exaList.contains(k.id)) {
                    toBeList.add(k);
                  }
                }
                return toBeList.isNotEmpty == true
                    ? GridView.custom(
                        gridDelegate: SliverQuiltedGridDelegate(
                          crossAxisCount: 4,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          repeatPattern: QuiltedGridRepeatPattern.inverted,
                          pattern: [
                            QuiltedGridTile(2, 2),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 2),
                          ],
                        ),
                        childrenDelegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          if (index < exaList.length) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    ConstantValues.borderRadiusMethod(context),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(10, 10),
                                      blurRadius: 12)
                                ],
                                border: Border.all(
                                  width: 2,
                                  color: Colors.grey,
                                ),
                                image: DecorationImage(
                                    image: AssetImage(
                                        "lib/data/images/finalBackground.jpg"),
                                    fit: BoxFit.cover),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 10,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white,
                                                    offset: Offset(0, 20),
                                                    blurRadius: 12,
                                                  ),
                                                ],
                                              ),
                                              child: Image.network(
                                                toBeList[index].image!,
                                                fit: BoxFit.fitHeight,
                                              )),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: () {
                                                    deleteMethodFromFavorites(
                                                        context,
                                                        toBeList[index].id,
                                                        itemsFromStream,
                                                        documentId);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Material(
                                    color: Colors.black.withOpacity(0.7),
                                    child: Row(
                                      children: [
                                        Text(
                                          toBeList[index].price.toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.attach_money,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Text(toBeList[index].price.toString()),
                                ],
                              ),
                            );
                          } else {
                            return null;
                          }
                        }),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.heart_broken_rounded,
                              color: Colors.red,
                              size: MediaQuery.of(context).size.width / 2,
                            ),
                            Text(
                              "There Is Nothing Favorites.",
                            )
                          ],
                        ),
                      );
              }
            },
          );
        }
      },
    );
  }
}

/// update page methods
class RequiredMethodForUpdatePage extends ConsumerWidget {
  String? incomingOperation;
  RequiredMethodForUpdatePage({required this.incomingOperation}) : super();
  static AppBar appBarMethod(String title) {
    return AppBar(
      title: Text("Renew The " + title),
      automaticallyImplyLeading: false,
      foregroundColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          "lib/data/images/finalBackground.jpg",
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  static buildTextFormField(
      BuildContext context, String about, String operation) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width / 39),
      child: TextFormField(
        controller: detectController(about),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (incoming) {
          var validate = operation == "Email"
              ? DataForLogInPage.emailController.text
              : DataForLogInPage.passwordController.text;
          if (about == DataForAccountPage.listOfUpdatePage[0]) {
            if (incoming != validate) {
              return "The ${operation}s Don't Match Each Other";
            } else {
              return null;
            }
          } else if (about == DataForAccountPage.listOfUpdatePage[1]) {
            if (incoming!.isEmpty == true) {
              return "${operation} Can Not Be Empty";
            } else {
              return null;
            }
          } else {
            if (incoming != DataForAccountPage.updateController.text) {
              return "Please Make Sure The Both Password Match";
            } else {
              return null;
            }
          }
        },
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          hintText: about + operation,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
            borderRadius: ConstantValues.borderRadiusMethod(context),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
            borderRadius: ConstantValues.borderRadiusMethod(context),
          ),
          filled: true,
          fillColor: ConstantValues.colorOfFields,
          hintStyle: ConstantValues.fontTypeOfApp(
              enteredFontSize: MediaQuery.of(context).size.width / 27,
              enteredFontWeight: FontWeight.bold,
              enteredColor: Colors.white),
        ),
      ),
    );
  }

  static detectController(String about) {
    if (about == DataForAccountPage.listOfUpdatePage[0]) {
      return DataForAccountPage.currentController;
    } else if (about == DataForAccountPage.listOfUpdatePage[1]) {
      return DataForAccountPage.updateController;
    } else {
      return DataForAccountPage.checkController;
    }
  }

  static Future<void> updatePasswordMethod(BuildContext context,
      DocumentReference<Map<String, dynamic>> documentId) async {
    try {
      await FirebaseAuth.instance.currentUser!
          .updatePassword(DataForAccountPage.updateController.text);
      await FirebaseAuth.instance.signOut().then((value) {
        var message = CupertinoAlertDialog(
          title: Text("Password Has Changed Succesfully."),
          content: Text(
              "You're Directing The LogInPage. Now You Can Use New Password."),
          actions: [
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width / 39),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                  onPressed: () {
                    DataForAccountPage.checkController.clear();
                    DataForAccountPage.updateController.clear();
                    DataForAccountPage.currentController.clear();
                    RequiredMethodForSignInPage.clearAllController();
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/LogInPage", (route) => false);
                  },
                  child: Text("I Got It")),
            ),
          ],
        );
        showCupertinoDialog(
            context: context, builder: (BuildContext context) => message);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        var credentinal = EmailAuthProvider.credential(
            email: DataForLogInPage.emailController.text,
            password: DataForLogInPage.passwordController.text);
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithCredential(credentinal);
        await FirebaseAuth.instance.currentUser!
            .updatePassword(DataForAccountPage.updateController.text);
        await FirebaseAuth.instance.signOut().then((value) {
          var message = CupertinoAlertDialog(
            title: Text("Password Has Changed Succesfully."),
            content: Text(
                "You're Directing The LogInPage. Now You Can Use New Password."),
            actions: [
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width / 39),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () {
                      DataForAccountPage.checkController.clear();
                      DataForAccountPage.updateController.clear();
                      DataForAccountPage.currentController.clear();
                      RequiredMethodForSignInPage.clearAllController();
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/LogInPage", (route) => false);
                    },
                    child: Text("I Got It")),
              ),
            ],
          );
          showCupertinoDialog(
              context: context, builder: (BuildContext context) => message);
        });
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> updateEmailMethod(BuildContext context,
        DocumentReference<Map<String, dynamic>> documentId) async {
      try {
        await FirebaseAuth.instance.currentUser!
            .updateEmail(DataForAccountPage.updateController.text);
        await FirebaseAuth.instance.signOut().then((value) async {
          await documentId.delete();
          Map<String, dynamic> userInfos = {
            "GenderIndex": ref.watch(genderProvider).userGender!.index,
            "DateOfBirth": ref.watch(cupertinoIndexProvider).cupertinoIndex!,
            "listOfFavoritesId": [],
            "listOfProductId": [],
          };
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(DataForAccountPage.updateController.text)
              .set(userInfos);
          var message = CupertinoAlertDialog(
            title: Text("Email Has Changed Succesfully."),
            content: Text(
                "You're Directing The LogInPage. Now You Can Use New Email."),
            actions: [
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width / 39),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () {
                      RequiredMethodForSignInPage.clearAllController();

                      Navigator.pushNamedAndRemoveUntil(
                          context, "/LogInPage", (route) => false);
                    },
                    child: Text("I Got It")),
              ),
            ],
          );
          showCupertinoDialog(
              context: context, builder: (BuildContext context) => message);
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "requires-recent-login") {
          var credentinal = EmailAuthProvider.credential(
              email: DataForLogInPage.emailController.text,
              password: DataForLogInPage.passwordController.text);
          await FirebaseAuth.instance.currentUser!
              .reauthenticateWithCredential(credentinal);
          await FirebaseAuth.instance.currentUser!
              .updateEmail(DataForAccountPage.updateController.text);
          await FirebaseAuth.instance.signOut().then((value) async {
            await documentId.delete();
            Map<String, dynamic> userInfos = {
              "GenderIndex": ref.watch(genderProvider).userGender!.index,
              "DateOfBirth": ref.watch(cupertinoIndexProvider).cupertinoIndex!,
              "listOfFavoritesId": [],
              "listOfProductId": [],
            };
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(DataForAccountPage.updateController.text)
                .set(userInfos);
            var message = CupertinoAlertDialog(
              title: Text("Email Has Changed Succesfully."),
              content: Text(
                  "You're Directing The LogInPage. Now You Can Use New Email."),
              actions: [
                Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 39),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: () {
                        RequiredMethodForSignInPage.clearAllController();
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/LogInPage", (route) => false);
                      },
                      child: Text("I Got It")),
                ),
              ],
            );
            showCupertinoDialog(
                context: context, builder: (BuildContext context) => message);
          });
        }
      } catch (e) {
        return Future.error(e);
      }
    }

    var documentId = FirebaseFirestore.instance
        .collection("Users")
        .doc(DataForLogInPage.emailController.text);
    return Form(
      key: DataForAccountPage.formKey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var k in DataForAccountPage.listOfUpdatePage)
              buildTextFormField(context, k, this.incomingOperation!),
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, 1),
                  blurRadius: 12,
                ),
              ]),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                ),
                icon: Icon(Icons.update),
                label: Text("Update ${incomingOperation}"),
                onPressed: () {
                  if (DataForAccountPage.formKey.currentState!.validate() ==
                      true) {
                    incomingOperation == "Email"
                        ? updateEmailMethod(context, documentId)
                        : updatePasswordMethod(context, documentId);
                  }
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, 1),
                  blurRadius: 12,
                ),
              ]),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                ),
                icon: Icon(Icons.update),
                label: Text("Back"),
                onPressed: () {
                  DataForAccountPage.checkController.clear();
                  DataForAccountPage.updateController.clear();
                  DataForAccountPage.currentController.clear();
                  Navigator.maybePop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Page Which change personel informations
class RequiredMethodForChangeInfoPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    buildRadioTileMethod(Gender incomingGender) {
      return Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 19.5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: ConstantValues.borderRadiusMethod(context),
            boxShadow: [
              BoxShadow(
                  color: Colors.white, offset: Offset(10, 10), blurRadius: 12),
            ],
          ),
          child: RadioListTile(
            activeColor: Colors.white,
            value: incomingGender,
            groupValue: ref.watch(providerOfUpdateGender).incomingGender,
            title: Text(
              describeEnum(incomingGender),
              textAlign: TextAlign.left,
              style: ConstantValues.fontTypeOfApp(
                  enteredFontSize: MediaQuery.of(context).size.width / 27,
                  enteredFontWeight: FontWeight.bold),
            ),
            onChanged: (incoming) {
              ref
                  .watch(providerOfUpdateGender.notifier)
                  .updateGender(incomingGender);
            },
          ),
        ),
      );
    }

    cupertinoPickerMethod() {
      return Container(
        height: MediaQuery.of(context).size.height / 2.41,
        child: CupertinoPicker(
          scrollController: DataForAccountPage.cupertinoUpdatePickerController,
          backgroundColor: Colors.transparent,
          looping: true,
          children: [
            for (var k in DataForSignInPage.listOfBirthday) Text(k.toString()),
          ],
          itemExtent: 64,
          onSelectedItemChanged: (incomign) {
            ref.watch(providerOfUpdateCupertino.notifier).newIndex(incomign);
          },
        ),
      );
    }

    var documentId = FirebaseFirestore.instance
        .collection("Users")
        .doc(DataForLogInPage.emailController.text);
    return StreamBuilder<DocumentSnapshot>(
      stream: documentId.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else {
          Map<String, dynamic> items =
              snapshot.data!.data() as Map<String, dynamic>;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlipCard(
                  back: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: MediaQuery.of(context).size.width / 2.6,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage("lib/data/images/finalBackground.jpg"),
                          fit: BoxFit.cover),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(10, 20),
                          blurRadius: 24,
                        ),
                      ],
                      borderRadius: ConstantValues.borderRadiusMethod(context),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Switch The Card"),
                          Row(
                            children: [
                              Text(
                                "Date Of Birth:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(items["DateOfBirth"].toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  front: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: MediaQuery.of(context).size.width / 2.6,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage("lib/data/images/finalBackground.jpg"),
                          fit: BoxFit.cover),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(10, 20),
                          blurRadius: 24,
                        ),
                      ],
                      borderRadius: ConstantValues.borderRadiusMethod(context),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Switch The Card"),
                          Row(
                            children: [
                              Text(
                                "User Gender:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(describeEnum(
                                  Gender.values[items["GenderIndex"]])),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  controller: DataForAccountPage.secondFlipController,
                ),
                Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 39),
                  child: Text(
                    "Please Enter New Values What You Want Change.",
                    style: ConstantValues.fontTypeOfApp(
                        enteredFontSize:
                            MediaQuery.of(context).size.width / 16.25,
                        enteredFontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 2,
                  endIndent: MediaQuery.of(context).size.width / 40.75,
                  indent: MediaQuery.of(context).size.width / 40.75,
                ),
                for (var k in Gender.values) buildRadioTileMethod(k),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 39),
                        child: CupertinoButton(
                          color: Colors.grey,
                          borderRadius: ConstantValues.borderRadiusMethod(context),
                          child: Text(
                            "Select Date Of Birth",
                            style: ConstantValues.fontTypeOfApp(
                                enteredFontSize:
                                    MediaQuery.of(context).size.width / 27,
                                enteredFontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            showCupertinoModalPopup(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoActionSheet(
                                      actions: [cupertinoPickerMethod()],
                                      cancelButton: CupertinoActionSheetAction(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.maybePop(context);
                                        },
                                      ),
                                    ));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black,
                  thickness: 2,
                  endIndent: MediaQuery.of(context).size.width / 40.75,
                  indent: MediaQuery.of(context).size.width / 40.75,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0, 5),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        margin: EdgeInsets.all(10),
                        child: ElevatedButton(
                          child: Text("Save"),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.grey, onPrimary: Colors.white),
                          onPressed: () async {
                            try {
                              Map<String, dynamic> toBeSent = {
                                "DateOfBirth": DataForSignInPage.listOfBirthday[
                                    ref
                                        .watch(providerOfUpdateCupertino)
                                        .cupertinoIndex!],
                                "GenderIndex": ref
                                    .watch(providerOfUpdateGender)
                                    .incomingGender!
                                    .index,
                                "listOfFavoritesId": [],
                                "listOfProductId": [],
                              };
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(DataForLogInPage.emailController.text)
                                  .update(toBeSent)
                                  .then((value) {
                                Navigator.maybePop(context);
                              });
                            } catch (e) {
                              return Future.error(e);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0, 5),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        margin: EdgeInsets.all(10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.grey, onPrimary: Colors.white),
                            onPressed: () {
                              Navigator.maybePop(context);
                            },
                            child: Text("Back")),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

/// AccountSetting Methods
class RequiredMethodForAccountSetting extends ConsumerWidget {
  static buildCard(BuildContext context, String about,
      DocumentReference<Map<String, dynamic>> documentId) {
    return GestureDetector(
      onTap: () {
        detectOperation(context, about, documentId);
      },
      child: Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width / 39),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: ConstantValues.borderRadiusMethod(context),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              offset: Offset(0, 20),
              blurRadius: 24,
            ),
          ],
        ),
        child: ListTile(
          title: Text(about),
          leading: detectIcon(about),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  static detectIcon(String about) {
    switch (about) {
      case "Change Personal Info":
        return Icon(
          Icons.info_outline,
          color: Colors.white,
        );
      case "Update Password":
        return Icon(
          Icons.password,
          color: Colors.white,
        );
      case "Change Email Adress":
        return Icon(
          Icons.repeat,
          color: Colors.white,
        );
      case "DELETE ACCOUNT":
        return Icon(
          Icons.delete,
          color: Colors.white,
        );
      case "Back":
        return null;
    }
  }

  static detectOperation(BuildContext context, String about,
      DocumentReference<Map<String, dynamic>> documentId) {
    switch (about) {
      case "Change Personal Info":
        return Navigator.pushNamed(context, "/ChangeInfo");
      case "Update Password":
        return Navigator.pushNamed(context, "/UpdatePage",
            arguments: "Password");
      case "Change Email Adress":
        return Navigator.pushNamed(context, "/UpdatePage", arguments: "Email");
      case "DELETE ACCOUNT":
        return deleteAccountMethod(context, documentId);
      case "Back":
        return Navigator.maybePop(context);
    }
  }

  static deleteAccountMethod(BuildContext context,DocumentReference<Map<String, dynamic>> documentId) async {
    try {
      var message = CupertinoAlertDialog(
        actions: [
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 39),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              child: Text("Yes,"),
              onPressed: () async {
                try {
                  if (FirebaseAuth.instance.currentUser != null) {
                    await FirebaseAuth.instance.currentUser!
                        .delete()
                        .then((value) async {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/LogInPage", (route) => false);
                      await documentId.delete();
                      RequiredMethodForSignInPage.clearAllController();
                      showMaterialBanner(context);
                      await Duration(seconds: 2);
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    });
                  }
                } catch (e) {
                  return Future.error(e);
                }
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 39,
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 39),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              child: Text("No,"),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
          ),
        ],
        title: Text("Are You Sure You Want To Delete Account?"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 16.88,
              ),
              Text(
                "Warnign!",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              Text(
                  "The Account Will Be Deleted With Your Information. All Processing Will Be Permanent."),
              Link(
                target: LinkTarget.self,
                uri: Uri.parse("https://firebase.google.com/docs/auth/admin"),
                builder: (context, followLink) {
                  return TextButton(
                    child: Text("Learn More"),
                    onPressed: followLink,
                  );
                },
              ),
            ],
          ),
        ),
      );
      showCupertinoDialog(
          context: context, builder: (BuildContext context) => message);
    } catch (e) {
      return Future.error(e);
    }
  }

  static showMaterialBanner(BuildContext context) {
    return ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        actions: [],
        content: Text("Account Has Deleted.."),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var documentId = FirebaseFirestore.instance
        .collection("Users")
        .doc(DataForLogInPage.emailController.text);
    return StreamBuilder<DocumentSnapshot>(
      stream: documentId.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.data.toString()),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CupertinoActivityIndicator();
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width / 19.5),
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 5,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(20, 20),
                              blurRadius: 24),
                        ],
                        color: Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: Colors.black)),
                    child: CircleAvatar(
                      child: Image.network("https://icon-library.com/images/avatar-icon-images/avatar-icon-images-4.jpg",fit: BoxFit.cover,),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      if ((index + 1) % 2 == 0) {
                        return Divider(
                          color: Colors.black,
                          thickness: 1,
                          endIndent: MediaQuery.of(context).size.width / 19.75,
                          indent: MediaQuery.of(context).size.width / 19.75,
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                    itemCount: DataForAccountPage.listOfSettingSection.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildCard(
                          context,
                          DataForAccountPage.listOfSettingSection[index],
                          documentId);
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

/// AccountPage
class RequiredMethodForAccountPage extends ConsumerWidget {
  static buildLinkCard(BuildContext context, String about) {
    return Link(
      uri: about == "Help"
          ? Uri.parse("https://flutter.dev")
          : Uri.parse("https://github.com/Muhammed-Ekmen?tab=repositories"),
      target: LinkTarget.self,
      builder: (context, followLink) {
        return GestureDetector(
          onTap: followLink,
          child: Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width / 39),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: ConstantValues.borderRadiusMethod(context),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, 10),
                  blurRadius: 24,
                ),
              ],
            ),
            child: ListTile(
              title: Text(about),
              leading: detectIcon(about),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  static buildCard(BuildContext context, String about) {
    return GestureDetector(
      onTap: () {
        about == "LogOut"
            ? logOutMethod(context)
            : Navigator.pushNamed(context, "/AccountSetting");
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: ConstantValues.borderRadiusMethod(context),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              offset: Offset(0, 10),
              blurRadius: 24,
            ),
          ],
        ),
        child: ListTile(
          title: Text(about),
          leading: detectIcon(about),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  static detectIcon(String about) {
    switch (about) {
      case "Information":
        return Icon(
          Icons.info,
          color: Colors.white,
        );
      case "Setting":
        return Icon(
          Icons.settings,
          color: Colors.white,
        );
      case "Help":
        return Icon(
          Icons.help,
          color: Colors.white,
        );
      case "LogOut":
        return Icon(
          Icons.logout,
          color: Colors.white,
        );
    }
  }

  static logOutMethod(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        RequiredMethodForSignInPage.clearAllController();
        Navigator.pushNamedAndRemoveUntil(
            context, "/LogInPage", (route) => false);
      });
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var documentId = FirebaseFirestore.instance
        .collection("Users")
        .doc(DataForLogInPage.emailController.text);
    return StreamBuilder<DocumentSnapshot>(
      stream: documentId.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something Went Wrong..."),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Profile",
                  style: ConstantValues.fontTypeOfApp(
                      enteredFontSize: MediaQuery.of(context).size.width / 8,
                      enteredFontWeight: FontWeight.bold),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width / 19.5),
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 5,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(20, 20),
                              blurRadius: 24),
                        ],
                        color: Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: Colors.black)),
                    child: CircleAvatar(
                      child: Image.network("https://icon-library.com/images/avatar-icon-images/avatar-icon-images-4.jpg",fit: BoxFit.cover,),
                    ),
                  ),
                ),
                for (var k in DataForAccountPage.listOfAccountMenu)
                  k == "Information" || k == "Help"
                      ? buildLinkCard(context, k)
                      : buildCard(context, k),
              ],
            ),
          );
        }
      },
    );
  }
}

/// Categories Methods
class RequiredMethodsForCategories extends ConsumerWidget {
  String? incomingCategory;
  RequiredMethodsForCategories({required this.incomingCategory});
  static AppBar appBarMethod(BuildContext context, String title) {
    return AppBar(
      foregroundColor: Colors.black,
      title: Text(title),
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          "lib/data/images/finalBackground.jpg",
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  static Future<List<ModelOfCategory>> getData() async {
    try {
      var response = await Dio().get(ConstantValues.productURL);
      List<ModelOfCategory> exaList = [];
      if (response.statusCode == 200) {
        exaList = (response.data as List)
            .map((e) => ModelOfCategory.fromJson(e))
            .toList();
      }
      return exaList;
    } catch (e) {
      return Future.error(e);
    }
  }

  static scaffoldMessengerMethod(BuildContext context, String operation) {
    return timerSnackbar(
      context: context,
      contentText: "Product Has ${operation}",
      afterTimeExecute: () {},
      second: 2,
      backgroundColor: Colors.transparent,
      buttonLabel: "",
      contentTextStyle: TextStyle(color: Colors.black),
    );
  }

  static Future<void> addFavoriteMethod(
      BuildContext context,
      int? id,
      Map<String, dynamic> itemsFromStream,
      DocumentReference<Map<String, dynamic>> documentId) async {
    try {
      List currentList = itemsFromStream["listOfFavoritesId"];
      if (currentList.contains(id)) {
        currentList.remove(id);
        scaffoldMessengerMethod(context, "Removed");
      } else {
        currentList.add(id);
        scaffoldMessengerMethod(context, "Added");
      }
      Map<String, dynamic> toBeSent = {
        "listOfFavoritesId": currentList,
      };
      await documentId.update(toBeSent);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<void> addChartMethod(
      BuildContext context,
      int? id,
      Map<String, dynamic> itemsFromStream,
      DocumentReference<Map<String, dynamic>> documentId) async {
    try {
      List currentList = itemsFromStream["listOfProductId"];
      if (currentList.contains(id)) {
        currentList.remove(id);
        scaffoldMessengerMethod(context, "Removed");
      } else {
        currentList.add(id);
        scaffoldMessengerMethod(context, "Added");
      }
      Map<String, dynamic> toBeSent = {
        "listOfProductId": currentList,
      };
      await documentId.update(toBeSent);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var documentId = FirebaseFirestore.instance
        .collection("Users")
        .doc(DataForLogInPage.emailController.text);
    return StreamBuilder<DocumentSnapshot>(
      stream: documentId.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else {
          ///document snapshot
          var itemsFromStream = snapshot.data!.data() as Map<String, dynamic>;
          List exaList = itemsFromStream["listOfFavoritesId"];
          List secondExaList = itemsFromStream["listOfProductId"];
          return FutureBuilder(
            future: getData(),
            builder: (context, data) {
              if (data.hasError) {
                return Center(
                    child: Text(
                  data.error.toString(),
                  style: TextStyle(color: Colors.pink),
                ));
              } else if (data.hasData) {
                List<ModelOfCategory> itemsFromFuture = [];
                for (var k in data.data as List<ModelOfCategory>) {
                  if (k.category == this.incomingCategory) {
                    itemsFromFuture.add(k);
                  }
                }
                return GridView.builder(
                  itemCount:
                      itemsFromFuture == null ? 0 : itemsFromFuture.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 39),
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: MediaQuery.of(context).size.height / 1.5,
                        decoration: BoxDecoration(
                          borderRadius: ConstantValues.borderRadiusMethod(context),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black,
                                offset: Offset(10, 10),
                                blurRadius: 12)
                          ],
                          border: Border.all(
                            width: 2,
                            color: Colors.grey,
                          ),
                          image: DecorationImage(
                              image: AssetImage(
                                  "lib/data/images/finalBackground.jpg"),
                              fit: BoxFit.cover),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Expanded(
                                    flex: 7,
                                    child: Image.network(
                                      itemsFromFuture[index].image!,
                                      fit: BoxFit.cover,
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      itemsFromFuture[index].title!,
                                      textAlign: TextAlign.center,
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "ONLY ${itemsFromFuture[index].price}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
                                          Icons.attach_money,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              19.5,
                                          color: Colors.green,
                                        )
                                      ],
                                    )),
                                Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                  indent:
                                      MediaQuery.of(context).size.width / 13,
                                  endIndent:
                                      MediaQuery.of(context).size.width / 13,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: secondExaList.contains(
                                                itemsFromFuture[index].id)
                                            ? Icon(
                                                Icons.done,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons.add_shopping_cart_sharp),
                                        onPressed: () {
                                          addChartMethod(
                                              context,
                                              itemsFromFuture[index].id,
                                              itemsFromStream,
                                              documentId);
                                        },
                                      ),
                                      IconButton(
                                        icon: exaList.contains(
                                                itemsFromFuture[index].id)
                                            ? Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              )
                                            : Icon(Icons.favorite_border),
                                        onPressed: () {
                                          addFavoriteMethod(
                                              context,
                                              itemsFromFuture[index].id,
                                              itemsFromStream,
                                              documentId);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            },
          );
        }
      },
    );
  }
}

///HomePage Methods
class RequiredMethodForHomePage extends ConsumerWidget {
  static buildFlipCard(String firstFace, String secondFace,
      FlipCardController incomingController, BuildContext context) {
    return GestureDetector(
      onTap: () {
        incomingController.toggleCard();
      },
      child: FlipCard(
        speed: 800,
        flipOnTouch: false,
        controller: incomingController,
        back: buildFirstField(firstFace, context),
        front: buildSecondField(context, secondFace),
      ),
    );
  }

  static buildSecondField(BuildContext context, String about) {
    return Stack(
      children: [
        Container(
          margin:
              EdgeInsets.only(right: MediaQuery.of(context).size.width / 19.5),
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: ConstantValues.borderRadiusMethod(context),
            border: Border.all(width: 2, color: Colors.transparent),
            image: detectImage(about),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(5, 5),
                blurRadius: 5,
              ),
            ],
            color: Colors.grey,
          ),
        ),
        Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.height / 30),
          decoration: BoxDecoration(),
          child: ElevatedButton.icon(
            icon: Icon(Icons.arrow_right_alt_rounded),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.pink;
              } else {
                return Colors.black.withOpacity(0.4);
              }
            })),
            onPressed: () {
              goCategoryMethod(about, context);
            },
            label: Text("Show Me ${about}"),
          ),
        ),
      ],
    );
  }

  static goCategoryMethod(String about, BuildContext context) {
    switch (about) {
      case "Men's Clothing":
        Navigator.pushNamed(context, "/Men");
        break;
      case "Women's Clothing":
        Navigator.pushNamed(context, "/Women");
        break;
      case "Electronic & Technology":
        Navigator.pushNamed(context, "/Electronic");
        break;
      case "Jewelley & Make-Up":
        Navigator.pushNamed(context, "/Jewel");
        break;
    }
  }

  static detectImage(String about) {
    if (about == "Men's Clothing") {
      return DecorationImage(
          image: NetworkImage(DataForHomePage.menCategoryImage),
          fit: BoxFit.cover);
    } else if (about == "Women's Clothing") {
      return DecorationImage(
          image: NetworkImage(DataForHomePage.womenCategoryImage),
          fit: BoxFit.cover);
    } else if (about == "Electronic & Technology") {
      return DecorationImage(
          image: NetworkImage(DataForHomePage.electrinicCategoryImage),
          fit: BoxFit.cover);
    } else {
      return DecorationImage(
          image: NetworkImage(DataForHomePage.jewelCategoryImage),
          fit: BoxFit.cover);
    }
  }

  static buildFirstField(String about, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      width: MediaQuery.of(context).size.width / 2,
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.width / 5),
      ),
      decoration: BoxDecoration(
        borderRadius: ConstantValues.borderRadiusMethod(context),
        border: Border.all(width: 2, color: Colors.black),
        image: detectImageSecond(about),
      ),
    );
  }

  static detectImageSecond(String about) {
    if (about == "Men") {
      return DecorationImage(
          image: AssetImage("lib/data/images/men.jpg"), fit: BoxFit.cover);
    } else if (about == "Women") {
      return DecorationImage(
          image: AssetImage("lib/data/images/women.jpg"), fit: BoxFit.cover);
    } else if (about == "Electronic") {
      return DecorationImage(
          image: AssetImage("lib/data/images/electronic.jpg"),
          fit: BoxFit.cover);
    } else {
      return DecorationImage(
          image: AssetImage("lib/data/images/jewellery.jpg"),
          fit: BoxFit.cover);
    }
  }

  static getContainer() async {
    return ListView.builder(
      itemCount: DataForHomePage.listOfSuggestionImage.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(20, 20),
                blurRadius: 12,
              ),
            ],
          ),
        );
      },
    );
  }

  static buildContainer(BuildContext context, String about) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width / 2.6,
          height: MediaQuery.of(context).size.width / 2.6,
          child: Image.network(about),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: ConstantValues.borderRadiusMethod(context),
            border: Border.all(width: 5, color: Colors.black),
            boxShadow: [
              BoxShadow(
                  color: Colors.black, offset: Offset(20, 20), blurRadius: 20),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(50),
          child: Center(
            child: Column(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.search,
                    size: MediaQuery.of(context).size.width / 8,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/Suggestion",
                        arguments: about);
                  },
                ),
                Text(
                  "View",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static detectPriceForSuggestionPage(String incoming) {
    if (incoming == DataForHomePage.listOfSuggestionImage[0]) {
      return r"ONLY 109.95$";
    } else if (incoming == DataForHomePage.listOfSuggestionImage[1]) {
      return r"ONLY 39.90$";
    } else if (incoming == DataForHomePage.listOfSuggestionImage[2]) {
      return r"ONLY 999.99$";
    } else {
      return r"ONLY 7.95$";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 20,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[600]!.withOpacity(0.8),
                        borderRadius:
                            ConstantValues.borderRadiusMethod(context),
                      ),
                      child: TextButton(
                        child: Text(
                          "What's The New?",
                          style: ConstantValues.fontTypeOfApp(
                              enteredFontSize:
                                  MediaQuery.of(context).size.width / 32.5,
                              enteredFontWeight: FontWeight.normal),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.dark_mode),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_downward),
              Text(
                "Coming Soon...",
              ),
              Icon(Icons.arrow_downward),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.flash_on,
                    size: 24,
                  ),
                  Text("Fast Delivery")
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.airplane_ticket,
                    size: 24,
                  ),
                  Text("Fly Ticket")
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.card_giftcard_outlined,
                    size: 24,
                  ),
                  Text("Daily Gift")
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.note_rounded,
                    size: 24,
                  ),
                  Text("Pay Bill")
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.computer,
                    size: 24,
                  ),
                  Text("Games")
                ],
              ),
            ],
          ),
          Divider(
            color: Colors.black,
            thickness: 5,
            endIndent: MediaQuery.of(context).size.width / 10,
            indent: MediaQuery.of(context).size.width / 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Categories",
                style: ConstantValues.fontTypeOfApp(
                    enteredFontSize: MediaQuery.of(context).size.width / 9.75,
                    enteredFontWeight: FontWeight.bold),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                buildFlipCard(
                  "Men",
                  "Men's Clothing",
                  DataForHomePage.firstFlipController,
                  context,
                ),
                buildFlipCard("Women", "Women's Clothing",
                    DataForHomePage.secondFlipController, context),
                buildFlipCard("Electronic", "Electronic & Technology",
                    DataForHomePage.thirdFlipController, context),
                buildFlipCard("Jewel", "Jewelley & Make-Up",
                    DataForHomePage.fourthFlipController, context),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Special For You",
                style: ConstantValues.fontTypeOfApp(
                    enteredFontSize: MediaQuery.of(context).size.width / 9.75,
                    enteredFontWeight: FontWeight.bold),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Hero(
              tag: "suggestion",
              child: Row(
                children: [
                  for (var k in DataForHomePage.listOfSuggestionImage)
                    buildContainer(context, k),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Introduction Page Methods
class RequiredMethodForIntroPage extends ConsumerWidget {
  static introductionPageNextMethod(BuildContext context) {
    Navigator.maybePop(context);
    Navigator.pushNamedAndRemoveUntil(context, "/LogInPage", (route) => false);
  }

  static detectIconForPageViewModelMethod(String incomingTitle) {
    if (incomingTitle == ConstantValues.titleOfPageViewModels[0]) {
      return AnimatedIcons.ellipsis_search;
    } else if (incomingTitle == ConstantValues.titleOfPageViewModels[1]) {
      return AnimatedIcons.home_menu;
    } else {
      return AnimatedIcons.menu_close;
    }
  }

  static PageViewModel buildPageViewModel(
    String titleText,
    String bodyText,
    AnimationController incomingController,
    BuildContext context,
  ) {
    return PageViewModel(
      image: AnimatedIcon(
        icon: detectIconForPageViewModelMethod(titleText),
        progress: incomingController,
        size: MediaQuery.of(context).size.width / 3,
      ),
      decoration: PageDecoration(
        bodyTextStyle: ConstantValues.fontTypeOfApp(
            enteredFontSize: ConstantValues.fontSizeMethod(context),
            enteredFontWeight: FontWeight.w200),
        titleTextStyle: ConstantValues.fontTypeOfApp(
            enteredFontSize: ConstantValues.fontSizeMethod(context),
            enteredFontWeight: FontWeight.bold),
        boxDecoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.white],
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
          ),
        ),
        imageFlex: 1,
        footerPadding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
      ),
      title: titleText,
      body: bodyText,
      footer: Text("All Rigts Reserved..."),
      useScrollView: true,
    );
  }

  static introductionPageListOfPages(
      BuildContext context, AnimationController incomingController) {
    var exaList = [
      for (var k = 0; k < ConstantValues.titleOfPageViewModels.length; k++)
        buildPageViewModel(
            ConstantValues.titleOfPageViewModels[k],
            ConstantValues.bodyTextOfPageViewModels[k],
            incomingController,
            context),
    ];
    return exaList;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox();
  }
}

/// LogInPage Methods
class RequiredMethodForLogInPage extends ConsumerWidget {
  static buildElevatedButton(BuildContext context, String about) {
    return Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 40,
          right: MediaQuery.of(context).size.width / 40),
      child: ElevatedButton.icon(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black;
              } else {
                return Colors.white;
              }
            }),
            foregroundColor: MaterialStateProperty.all(Colors.black)),
        icon: detectIconForButtons(about),
        label: Text(
          about,
          style: ConstantValues.fontTypeOfApp(
              enteredFontSize: MediaQuery.of(context).size.height / 60,
              enteredFontWeight: FontWeight.w300),
        ),
        onPressed: () {
          logInMethodWithEmail(context);
        },
      ),
    );
  }

  static detectIconForButtons(String about) {
    if (about == "LogIn") {
      return Icon(Icons.login);
    } else if (about == "SignIn") {
      return Icon(Icons.person_add_alt_1);
    } else if (about == "Add Profile Picture") {
      return Icon(Icons.add_a_photo);
    } else {
      return Icon(Icons.g_mobiledata_sharp);
    }
  }

  static logInMethodWithEmail(BuildContext context) async {
    try {
      if (DataForLogInPage.formKeyForLogInPage.currentState!.validate() ==
          true) {
        await ConstantValues.fireAuthObject
            .signInWithEmailAndPassword(
                email: DataForLogInPage.emailController.text,
                password: DataForLogInPage.passwordController.text)
            .then((value) {
          Navigator.pushNamedAndRemoveUntil(
              context, "/Launcher", (route) => false);
        });
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Ops. Something Went Wrong...\n\nPlease Check Your Email And Password."),
        ),
      );
    } catch (e) {
      return Future.error(e);
    }
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox();
  }
}

/// SignInPage Methods
class RequiredMethodForSignInPage extends ConsumerWidget {
  AnimationController? waitingController;
  RequiredMethodForSignInPage({required this.waitingController});
  static clearAllController() {
    DataForSignInPage.emailCreateController.clear();
    DataForSignInPage.passwordCreateController.clear();
    DataForLogInPage.emailController.clear();
    DataForLogInPage.passwordController.clear();
  }

  static backAnimatedMethod(
      BuildContext context,
      AnimationController incomingController,
      String about,
      int indexOfBirth,
      int indexOfGender) {
    return GestureDetector(
      onTap: () {
        if (about == "exit") {
          Navigator.pushNamedAndRemoveUntil(
              context, "/LogInPage", (route) => false);
          clearAllController();
        } else {}
      },
      child: Container(
        child: AnimatedIcon(
          icon: about == "add"
              ? AnimatedIcons.view_list
              : AnimatedIcons.home_menu,
          progress: incomingController,
          size: MediaQuery.of(context).size.width / 4,
          color: Colors.black,
        ),
      ),
    );
  }

  buildCupertinoMethod(
      BuildContext context, ControlsDetails details, String about) {
    return CupertinoButton(
      padding: ConstantValues.valueOfPadding(context),
      color: ConstantValues.colorOfButtons,
      child: Text(about),
      onPressed:
          about == "Next" ? details.onStepContinue : details.onStepCancel,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    buildRadioTileMethod(Gender incomingGender) {
      return Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width / 19.5,
            bottom: MediaQuery.of(context).size.width / 19.5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: ConstantValues.borderRadiusMethod(context),
            boxShadow: [
              BoxShadow(
                  color: Colors.white, offset: Offset(10, 10), blurRadius: 12),
            ],
          ),
          child: RadioListTile(
            activeColor: Colors.white,
            value: incomingGender,
            groupValue: ref.watch(genderProvider).userGender,
            title: Text(
              describeEnum(incomingGender),
              textAlign: TextAlign.left,
              style: ConstantValues.fontTypeOfApp(
                  enteredFontSize: MediaQuery.of(context).size.width / 27,
                  enteredFontWeight: FontWeight.bold),
            ),
            onChanged: (incoming) {
              ref.watch(genderProvider.notifier).changeGender(incomingGender);
            },
          ),
        ),
      );
    }

    cupertinoPickerMethod() {
      return Container(
        height: MediaQuery.of(context).size.height / 2.41,
        child: CupertinoPicker(
          scrollController: DataForSignInPage.cupertinoPickerController,
          backgroundColor: Colors.transparent,
          looping: true,
          children: [
            for (var k in DataForSignInPage.listOfBirthday) Text(k.toString()),
          ],
          itemExtent: 64,
          onSelectedItemChanged: (incomign) {
            ref
                .watch(cupertinoIndexProvider.notifier)
                .newIndex(DataForSignInPage.listOfBirthday[incomign]);
          },
        ),
      );
    }

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                backAnimatedMethod(
                  context,
                  this.waitingController!,
                  "exit",
                  ref.watch(cupertinoIndexProvider).cupertinoIndex!,
                  ref.watch(genderProvider).userGender!.index,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 15,
            ),
            Stepper(
              steps: [
                Step(
                  title: Text("Email And Password"),
                  content: Column(
                    children: [
                      for (var k = 0;
                          k < DataForLogInPage.listOfLogInPageFields.length;
                          k++)
                        BuildTextFormField(
                            about: "New " +
                                DataForLogInPage.listOfLogInPageFields[k],
                            incomingController:
                                DataForSignInPage.listOfCreateControllers[k],
                            incomingKey:
                                DataForSignInPage.keysOfSignInFields[k]),
                    ],
                  ),
                ),
                Step(
                  title: Text("Select Gender"),
                  content: Center(
                    child: Column(
                      children: [
                        for (var k in Gender.values) buildRadioTileMethod(k),
                      ],
                    ),
                  ),
                ),
                Step(
                  title: Text("Select The Date Of Birth"),
                  content: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: CupertinoButton(
                            color: ConstantValues.colorOfFields,
                            borderRadius:
                                ConstantValues.borderRadiusMethod(context),
                            child: Text(
                              "Select Date Of Birth",
                              style: ConstantValues.fontTypeOfApp(
                                  enteredFontSize:
                                      MediaQuery.of(context).size.width / 27,
                                  enteredFontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              showCupertinoModalPopup(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CupertinoActionSheet(
                                        actions: [cupertinoPickerMethod()],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.maybePop(context);
                                          },
                                        ),
                                      ));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              currentStep: ref.watch(providerOfStepperIndex).activeIndex!,
              onStepContinue: () {
                ref.watch(providerOfStepperIndex.notifier).signInMethod(
                    context,
                    ref.watch(cupertinoIndexProvider).cupertinoIndex!,
                    ref.watch(genderProvider).userGender!.index);
              },
              onStepCancel: () {
                ref.watch(providerOfStepperIndex.notifier).decreaseIndex();
              },
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildCupertinoMethod(context, details, "Next"),
                    buildCupertinoMethod(context, details, "Back"),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Launcher Page Methods
class RequiredMethodForLauncherPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: Colors.white,
      items: [
        Icon(Icons.home),
        Icon(Icons.favorite),
        Icon(Icons.shopping_cart),
        Icon(Icons.account_box_outlined),
      ],
      onTap: (incomingIndex) {
        ref.watch(providerOfBottomBar.notifier).changeIndex(incomingIndex);
      },
    );
  }
}

class BuildTextFormField extends ConsumerWidget {
  TextEditingController incomingController;
  String about;
  GlobalKey<FormFieldState>? incomingKey;
  BuildTextFormField(
      {required this.about,
      required this.incomingController,
      this.incomingKey});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    detectPasswordShowStatue(String about) {
      if (about == "Password" || about == "New Password") {
        return ref.watch(passwordProvider).showStatue;
      } else {
        return false;
      }
    }

    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        key: incomingKey,
        validator: (incoming) {
          if (about == "Email" || about == "New Email") {
            if (EmailValidator.validate(incoming!) == false) {
              return "InValid Email Adress";
            } else {
              return null;
            }
          } else {
            if (incoming!.isEmpty == true) {
              return "It Can Not Be Empty!";
            } else {
              return null;
            }
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: incomingController,
        obscureText: detectPasswordShowStatue(about),
        decoration: InputDecoration(
          suffixIcon: about == "Password" || about == "New Password"
              ? IconButton(
                  icon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    ref.watch(passwordProvider.notifier).showPassword();
                  },
                )
              : null,
          prefixIcon: about == "Email"
              ? Icon(
                  Icons.email,
                  color: Colors.white,
                )
              : Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: ConstantValues.borderSideValue,
            borderRadius: ConstantValues.borderRadiusMethod(context),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
            borderRadius: ConstantValues.borderRadiusMethod(context),
          ),
          filled: true,
          fillColor: Colors.black.withOpacity(0.5),
          hintText: about,
          hintStyle: ConstantValues.fontTypeOfApp(
              enteredFontSize: MediaQuery.of(context).size.width / 27,
              enteredFontWeight: FontWeight.bold,
              enteredColor: Colors.white),
        ),
      ),
    );
  }
}

class ShaderMaskOperation extends ConsumerWidget {
  String? wantedImage;
  ShaderMaskOperation({required this.wantedImage});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShaderMask(
      shaderCallback: (incoming) {
        return LinearGradient(
          colors: [Colors.white, Colors.black38],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(incoming);
      },
      blendMode: BlendMode.darken,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken),
              fit: BoxFit.cover,
              image: AssetImage("lib/data/images/${wantedImage}.jpg")),
        ),
      ),
    );
  }
}