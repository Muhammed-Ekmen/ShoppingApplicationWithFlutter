import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_with_flutter/data/requiredMethods.dart';
import 'dataWareHouse.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ModelOfPasswordShowStatue {
  bool showStatue = true;
  ModelOfPasswordShowStatue({required this.showStatue});
}

class ModelOfPasswordOperations
    extends StateNotifier<ModelOfPasswordShowStatue> {
  ModelOfPasswordOperations()
      : super(ModelOfPasswordShowStatue(showStatue: true));

  showPassword() {
    if (state.showStatue == false) {
      state = ModelOfPasswordShowStatue(showStatue: true);
    } else {
      state = ModelOfPasswordShowStatue(showStatue: false);
    }
  }
}

final passwordProvider =
    StateNotifierProvider<ModelOfPasswordOperations, ModelOfPasswordShowStatue>(
        (ref) {
  return ModelOfPasswordOperations();
});

class ModelOfGender {
  Gender? userGender;
  ModelOfGender({required this.userGender});
}

class ModelOfGenderOperation extends StateNotifier<ModelOfGender> {
  ModelOfGenderOperation() : super(ModelOfGender(userGender: Gender.None));

  void changeGender(Gender incomingGender) {
    state = ModelOfGender(userGender: incomingGender);
  }
}

final genderProvider =
    StateNotifierProvider<ModelOfGenderOperation, ModelOfGender>((ref) {
  return ModelOfGenderOperation();
});

class ModelOfCupertinoIndex {
  int? cupertinoIndex;
  ModelOfCupertinoIndex({required this.cupertinoIndex});
}

class ModelOfCupertinoIndexOperations extends StateNotifier<ModelOfCupertinoIndex> {
  ModelOfCupertinoIndexOperations()
      : super(ModelOfCupertinoIndex(cupertinoIndex: 0));
  void newIndex(int newIndex) {
    state = ModelOfCupertinoIndex(cupertinoIndex: newIndex);
  }
}

final cupertinoIndexProvider = StateNotifierProvider<
    ModelOfCupertinoIndexOperations, ModelOfCupertinoIndex>((ref) {
  return ModelOfCupertinoIndexOperations();
});

class ModelOfBottomBarIndex {
  int? pageIndex;
  ModelOfBottomBarIndex({required this.pageIndex});
}

class ModelOfBottomBarOperation extends StateNotifier<ModelOfBottomBarIndex> {
  ModelOfBottomBarOperation() : super(ModelOfBottomBarIndex(pageIndex: 0));
  void changeIndex(int incomingIndex) {
    state = ModelOfBottomBarIndex(pageIndex: incomingIndex);
  }
}

final providerOfBottomBar =
    StateNotifierProvider<ModelOfBottomBarOperation, ModelOfBottomBarIndex>(
        (ref) {
  return ModelOfBottomBarOperation();
});

class ModelOfStepIndex {
  int? activeIndex;
  ModelOfStepIndex(this.activeIndex);
}

class ModelOfStepIndexOperation extends StateNotifier<ModelOfStepIndex> {
  ModelOfStepIndexOperation() : super(ModelOfStepIndex(0));

  void decreaseIndex() {
    if (state.activeIndex! > 0) {
      state = ModelOfStepIndex(state.activeIndex! - 1);
    } else {
      state = ModelOfStepIndex(0);
    }
  }

  Future<void> signInMethod(
      BuildContext context, int indexOfBirth, int indexOfGender) async {
    try {
      switch (state.activeIndex!) {
        case 0:
          if (DataForSignInPage.newEmailKey.currentState!.validate() == true &&
              DataForSignInPage.newPasswordKey.currentState!.validate() ==
                  true) {
            state = ModelOfStepIndex(1);
          }
          break;

        case 1:
          state = ModelOfStepIndex(2);
          break;
        case 2:
          if (indexOfBirth != 0) {
            await ConstantValues.fireAuthObject
                .createUserWithEmailAndPassword(
                    email: DataForSignInPage.emailCreateController.text,
                    password: DataForSignInPage.passwordCreateController.text)
                .then((value) async {
              Map<String, dynamic> userInfos = {
                "GenderIndex": indexOfGender,
                "DateOfBirth": indexOfBirth,
                "listOfFavoritesId":[],
                "listOfProductId": [],
              };
              await FirebaseFirestore.instance
                  .collection("Users")
                  .doc(DataForSignInPage.emailCreateController.text)
                  .set(userInfos);
              RequiredMethodForSignInPage.clearAllController();
              state=ModelOfStepIndex(0);
              var message = CupertinoAlertDialog(
                title: Text("User Has Created Succesfully..."),
                content: Text(
                    "Now,You Can Sign In With Your Email..."),
                actions: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: () {
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
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}

final providerOfStepperIndex =
    StateNotifierProvider<ModelOfStepIndexOperation, ModelOfStepIndex>((ref) {
  return ModelOfStepIndexOperation();
});


class ModelOfUpdateGender{
  Gender? incomingGender;
  ModelOfUpdateGender({required this.incomingGender});
}

class ModelOfUpdateGenderOperation extends StateNotifier<ModelOfUpdateGender>{
  ModelOfUpdateGenderOperation():super(ModelOfUpdateGender(incomingGender: Gender.None));
  void updateGender(Gender? incoming){
    state=ModelOfUpdateGender(incomingGender: incoming);
  }
}

final providerOfUpdateGender=StateNotifierProvider<ModelOfUpdateGenderOperation,ModelOfUpdateGender>((ref){
  return ModelOfUpdateGenderOperation();
});

class ModelOfUpdateCupertinoIndex{
  int? updateCupertinoIndex;
  ModelOfUpdateCupertinoIndex({required this.updateCupertinoIndex});
}

class ModelOfUpdateCupertinoIndexOperation extends StateNotifier<ModelOfUpdateCupertinoIndex>{
  ModelOfUpdateCupertinoIndexOperation():super(ModelOfUpdateCupertinoIndex(updateCupertinoIndex: 0));
  void newUpdateIndex(incomingIndex){
    state=ModelOfUpdateCupertinoIndex(updateCupertinoIndex: incomingIndex);
  }
}

final providerOfUpdateCupertino=StateNotifierProvider<ModelOfCupertinoIndexOperations,ModelOfCupertinoIndex>((ref){
  return ModelOfCupertinoIndexOperations();
});