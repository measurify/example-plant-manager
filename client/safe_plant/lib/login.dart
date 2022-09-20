import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safe_plant/home.dart';
import 'package:safe_plant/api_service.dart';
import 'package:safe_plant/login_response_json.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final myControllerUsername = TextEditingController();
  final myControllerPassword = TextEditingController();
  final myControllerTenant = TextEditingController();
  late LoginResponse? _loginResponse = null;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerUsername.dispose();
    myControllerPassword.dispose();
    myControllerTenant.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color.fromARGB(255, 46, 191, 75),
              Color.fromARGB(255, 206, 252, 206)
            ])),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                ),
                Card(
                    color: Colors.white,
                    elevation: 5,
                    shadowColor: Colors.grey.shade200,
                    //margin: EdgeInsets.all(10),
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.white)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 60),
                        ),
                        Image.asset(
                          'assets/images/leaf.png',
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 60),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                ),
                Text(
                  "Welcome!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Center(
                  child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.grey.shade200,
                      margin:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.white)),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                  ),
                                  Text(
                                    "Username",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                  ),
                                  TextField(
                                    cursorHeight: 20,
                                    autofocus: false,
                                    controller: myControllerUsername,
                                    decoration: InputDecoration(
                                      hintText: "Enter your username",
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.greenAccent.shade700,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        gapPadding: 0.0,
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.green.shade200,
                                            width: 1.5),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                  ),
                                  Text(
                                    "Password",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                  ),
                                  TextField(
                                    cursorHeight: 20,
                                    autofocus: false,
                                    controller: myControllerPassword,
                                    decoration: InputDecoration(
                                      hintText: "Enter your password",
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.greenAccent.shade700,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        gapPadding: 0.0,
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.green.shade200,
                                            width: 1.5),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                  ),
                                  Text(
                                    "Tenant",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                  ),
                                  TextField(
                                    cursorHeight: 20,
                                    autofocus: false,
                                    controller: myControllerTenant,
                                    decoration: InputDecoration(
                                      hintText: "Enter your Tenant",
                                      prefixIcon: Icon(
                                        Icons.computer,
                                        color: Colors.greenAccent.shade700,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        gapPadding: 0.0,
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.green.shade200,
                                            width: 1.5),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          Material(
                            elevation: 7.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            child: InkWell(
                              onTap: () async {
                                _loginResponse =
                                    (await ApiService().getLoginResponse(
                                        // myControllerUsername.text,
                                        // myControllerPassword.text,
                                        // myControllerTenant.text));
                                        //per test schermate
                                        "plant-manager-user-username",
                                        "plant-manager-user-password",
                                        "plant-manager-tenant"));

                                if (_loginResponse!.token == "error") {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        backgroundColor: Colors.white,
                                        title: Text(
                                          "Login Error!",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        content: Text(
                                          "Please enter a correct username, password and tenant.",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(
                                              "Close",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home(
                                              token: _loginResponse!.token,
                                              // username:
                                              //     myControllerUsername.text,
                                              // password:
                                              //     myControllerPassword.text,
                                              // tenant: myControllerTenant.text)),
                                              //per test schermate
                                              username:
                                                  "plant-manager-user-username",
                                              password:
                                                  "plant-manager-user-password",
                                              tenant: "plant-manager-tenant")),
                                      (_) => false);
                                }
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color.fromARGB(255, 82, 191, 104),
                                    Color.fromARGB(255, 42, 176, 69)
                                  ]),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                                height: 40,
                                width: 150,
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          "Log In",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 48.0,
                                      child: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                        size: 23.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ],
                      )),
                )
              ],
            )));
  }
}
