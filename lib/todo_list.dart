import 'package:flutter/material.dart';
import 'package:pretest_md_pai/loading.dart';
import 'package:pretest_md_pai/models/todo.dart';
import 'package:pretest_md_pai/services/database_services.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool isComplete = false;
  TextEditingController todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Todo>>(
            stream: DatabaseServices().listTodos(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              }
              List<Todo>? todos = snapshot.data;

              return Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Todos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.grey[600],
                    ),
                    SizedBox(height: 10),
                    todos!.length != 0
                        ? ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                              color: Colors.grey[800],
                            ),
                            shrinkWrap: true,
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: Key(todos[index].title ?? ''),
                                background: Container(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                                onDismissed: (direction) async {
                                  await DatabaseServices()
                                      .removeTodo(todos[index].uid);
                                },
                                child: ListTile(
                                  onTap: () {
                                    if (todos[index].isComplete == false) {
                                      DatabaseServices()
                                          .completeTask(todos[index].uid);
                                    } else {
                                      DatabaseServices()
                                          .uncompleteTask(todos[index].uid);
                                    }
                                  },
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => SimpleDialog(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 25,
                                          vertical: 20,
                                        ),
                                        backgroundColor: Colors.grey[800],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        title: Row(
                                          children: [
                                            Text(
                                              'Ubah Todo',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Spacer(),
                                            IconButton(
                                              icon: Icon(
                                                Icons.cancel,
                                                color: Colors.grey,
                                                size: 30,
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                        children: [
                                          Divider(),
                                          TextFormField(
                                            controller: todoController,
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            style: TextStyle(
                                              fontSize: 18,
                                              height: 1.5,
                                              color: Colors.white,
                                            ),
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              hintText: 'contoh: Latihan',
                                              hintStyle: TextStyle(
                                                color: Colors.white70,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 40,
                                            child: MaterialButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text('Ubah'),
                                              color: Colors.teal,
                                              textColor: Colors.white,
                                              elevation: 0,
                                              onPressed: () async {
                                                if (todoController
                                                    .text.isNotEmpty) {
                                                  await DatabaseServices()
                                                      .editTodo(
                                                          todos[index].uid,
                                                          todoController.text
                                                              .trim());
                                                  setState(() {
                                                    todoController.clear();
                                                  });
                                                  Navigator.pop(context);
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    );
                                  },
                                  leading: Container(
                                    height: 25,
                                    width: 25,
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: todos[index].isComplete == false
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                    child: todos[index].isComplete == true
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 18,
                                          )
                                        : Container(),
                                  ),
                                  title: Text(
                                    todos[index].title ?? '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: todos[index].isComplete == false
                                          ? Colors.grey[200]
                                          : Colors.grey,
                                      decoration:
                                          todos[index].isComplete == true
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Tidak Ada Todos',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              backgroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Text(
                    'Tambah Todo',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              children: [
                Divider(),
                TextFormField(
                  controller: todoController,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: Colors.white,
                  ),
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'contoh: Latihan',
                    hintStyle: TextStyle(
                      color: Colors.white70,
                    ),
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Tambah'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    elevation: 0,
                    onPressed: () async {
                      if (todoController.text.isNotEmpty) {
                        await DatabaseServices()
                            .createNewTodo(todoController.text.trim());
                        setState(() {
                          todoController.clear();
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
