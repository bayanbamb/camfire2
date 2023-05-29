/*import 'package:flutter/material.dart';
import 'package:first_app/database_helper.dart';
import 'package:first_app/Screens/Login/components/login_form.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late DBHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your App Name'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String user = _usernameController.text;
                String pass = _passwordController.text;

                if (user.isEmpty || pass.isEmpty) {
                  Fluttertoast.showToast(msg: 'Please enter all fields');
                } else {
                  bool checkUser = _dbHelper.checkUsername(user) as bool;
                  if (!checkUser) {
                    Future<bool> insert = _dbHelper.insertData(user, pass);
                    if (await insert) {
                      Fluttertoast.showToast(msg: 'Registered successfully');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainActivity()),
                      );
                    } else {
                      Fluttertoast.showToast(msg: 'Registration failed');
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Already exists! Please sign in');
                  }
                }
              },
              child: Text('Sign Up'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginForm()),
                );
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}*/
