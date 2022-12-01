import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final String? uid;

  DatabaseServices({this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference groupcolection =
      FirebaseFirestore.instance.collection('groups  ');

  //Saving the user data
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  //getting the data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).get();
    return snapshot;
  }

  //get user data
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  //creating a group

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentRefrence = await groupcolection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': "${id}_$userName",
      "members": [],
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': '',
    });
//Update MEmeber
    await groupDocumentRefrence.update({
      'member': FieldValue.arrayUnion(['${uid}_$userName']),
      'groupId': groupDocumentRefrence.id,
    });

    DocumentReference userDocumentRefrence = userCollection.doc(uid);
    return await userDocumentRefrence.update({
      'groups':
          FieldValue.arrayUnion(['${groupDocumentRefrence.id}_$groupName'])
    });
  }

  getChat(String groupId) async {
    return groupcolection
        .doc(groupId)
        .collection("messages")
        .orderBy('time')
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference documentReference = groupcolection.doc(groupId);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot['admin'];
  }

  getGroupMember(groupId) async {
    return groupcolection.doc(groupId).snapshots();
  }

  searchByName(String groupName) async {
    return groupcolection.where("groupName", isEqualTo: groupName).get();
  }

  // function -> bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupcolection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  sendMessage(String groupId, Map<String, dynamic> chatMessageData) {
    groupcolection.doc(groupId).collection("messages").add(chatMessageData);
    groupcolection.doc(groupId).update({
      'recentMessage':chatMessageData['message'],
      'recentMessageSender':chatMessageData['sender'],
      "recentMessageTime":chatMessageData['time'].toString(),

    });
  }
}
