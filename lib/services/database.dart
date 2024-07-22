import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:todos/models/todos.dart';
import 'package:todos/shared/state.dart';

class DatabaseService {
  final String? uid;
  final UserController c = Get.put(UserController());
  DatabaseService({this.uid});
  // collection reference
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('todos');

  Future createUserData(
      {required String task,
      required String detail,
      required bool? is_complete}) async {
    final UserController c = Get.put(UserController());
    return await notesCollection.doc(uid).set({
      'task': task,
      'detail': detail,
      'is_complete': is_complete,
      'userid': c.user.value!.uid.toString(),
    });
  }

  Future updateUserData(
      {required String task,
      required String detail,
      required bool? is_complete,
      required String docid}) async {
    final UserController c = Get.put(UserController());
    return await notesCollection.doc(docid).set({
      'task': task,
      'detail': detail,
      'is_complete': is_complete,
      'userid': c.user.value!.uid.toString(),
    });
  }

  Future removeuserdata({required String ID}) async {
    return await notesCollection.doc(ID).delete();
  }

  // notes list from snapshot
  List<Todos> _todosListFromSnapshot(QuerySnapshot? snapshot) {
    return snapshot!.docs.map((doc) {
      log(doc.toString());
      return Todos(
        docid: doc.id,
        detail: doc.get('detail'),
        is_complete: doc.get('is_complete') ?? false,
        task: doc.get('task') ?? 'no task',
        userid: doc.get('userid') ?? 'no userid',
      );
    }).toList();
  }

  // get notes stream
  Stream<List<Todos>> get notes {
    return notesCollection
        .where("userid", isEqualTo: "${c.user.value!.uid}")
        .snapshots()
        .map(_todosListFromSnapshot);
  }
}
