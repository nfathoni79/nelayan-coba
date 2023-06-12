import 'package:nelayan_coba/model/intro.dart';
import 'package:nelayan_coba/util/my_strings.dart';

class IntroRepo {
  static List<Intro> introList = [
    Intro(
      imageUrl: 'assets/images/intro_1.png',
      title: MyStrings.introTitle1,
      description: MyStrings.introDesc1,
    ),
    Intro(
      imageUrl: 'assets/images/intro_2.png',
      title: MyStrings.introTitle2,
      description: MyStrings.introDesc2,
    ),
    Intro(
      imageUrl: 'assets/images/intro_3.png',
      title: MyStrings.introTitle3,
      description: MyStrings.introDesc3,
    ),
  ];
}