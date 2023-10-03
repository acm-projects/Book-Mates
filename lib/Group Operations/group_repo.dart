import 'package:bookmates_app/Group%20Operations/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//this class manages CRUD operations in firestore for the collection 'groups'

class GroupRepo {
  static Stream<List<GroupModel>> read() {
    // lists out all the users in the document
    final userCollection = FirebaseFirestore.instance.collection("groups");
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => GroupModel.fromSnapshot(e)).toList());
  }

  static Future msgAdd(String subPath, userEmail) async {
    final db = FirebaseFirestore.instance;

    await db.collection(subPath).doc(userEmail).set({
      // creating the Messages subcollection in every group created
      // add the time sent as a  field
      "TimeCreated": DateTime.now(),
    });
  }

  static Future<String> getFirstDocID(String subPath) async {
    final db = FirebaseFirestore.instance;

    final first = db.collection(
        subPath); // grabbing the id of the first document, this will be the email of the first user, therefore, the one that created it
    final snap = await first.limit(1).get();
    final id = snap.docs.first.id;

    return id;
  }

  static Future memAdd(String subPath, userEmail, int admin) async {
    final db = FirebaseFirestore.instance;

    //final firstID = getFirstDocID(subPath);

    await db.collection(subPath).doc(userEmail).set({
      // creating the Members subcollection in every group created
      // creating a document within this subcollection listing out the emails
      "Member": userEmail,
      "isAdmin": admin == 1 ? true : false,
    });
  }

  static Future create(GroupModel user) async {
    // creates a user in firestore
    final userCollection = FirebaseFirestore.instance.collection('groups');

    final docPath = user
        .groupID; // the id of each document in firestore is the id that the user typed in

    final docRef = userCollection.doc(
        docPath); // refrence of the specific document we want to put data into

    final newUser = GroupModel(
      bookName: user.bookName,
      groupBio: user.groupBio,
      groupName: user.groupName,
      groupID: user.groupID,
    ).toJson();

    try {
      await docRef.set(newUser);
      // ignore: empty_catches
    } catch (e) {}
  }

  static Future update(GroupModel user) async {
    // updates firestore data

    final userCollection = FirebaseFirestore.instance.collection("groups");

    final docRef = userCollection
        .doc(user.groupID); // document refrence of the document wanted

    final newUser = GroupModel(
      // convert the userModel data into type Map<String, dynamic> (type of data in firestore)
      bookName: user.bookName,
      groupBio: user.groupBio,
      groupName: user.groupName,
      groupID: user.groupID,
    ).toJson();

    try {
      await docRef.update(newUser);
      // ignore: empty_catches
    } catch (e) {}
  }

  static Future subDelete(String subCollectPath) async {
    final db = FirebaseFirestore.instance;

    await db
        .collection(subCollectPath)
        .get()
        .then((snapshot) => // delets all documents in Messages subcollection
            // ignore: avoid_function_literals_in_foreach_calls
            snapshot.docs.forEach((docuemnt) async {
              await docuemnt.reference.delete();
            }));
  }

  static Future mainDelete(String docPath, String collectPath) async {
    await FirebaseFirestore.instance
        .collection(collectPath)
        .doc(docPath)
        .delete(); // then finally deletes the entire docuemnt in the group collection
  }
}
