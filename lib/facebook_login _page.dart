import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLoginPage extends StatefulWidget {
  const FacebookLoginPage({Key? key}) : super(key: key);
  @override
  _FacebookLoginPageState createState() => _FacebookLoginPageState();
}

class _FacebookLoginPageState extends State<FacebookLoginPage> {
  bool isLoggedIn = false;
  AccessToken? _accessToken;
  Map _userObj = {};


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FaceBook Login'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: _buildWidget(),
      ),
    );
  }

  _buildWidget() {
    if (isLoggedIn) {
      // String name = _userObject['name'];
      return Column(
        children: [
           ListTile(
            leading: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_userObj['picture']['data']['url']),
            ),
            title: Text(_userObj['name']),
            subtitle: Text(_userObj['email']),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Successfully Logged in",
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              FacebookAuth.instance.logOut().then((value) {
                setState(() {
                  isLoggedIn = false;
                  _userObj = {};
                });
              });
            },
            child: const Text("Sign Out "),
          )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text(
              "You are not signed in",
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                signInWithFacebook();
              },
              child: const Text("Sign In"),
            )
          ],
        ),
      );
    }
  }

  Future<void> signInWithFacebook() async {
    FacebookAuth.instance
        .login(permissions: ['public_profile', 'email']).then((value) async {
      await FacebookAuth.instance.getUserData().then((userData){
        setState(() {
          isLoggedIn = true;
          _userObj = userData;
        });
      });
    });
  }

  // {
  // "id": "USER-ID",
  // "name": "EXAMPLE NAME",
  // "email": "EXAMPLE@EMAIL.COM",
  // "picture": {
  // "data": {
  // "height": 50,
  // "is_silhouette": false,
  // "url": "URL-FOR-USER-PROFILE-PICTURE",
  // "width": 50
  // }
  // }
  // }
}
