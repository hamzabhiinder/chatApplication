import 'package:chatapplication/Helper/SharedPrefrenceHelper.dart';
import 'package:chatapplication/Pages/LoginPage.dart';
import 'package:chatapplication/Pages/ProfileScreen.dart';
import 'package:chatapplication/Pages/searchscreen.dart';
import 'package:chatapplication/Widget/groupTile.dart';
import 'package:chatapplication/Widget/widget.dart';
import 'package:chatapplication/services/auth_service.dart';
import 'package:chatapplication/services/databaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? group;
  bool isLoading = false;
  String groupName = "";

  //String manipulation

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  gettingUserData() async {
    await HelperFuction.getUserFullNamesf().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await HelperFuction.getUserEmailsf().then((value) {
      setState(() {
        email = value!;
      });
    });

    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapShot) {
      setState(() {
        group = snapShot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Groups',
          style: TextStyle(
              color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(Icons.search))
        ],
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
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Divider(height: 2),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
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
              //  selected: true,
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 27,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Create a group',
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ))
                    : TextField(
                        onChanged: (val) {
                          setState(() {
                            groupName = val;
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(39),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(39),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(39),
                          ),
                        ),
                      ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () async {
                    if (groupName != null) {
                      setState(() {
                        isLoading == true;
                      });
                      DatabaseServices(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(
                        userName,
                        FirebaseAuth.instance.currentUser!.uid,
                        groupName,
                      );
                      setState(() {
                        isLoading == false;
                      });
                      Navigator.of(context).pop();
                      snackBar(context, Colors.green, 'Successfully Create! ');
                    }
                  },
                  child: const Text('Create')),
            ],
          );
        });
  }

  groupList() {
    return StreamBuilder(
        stream: group,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data['groups'].length,
                    itemBuilder: (context, index) {
                      int reverse = snapshot.data['groups'].length - index - 1;
                      return GroupTile(
                        userName: snapshot.data['fullName'],
                        groupId: getId(snapshot.data['groups'][reverse]),
                        groupName: getName(snapshot.data['groups'][reverse]),
                      );
                    });
              } else {
                return noGroupWidget();
              }
            } else {
              return noGroupWidget();
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.grey,
                  size: 55,
                )),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'you have not join any group, tap on the add icon to creat a group or also search from top search button',
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
