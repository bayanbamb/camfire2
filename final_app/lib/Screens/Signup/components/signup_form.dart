import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';
import 'package:first_app/database_helper.dart';
import 'package:first_app/Screens/Login/components/login_form.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:first_app/Screens/Home/home_screen.dart';

class SignUpForm extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
  const SignUpForm({
    Key? key,
  }) : super(key: key);
}

class _MainActivityState extends State<SignUpForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  //late DBHelper _dbHelper;
  DBHelper dbHelper = DBHelper();

  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
            controller: _usernameController,
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
              controller: _passwordController,
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
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () async {
              final user = _usernameController.text;
              final pass = _passwordController.text;

              if (user.isEmpty || pass.isEmpty) {
                Fluttertoast.showToast(msg: 'Please enter all fields');
              } else {
                bool checkUser = await dbHelper.checkUsername(user);
                if (!checkUser) {
                  bool insert = await dbHelper.insertData(user, pass);
                  if (insert) {
                    Fluttertoast.showToast(msg: 'Registered successfully');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  } else {
                    Fluttertoast.showToast(msg: 'Registration failed');
                  }
                } else {
                  Fluttertoast.showToast(msg: 'Already exists! Please log in');
                }
              }
            },
            child: Text('Sign Up'),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
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
