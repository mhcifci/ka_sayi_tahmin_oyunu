import 'package:flutter/material.dart';
import 'package:ka_sayi_tahmin_oyunu/Homepage.dart';
import 'package:ka_sayi_tahmin_oyunu/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = index == 1;
              });
            },
            children: [
              buildPage(
                color: Colors.white,
                image: 'assets/home.png',
                title: 'Hoş geldiniz!',
                description:
                    'Sayı tahmin oyunu her yaşa uygun, zevkli vakit geçirebileceğiniz bir oyundur.',
              ),
              buildPage(
                color: Colors.white,
                image: 'assets/home.png',
                title: 'Oynanış',
                description:
                    'Oyunda sayı tahmin etmek kolaydır. 1-10 arasında bir sayı tahmin ederek oyunu kazanabilirsiniz. \n\n Her tahmininizde puanınız artar ve kalan hakkınız ile 10 puan çarpılır.',
              ),
            ],
          ),
          Positioned(
            bottom: 100,
            right: 50,
            child: SmoothPageIndicator(
              controller: _controller,
              count: 2,
              effect: const WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                type: WormType.thin,
                strokeWidth: 3,
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: onLastPage
                ? ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('onboardingCompleted', true);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Homepage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    child: const Text(
                      'Hadi Başlayalım',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    child: const Text('İleri',
                        style: TextStyle(color: Colors.white)),
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildPage({
    required Color color,
    required String image,
    required String title,
    required String description,
  }) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 300, child: Image.asset(image)),
          const SizedBox(height: 32),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              description,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
