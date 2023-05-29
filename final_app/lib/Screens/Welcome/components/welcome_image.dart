import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: Image.asset(
                "assets/icons/logo.png",
                height: size.height * 0.5,
              ),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding * 0.3),
        Text(
          "Hello Campers!",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
            color: Color.fromARGB(255, 58, 86, 83),
          ),
        ),
        Text(
          "Wanna rent some camping equipment?",
          style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal),
        ),
        SizedBox(height: defaultPadding * 1),
      ],
    );
  }
}
