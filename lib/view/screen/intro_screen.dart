import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/intro_repo.dart';
import 'package:nelayan_coba/view/screen/home_screen.dart';
import 'package:nelayan_coba/view/screen/login_screen.dart';
import 'package:nelayan_coba/view/widget/intro_item.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final CarouselController carouselController = CarouselController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: IntroRepo.introList.length,
            itemBuilder: (context, index, realIndex) => IntroItem(
              imageUrl: IntroRepo.introList[index].imageUrl,
              title: IntroRepo.introList[index].title,
              description: IntroRepo.introList[index].description,
            ),
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              autoPlay: true,
              scrollDirection: Axis.horizontal,
              initialPage: 0,
              onPageChanged: (index, reason) => setState(() => selectedIndex = index),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCarouselIndicator(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LoginScreen())
                  ),
                  child: const Text('Mulai'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselIndicator() {
    List<Widget> indicators = [];

    for (int i = 0; i < IntroRepo.introList.length; i++) {
      indicators.add(TabPageSelectorIndicator(
        backgroundColor: i == selectedIndex ? Colors.blue : Colors.white,
        borderColor: Colors.white,
        size: 8,)
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }
}