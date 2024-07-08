import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todos/models/todos.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});
  // collection reference
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

  Future updateUserData(String task, String name, String detail) async {
    return await notesCollection.doc(uid).set({
      'task': task,
      'name': name,
      'detail': detail,
    });
  }

  // notes list from snapshot
  List<Todos> _brewListFromSnapshot(QuerySnapshot? snapshot) {
    return snapshot!.docs.map((doc) {
      return Todos(
        name: doc.get('name') ?? '',
        task: doc.get('task') ?? 'no task',
        detail: doc.get('detail') ?? 'no deatail',
      );
    }).toList();
  }

  // get notes stream
  Stream<List<Todos>> get notes {
    return notesCollection.snapshots().map(_brewListFromSnapshot);
  }
}
