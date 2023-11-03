import 'package:flutter/material.dart';
import 'package:get_it_done/bloc/todo_bloc.dart';
import 'package:get_it_done/modal/todoModal.dart';

import 'task_tile_widget.dart';

class ToDoListWidget extends StatefulWidget {
  final List<TodoModal> listOfTodo;
  final TodoBloc todoBloc;
  const ToDoListWidget(
      {super.key, required this.listOfTodo, required this.todoBloc});

  @override
  State<ToDoListWidget> createState() => _ToDoListWidgetState();
}

class _ToDoListWidgetState extends State<ToDoListWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width * 0.8,
      // color: Colors.black12,
      child: widget.listOfTodo.isNotEmpty
          ? ListView.builder(
              itemCount: widget.listOfTodo.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => TaskTile(
                todoModal: widget.listOfTodo[index],
                todoBloc: widget.todoBloc,
              ),
            )
          : const Center(
              child: Text("Add Some Todo Clicking on + icon"),
            ),
    );
  }
}
