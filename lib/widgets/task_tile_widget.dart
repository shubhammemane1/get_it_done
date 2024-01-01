import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it_done/bloc/todo_bloc.dart';
import 'package:get_it_done/modal/todoModal.dart';
import 'package:get_it_done/utils/appColors.dart';
import 'package:get_it_done/utils/constants.dart';
import 'package:get_it_done/widgets/edit_task_dialog.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final TodoModal? todoModal;
  final TodoBloc? todoBloc;
  const TaskTile({super.key, this.todoModal, this.todoBloc});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8),
        height: 100,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: todoModal!.isDone == "true"
                ? Colors.blue.withOpacity(0.8)
                : Colors.red.withOpacity(0.8),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            )),
        child: Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
              // color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.white, width: 2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    DateFormat("dd/MM/yyyy").format(todoModal!.date!),
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    todoModal!.title.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: "Nexa"),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      todoModal!.description.toString(),
                      style: const TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: "Nexa"),
                    ),
                  ),
                  Text(
                    todoModal!.isDone == "true" ? "Completed" : "Incomplete",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => EditTaskDialoug(
                            todoModal: todoModal,
                            todoBloc: todoBloc,
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                      )),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => dialog(context),
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                      )),
                ],
              ),
            ],
          ),
        ));
  }

  dialog(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      bloc: todoBloc,
      listener: (context, state) {
      },
      builder: (context, state) {
        return AlertDialog(
          title: const Text(AppConstants.ARE_YOU_CONFIRM_TO_DELETE),
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    AppConstants.NO,
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                )),
            GestureDetector(
                onTap: () {
                  todoBloc!.add(DeleteTodoEvent(title: todoModal!.title));
                  Navigator.pop(context);
                  todoBloc!.add(OnInitialTodoList());
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    AppConstants.YES,
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                )),
          ],
        );
      },
    );
  }
}
