import 'package:chatapplication/Pages/HomePage.dart';
import 'package:chatapplication/Pages/LoginPage.dart';
import 'package:chatapplication/Pages/searchscreen.dart';
import 'package:chatapplication/Widget/widget.dart';
import 'package:chatapplication/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../Helper/SharedPrefrenceHelper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  String username = "";
  String email = "";

  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  gettingUserData() async {
    await HelperFuction.getUserFullNamesf().then((value) {
      setState(() {
        username = value!;
      });
    });
    await HelperFuction.getUserEmailsf().then((value) {
      setState(() {
        email = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Profile',
          style: TextStyle(
              color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            const Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey,
            ),
            const SizedBox(height: 15),
            Text(
              username,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Divider(height: 2),
            ListTile(
              onTap: () {
                nextScreenReplacement(context, HomePage());
              },
              selectedColor: Theme.of(context).primaryColor,
              // selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                'Groups',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                nextScreen(context, const ProfilePage());
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person),
              title: const Text(
                'Profile',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('LogOut',
                            style: TextStyle(color: Colors.blue)),
                        content: const Text('Are you want to logout?'),
                        actions: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                              onTap: () {
                                authService.signOut();
                                nextScreenReplacement(
                                    context, const LoginPage());
                                nextScreenReplacement(
                                    context, const LoginPage());
                              },
                              child: const Text('LogOut',
                                  style: TextStyle(color: Colors.blue)))
                        ],
                      );
                    });
              },
              selectedColor: Theme.of(context).primaryColor,
              //selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                'LogOut',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 70),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              color: Colors.grey[700],
              size: 180,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ful Name  ",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  "${username}",
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
            Divider(
              height: 2,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Email",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  "${email}",
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
