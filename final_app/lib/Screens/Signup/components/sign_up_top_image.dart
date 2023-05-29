import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class SignUpScreenTopImage extends StatelessWidget {
  const SignUpScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Image.asset(
          "assets/icons/signup.jpg",
          height: size.height * 0.1,
        ),
        SizedBox(height: defaultPadding),
        Text(
          "Sign Up".toUpperCase(),
          style: TextStyle(
              color: Color.fromARGB(195, 55, 79, 61),
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: defaultPadding),
        Row(
          children: [
            const Spacer(),
            const Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding),
      ],
    );
  }
}
