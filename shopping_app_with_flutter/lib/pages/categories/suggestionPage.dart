import 'package:flutter/material.dart';
import '../../data/dataWareHouse.dart';
import '../../data/requiredMethods.dart';

class SuggestionPage extends StatelessWidget {
  const SuggestionPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String incomingAbout = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: Hero(
                tag: "suggestion",
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width / 7.8,
                      ),
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: MediaQuery.of(context).size.height / 2,
                      child: Image.network(incomingAbout),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(width: 1, color: Colors.black),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(20, 20),
                              blurRadius: 20),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      margin: EdgeInsets.only(left: 0,top: 50),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
                      ),
                      child: Text(RequiredMethodForHomePage.detectPriceForSuggestionPage(incomingAbout),style: ConstantValues.fontTypeOfApp(enteredFontSize: 30, enteredFontWeight: FontWeight.bold,enteredColor: Colors.white),textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: GridView.builder(
                itemCount: DataForHomePage.listOfSuggestionTinyImages.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    child: Image.network(
                      DataForHomePage.listOfSuggestionTinyImages[index],
                      fit: BoxFit.cover,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(5, 5),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  boxShadow: [
                    const BoxShadow(
                        color: Colors.black54,
                        offset:const Offset(20, 20),
                        blurRadius: 24),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                        child:const Text("Go Back"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}