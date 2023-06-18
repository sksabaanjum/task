import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showPassword = false;
  final emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  bool validateEmail(String email) {
    final regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  void login() async {
    try {
      Response response = await post(
        Uri.parse('https://stage.getsetplay.co/api/login.php'),
        body: jsonEncode(<String, String>{
          "username": _emailController.text,
          "password": _passwordController.text
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data['token']);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['message']),
        ));

        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        });
      } else {
        var data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['message']),
        ));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Login Page',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 50),
          SizedBox(
            height: 140,
            width: 100,
            child: Image.asset("assets/images/person_icon.png"),
          ),
          Form(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Your email';
                      }
                      if (!validateEmail(_emailController.text)) {
                        return 'Please Enter Valid Email';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter your email',
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(36.0),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey.shade900,
                        focusColor: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: showPassword ? false : true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Your Password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter your password',
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(
                          Icons.security,
                          color: Colors.white,
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          child: Icon(
                            showPassword
                                ? Icons.visibility_off
                                : Icons.remove_red_eye,
                            color: Colors.white,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(36.0),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey.shade900,
                        focusColor: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
