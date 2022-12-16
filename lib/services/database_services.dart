import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pretest_md_pai/models/todo.dart';

class DatabaseServices {
  CollectionReference todosCollection =
      FirebaseFirestore.instance.collection('Todos');

  Future createNewTodo(String title) async {
    return await todosCollection.add({
      'title': title,
      'isComplete': false,
    });
  }

  Future editTodo(uid, title) async {
    return await todosCollection.doc(uid).update({
      'title': title,
    });
  }

  Future completeTask(uid) async {
    return await todosCollection.doc(uid).update({
      'isComplete': true,
    });
  }

  Future uncompleteTask(uid) async {
    return await todosCollection.doc(uid).update({
      'isComplete': false,
    });
  }

  Future removeTodo(uid) async {
    await todosCollection.doc(uid).delete();
  }

  List<Todo> todoFromFirestore(QuerySnapshot snapshot) {
    if (snapshot != []) {
      return snapshot.docs.map((e) {
        return Todo(
          uid: e.id,
          title: (e.data() as dynamic)['title'],
          isComplete: (e.data() as dynamic)['isComplete'],
        );
      }).toList();
    } else {
      return [];
    }
  }

  Stream<List<Todo>> listTodos() {
    return todosCollection.snapshots().map(todoFromFirestore);
  }
}
