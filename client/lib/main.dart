import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Fantasy Draft',
      routes: {
        "/": (context) => const SignInPage(),
      }
    );
  }
}

// ===================================================================================
// ===================================== Sign In =====================================
// ===================================================================================

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  
  @override
  SignInPageState createState() => SignInPageState();
}


class SignInPageState extends State<SignInPage> {

  final _formKey = GlobalKey<FormState>();

  Future<bool> signIn(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/login'),
        headers: <String, String> {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          "username": username,
          "password": password,
        }),
      );
      bool success = response.statusCode == 200;
      print(success);
      if (success) {
        // Set current user to the signed in user
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user', username);
      }
      return success;
    
    } catch (e) {
      print(e);
      return false;
    }

  }
  
  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    TextStyle defaultStyle = const TextStyle(color: Colors.grey, fontSize: 12.0);
    TextStyle linkStyle = const TextStyle(color: Colors.blue);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Username cannot be null';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be null';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    signIn(usernameController.text, passwordController.text).then((success) => {

                      // On success, move to next page
                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfilePage()),
                        )
                      
                      // Otherwise, show that no account is found
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login error'),
                          )
                        )
                      }
                    });
                  }
                },
                child: const Text('Login'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                text: TextSpan(
                  style: defaultStyle,
                  children: <TextSpan>[
                    const TextSpan(text: "Don't have an account?"),
                    TextSpan(
                      text: ' Register here',
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          )
                        }),
                  ],
                ),
              )
            ),
          ],
        )
      )
    );
  }
}

// ===================================================================================
// ===================================== Profile =====================================
// ===================================================================================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
      return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data?.getString('user');
            return Scaffold(
              body: Center(
                child: Text('Signed into user $user!'),
              ),
            );
          }
          return const CircularProgressIndicator(); // or some other widget
        },
      );
  }
}


// ===================================================================================
// ===================================== Register ====================================
// ===================================================================================


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  
  @override
  RegisterPageState createState() => RegisterPageState();
}


class RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();

  Future<bool> register(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/register'),
        headers: <String, String> {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          "username": username,
          "password": password,
        }),
      );
      bool success = response.statusCode == 200;
      if (success) {
        // Set current user to the signed in user
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user', username);
      }
      return success;
    
    } catch (e) {
      print(e);
      return false;
    }

  }
  
  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Username cannot be null';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be null';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
                validator: (String? value) {
                  if (value != passwordController.text) {
                    return 'Password does not match';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    register(usernameController.text, passwordController.text).then((success) => {

                      // On success, move to next page
                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfilePage()),
                        )
                      
                      // Otherwise, show that no account is found
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Registration error'),
                          )
                        )
                      }
                    });
                  }
                },
                child: const Text('Register'),
              ),
            ),
          ],
        )
      )
    );
  }
}
