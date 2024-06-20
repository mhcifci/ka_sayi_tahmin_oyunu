// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';
import 'package:flutter/services.dart'; // Add this line

import 'package:flutter/material.dart';
import 'package:ka_sayi_tahmin_oyunu/Homepage.dart';
import 'package:ka_sayi_tahmin_oyunu/ResultScreen.dart';

class GuessScreen extends StatefulWidget {
  const GuessScreen({super.key});

  @override
  State<GuessScreen> createState() => _GuessScreenState();
}

class Guess {
  String direction;
  int guess;

  Guess(this.direction, this.guess);
}

class _GuessScreenState extends State<GuessScreen> {
  var tfGuess = TextEditingController();

  int randomNumber = 0;
  int remaining = 3;
  String direction = "Başlayalım...";
  int point = 0;

  List<Guess> guesses = [];

  @override
  void initState() {
    super.initState();
    generateRandomNumber();
  }

  void generateRandomNumber() {
    setState(() {
      randomNumber = 1 + Random().nextInt(9);
      debugPrint("Rastgele Sayı: $randomNumber");
    });
  }

  void guessed() {
    setState(() {
      // Puanı ile kalan hakkı çarp
      point = 10 + point * remaining;
      remaining = remaining + 1;
      direction = "Çok iyisin, devam et!";
      generateRandomNumber();
      tfGuess.clear();
      guesses.clear();
    });
  }

  void guessIt() {
    // Tahmin boş olamaz.
    if (tfGuess.text.isNotEmpty) {
      setState(() {
        int tahmin = int.tryParse(tfGuess.text) ?? 0;

        // Eğer tahminler listesinde tahmin varsa uyarı ver.
        if (guesses.contains(
            guesses.where((element) => element.guess == tahmin).firstOrNull)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content:
                  Center(child: Text("$tahmin sayısını daha önce yazdın! 🤓")),
              duration: Duration(seconds: 1),
            ),
          );
          //tfGuess.clear();
          return;
        }

        if (tahmin != 0) {
          if (tahmin == randomNumber) {
            guessed();
            // show snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Center(child: Text("Tebrikler! Tahminin doğru!")),
                duration: Duration(seconds: 1),
              ),
            );
            return;
          } else {
            remaining--;
            if (remaining == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ResultScreen()),
              );
            }
            if (tahmin < randomNumber) {
              direction = "Tahmini arttır";
              tfGuess.text = "";
              guesses.add(Guess("up", tahmin));
            } else {
              direction = "Tahmini azalt";
              tfGuess.text = "";
              guesses.add(Guess("down", tahmin));
            }
          }
        }
        tfGuess.clear();
        return;
      });
    } else {
      // Eğer tahmin boş ise uyarı ver.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blueGrey,
          content: Center(child: Text("Tahmin boş olamaz!")),
          duration: Duration(seconds: 1),
        ),
      );

      return;
    }
  }

  void getHelp() {
    if (point >= 50) {
      setState(() {
        point -= 50;
        if (randomNumber % 2 == 0) {
          direction = "Sayı çifttir.";
        } else {
          direction = "Sayı tektir.";
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text("Yeterli puanınız yok!")),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.pink,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              "Puan: $point",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GuessScreen()),
                                );
                              });
                            },
                            child: Text(
                              "Yeniden Başla",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Homepage()),
                                );
                              });
                            },
                            child: Text(
                              "Çıkış",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Image.asset("assets/dice.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                "Kalan Hakkınız: $remaining",
                                style:
                                    TextStyle(color: Colors.pink, fontSize: 24),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Text(
                                "Yardım: $direction",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.black87, // Çizgi rengi
                                      width: 0.2, // Çizgi kalınlığı
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ], //
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  autofocus: true,
                                  controller: tfGuess,
                                  onTap: () {
                                    tfGuess.clear();
                                  },
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      return;
                                    }
                                    if (value.length > 0) {
                                      guessIt();
                                    }
                                  },
                                  style: TextStyle(
                                    fontSize:
                                        42, // Metnin boyutunu burada ayarlayabilirsiniz
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    counterText: '',
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {
                                    guessIt();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink,
                                    alignment: Alignment.center,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  child: Text(
                                    "Tahmin Et",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {
                                    getHelp();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    alignment: Alignment.center,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  child: Text(
                                    "Yardım Al (-50 Puan)",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30, left: 30, right: 30),
                              child: Wrap(
                                spacing: 8.0,
                                children: guesses
                                    .map(
                                      (e) => Chip(
                                        label: Text(
                                          e.guess.toString(),
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                        backgroundColor: Colors.white70,
                                        shadowColor: e.direction == "up"
                                            ? Colors.teal
                                            : Colors.pink,
                                        elevation: 5.0,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
