import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';
import '../../Home/home_screen.dart';
import 'package:first_app/database_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginForm extends StatefulWidget {
  String _loggedInUser = '';

  @override
  _LoginActivityState createState() => _LoginActivityState();
  LoginForm({
    Key? key,
  }) : super(key: key);
}

class _LoginActivityState extends State<LoginForm> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  DBHelper dbHelper = DBHelper();

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            controller: usernameController,
            decoration: InputDecoration(
              hintText: "Your username",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: passwordController,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () async {
                final user = usernameController.text;
                final pass = passwordController.text;

                if (user.isEmpty || pass.isEmpty) {
                  Fluttertoast.showToast(msg: 'Please enter all fields');
                } else {
                  final check =
                      await dbHelper.checkUsernamePassword(user, pass);
                  if (check) {
                    setState(() {
                      widget._loggedInUser = user;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EmptyScreen(loggedInUser: widget._loggedInUser)),
                    );
                  } else {
                    Fluttertoast.showToast(msg: "Wrong Account");
                  }
                }
              },
              child: Text("Login".toUpperCase()),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
