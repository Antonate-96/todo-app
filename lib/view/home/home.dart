import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/services/auth.dart';
import 'package:todos/services/database.dart';
import 'package:todos/view/chat/chatroom.dart';
import 'package:todos/view/home/widget/bottomsheets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final Authservice _auth = Authservice();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Todos"),
        actions: [
          TextButton.icon(
            style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black)),
            icon: const Icon(Icons.person),
            label: Text('Chat With AI'),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chatroom(),
                  ));
            },
          ),
          TextButton.icon(
            style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black)),
            icon: const Icon(Icons.person),
            label: Text('log out'),
            onPressed: () async {
              await _auth.signout();
            },
          )
        ],
      ),
      body: Center(
        child: StreamBuilder(
          stream: DatabaseService().notes,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text("No Data");
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(snapshot.data![index].task.toString()),
                      onTap: () {
                        showModalBottomSheet(
                          showDragHandle: true,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext bc) {
                            return Todos(
                              todos: snapshot.data![index].task,
                              docid: snapshot.data![index].docid,
                              detail: snapshot.data![index].detail,
                              mode: "edit",
                              is_complete: snapshot.data![index].is_complete,
                            );
                          },
                        );
                      },
                      trailing:
                          Text(snapshot.data![index].is_complete.toString()),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          showDragHandle: true,
          isScrollControlled: true,
          scrollControlDisabledMaxHeightRatio: 0.8,
          context: context,
          builder: (BuildContext bc) {
            return Todos();
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
