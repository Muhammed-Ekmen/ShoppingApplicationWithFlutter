import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flip_card/flip_card_controller.dart';

class ConstantValues {
  static valueOfPadding(BuildContext context){
    return EdgeInsets.all(MediaQuery.of(context).size.width/19.5);
  } 
  static Color colorOfButtons=Colors.black;
  static Color colorOfFields=Colors.black.withOpacity(0.5);
  static BorderSide borderSideValue=BorderSide(width: 1,color: Colors.transparent);
  static BorderRadius borderRadiusMethod(BuildContext context){
    return BorderRadius.circular(MediaQuery.of(context).size.width/13);
  }
  static double fontSizeMethod(BuildContext context){
    return MediaQuery.of(context).size.width/16.25;
  } 
  static String productURL = "https://fakestoreapi.com/products";
  static final fireAuthObject = FirebaseAuth.instance;
  static String titleOfLogInPage = "Welcome";
  static List<String> titleOfPageViewModels = [
    "Is The Product Safe?",
    "Do You Bill My Card?",
    "What Happens To My Data?"
  ];
  static List<String> bodyTextOfPageViewModels = [
    "It's so protected that even our team has no any access to your payment data.",
    "We Will Never Bill Your Card. Seriously, We Earn Money From Services,Not From Users",
    "You Provide Your Data To Our Robot Without Human Interaction. Then It Shows Stats To You."
  ];
  static fontTypeOfApp(
      {required double? enteredFontSize,
      required FontWeight? enteredFontWeight,
      Color enteredColor = Colors.black}) {
    return GoogleFonts.inter(
      fontStyle: FontStyle.italic,
      fontSize: enteredFontSize,
      fontWeight: enteredFontWeight,
      color: enteredColor,
    );
  }
}

class DataForLogInPage {
  static final formKeyForLogInPage = GlobalKey<FormState>();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static List<TextEditingController> listOfContoller = [
    emailController,
    passwordController
  ];
  static List<String> listOfLogInPageFields = ["Email", "Password"];
}

class DataForSignInPage {
  static TextEditingController emailCreateController = TextEditingController();
  static TextEditingController passwordCreateController =
      TextEditingController();
  static List<TextEditingController> listOfCreateControllers = [
    emailCreateController,
    passwordCreateController
  ];
  static FixedExtentScrollController cupertinoPickerController =
      FixedExtentScrollController(initialItem: cupertinoPickerIndex);
  static List<int> listOfBirthday = [for (var k = 1970; k <= 2004; k++) k];
  static int cupertinoPickerIndex = 0;
  static final defaultKey = GlobalKey<FormFieldState>();
  static final defaultKeySecond = GlobalKey<FormFieldState>();
  static List<GlobalKey<FormFieldState>> keysOfSignInFieldss = [
    defaultKey,
    defaultKeySecond
  ];
  static final newEmailKey = GlobalKey<FormFieldState>();
  static final newPasswordKey = GlobalKey<FormFieldState>();
  static List<GlobalKey<FormFieldState>> keysOfSignInFields = [
    newEmailKey,
    newPasswordKey
  ];
}

class DataForHomePage {
  static final List<String> listOfBottombarItems = [
    "HomePage",
    "Favorites",
    "Bag",
    "Account"
  ];
  static final homePageKey = PageStorageKey("homepage_key");
  static final favoritePageKey = PageStorageKey("favorite_key");
  static final bagPageKey = PageStorageKey("bagpage_key");
  static final accountPageKey = PageStorageKey("accountpage_key");
  static FlipCardController firstFlipController = FlipCardController();
  static FlipCardController secondFlipController = FlipCardController();
  static FlipCardController thirdFlipController = FlipCardController();
  static FlipCardController fourthFlipController = FlipCardController();
  static String firstSuggestion =
      "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg";
  static String secondSuggestion =
      "https://fakestoreapi.com/img/71HblAHs5xL._AC_UY879_-2.jpg";
  static String thirdSuggestion =
      "https://fakestoreapi.com/img/81Zt42ioCgL._AC_SX679_.jpg";
  static String fourthSuggestion =
      "https://fakestoreapi.com/img/51eg55uWmdL._AC_UX679_.jpg";
  static List listOfSuggestionImage = [
    firstSuggestion,
    secondSuggestion,
    thirdSuggestion,
    fourthSuggestion
  ];
  static String electrinicCategoryImage =
      "https://images.hepsiburada.net/banners/s/0/960-352/banner_20220422085605.jpeg/format:webp";
  static String jewelCategoryImage =
      "https://images.hepsiburada.net/banners/s/0/960-352/banner_20220228144951.png/format:webp";
  static String womenCategoryImage =
      "https://images.hepsiburada.net/banners/s/0/1440-1080/kadin(1)132906015387036784.jpg/format:webp";
  static String menCategoryImage =
      "https://images.hepsiburada.net/banners/s/0/1440-1080/erkek(1)132906015876577484.jpg/format:webp";
  static String suggestionFirstImage =
      "https://images.hepsiburada.net/banners/s/0/278-250/banner_20220412115407.png/format:webp";
  static String suggestionSecondImage =
      "https://images.hepsiburada.net/banners/s/0/278-250/banner_20220412115445.png/format:webp";
  static String suggestionThirdImage =
      "https://images.hepsiburada.net/banners/s/0/278-250/banner_20220412115526.png/format:webp";
  static String suggestionFourthImage =
      "https://images.hepsiburada.net/banners/s/0/278-250/banner_20220412115613.png/format:webp";
  static String suggestionFivethImage =
      "https://images.hepsiburada.net/banners/s/0/278-250/banner_20220412115722.png/format:webp";
  static String suggestionSixthImage =
      "https://images.hepsiburada.net/banners/s/0/278-250/banner_20220412115757.png/format:webp";
  static List<String> listOfSuggestionTinyImages = [
    suggestionFirstImage,
    suggestionSecondImage,
    suggestionThirdImage,
    suggestionFourthImage,
    suggestionFivethImage,
    suggestionSixthImage
  ];
}

class DataForAccountPage {
  static FixedExtentScrollController cupertinoUpdatePickerController =
      FixedExtentScrollController(initialItem: cupertinoUpdatePickerIndex);
  static int cupertinoUpdatePickerIndex = 0;
  static final Stream<QuerySnapshot> fireStoreObject =
      FirebaseFirestore.instance.collection("Users").snapshots();
  static getDocument(String documentId) {
    return FirebaseFirestore.instance.collection("Users").doc(documentId);
  }

  static FlipCardController secondFlipController = FlipCardController();
  static List<String> listOfAccountMenu = [
    "Information",
    "Setting",
    "Help",
    "LogOut"
  ];
  static List<String> listOfSettingSection = [
    "Change Personal Info",
    "Update Password",
    "Change Email Adress",
    "DELETE ACCOUNT",
    "Back"
  ];
  static List<String> listOfUpdatePage = [
    "Please Enter Current ",
    "Enter New ",
    "Re-Enter "
  ];
  static final formKey = GlobalKey<FormState>();
  static TextEditingController currentController = TextEditingController();
  static TextEditingController updateController = TextEditingController();
  static TextEditingController checkController = TextEditingController();
}

enum Gender {
  Male,
  Female,
  None,
}