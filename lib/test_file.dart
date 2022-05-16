import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class EmailLogin extends StatefulWidget {
  const EmailLogin({Key? key}) : super(key: key);

  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  TextEditingController numberController = TextEditingController();

  bool _isLoggedIn = false;
  Map _userObj = {};
  AccessToken? _accessToken;

  Future<void> signIn() async {
    final LoginResult result = await FacebookAuth.i.login();
    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;

      await FacebookAuth.i.getUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 25,
          ),
        ),
        title: const Text(
          "Login",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Container(
              child: _isLoggedIn
                  ? Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              _userObj["picture"]["data"]["url"]),
                        ),
                        Text(_userObj["name"]),
                        Text(_userObj["email"]),
                        TextButton(
                            onPressed: () {
                              FacebookAuth.instance.logOut().then((value) {
                                setState(() {
                                  _isLoggedIn = false;
                                  _userObj = {};
                                });
                              });
                            },
                            child: const Text("Logout"))
                      ],
                    )
                  : Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xff49639F),
                          onPrimary: const Color(0xff49639F),
                          elevation: 3,
                          minimumSize: const Size(100, 40),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: Row(
                            children: const [

                               SizedBox(
                                width: 8,
                              ),
                               Text(
                                "Sign Up or Login with Facebook",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        onPressed: () async {
                          FacebookAuth.instance.login(permissions: [
                            "public_profile",
                            "email"
                          ]).then((value) async {
                            await FacebookAuth.instance
                                .getUserData()
                                .then((userData) {
                              setState(() {
                                _isLoggedIn = true;
                                _userObj = userData;
                              });
                            });
                          });
                        },
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Row(
                children: const [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Sign Up or Login with Google",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Expanded(
                child: Divider(
                  indent: 20.0,
                  endIndent: 10.0,
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),
              Text(
                "or",
                style: TextStyle(color: Colors.grey),
              ),
              Expanded(
                child: Divider(
                  indent: 10.0,
                  endIndent: 20.0,
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
