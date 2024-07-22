import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/services/database.dart';
import 'package:todos/shared/constant.dart';

class Todos extends StatefulWidget {
  String? todos;
  String? detail;
  String? mode;
  String? docid;
  bool? is_complete;

  Todos(
      {super.key,
      this.todos,
      this.detail,
      this.is_complete,
      this.mode,
      this.docid});

  @override
  State<Todos> createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  String? Todos;
  String? detail;
  String? mode;
  String? docid;
  bool? is_complete = false;

  @override
  void initState() {
    Todos = widget.todos ?? "";
    detail = widget.detail ?? "";
    mode = widget.mode ?? "create";
    docid = widget.docid ?? "";
    is_complete = widget.is_complete ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: DraggableScrollableSheet(
        initialChildSize: 1,
        minChildSize: 0.95,
        builder: (context, scrollController) => SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: mode == "edit"
                        ? IconButton(
                            onPressed: () {
                              DatabaseService()
                                  .removeuserdata(ID: docid.toString());
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.delete))
                        : Container()),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: Todos,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Task'),
                        validator: ((value) =>
                            value!.isEmpty ? 'Enter Todos list' : null),
                        onChanged: ((value) {
                          setState(() => Todos = value);
                        }),
                      ),
                    ),
                    Checkbox(
                        value: is_complete,
                        onChanged: (value) => setState(() {
                              is_complete = value;
                            })),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  maxLines: 5,
                  initialValue: detail,
                  decoration: textInputDecoration.copyWith(hintText: 'detail'),
                  validator: ((value) =>
                      value!.isEmpty ? 'Enter Todos detail' : null),
                  onChanged: ((value) {
                    setState(() => detail = value);
                  }),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (mode == "edit") {
                      DatabaseService().updateUserData(
                          is_complete: is_complete,
                          detail: detail.toString(),
                          task: Todos.toString(),
                          docid: docid.toString());
                    } else {
                      DatabaseService().createUserData(
                        is_complete: is_complete,
                        detail: detail.toString(),
                        task: Todos.toString(),
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: Text(mode == "edit" ? "update" : "add"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
