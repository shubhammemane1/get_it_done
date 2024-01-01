import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it_done/bloc/todo_bloc.dart';
import 'package:get_it_done/modal/todoModal.dart';
import 'package:get_it_done/widgets/text_field_with_header.dart';
import 'package:intl/intl.dart';

import '../utils/commonFunctions.dart';
import '../utils/customLogs.dart';

class EditTaskDialoug extends StatefulWidget {
  final TodoModal? todoModal;
  final TodoBloc? todoBloc;
  const EditTaskDialoug({super.key, this.todoModal, this.todoBloc});

  @override
  State<EditTaskDialoug> createState() => _EditTaskDialougState();
}

class _EditTaskDialougState extends State<EditTaskDialoug> {
  DateTime? dateTime;
  String? selectedDate;
  String? currentTitle;
  TextEditingController? titleEditingController;
  TextEditingController? descriptionEditingController;
  bool? isComplete = false;

  bool? isPressed = false;
  @override
  void initState() {

    currentTitle = widget.todoModal!.title;

    titleEditingController =
        TextEditingController(text: widget.todoModal!.title);
    descriptionEditingController =
        TextEditingController(text: widget.todoModal!.description);

    selectedDate = DateFormat('yyyy-MM-dd').format(widget.todoModal!.date!);
    isComplete = widget.todoModal!.isDone == "true" ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      bloc: widget.todoBloc,
      listener: (context, state) {
      },
      builder: (context, state) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFieldWithHeader(
                  header: "Title",
                  controller: titleEditingController,
                ),
                TextFieldWithHeader(
                  header: "Description",
                  controller: descriptionEditingController,
                ),
                TextButton(
                  onPressed: () async {
                    final newDateTime =
                        await selectDate(context, widget.todoModal!.date!);
                    if (newDateTime != null) {
                      dateTime = newDateTime;
                      selectedDate = DateFormat('yyyy-MM-dd').format(dateTime!);
                      setState(() {});
                    }
                  },
                  child: Text(
                    selectedDate != null
                        ? 'Selected Date: $selectedDate'
                        : 'Select Date',
                  ),
                ),
                isPressed!
                    ? (titleEditingController!.text.isEmpty ||
                            descriptionEditingController!.text.isEmpty)
                        ? const Text("Please Fill Data " , style:  TextStyle(color: Colors.red),)
                        : Container()
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("is Todo Completed :"),
                    CupertinoSwitch(
                      value: isComplete!,
                      onChanged: (value) {
                        setState(() {
                          isComplete = !isComplete!;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                customLogs(
                    "$selectedDate ${titleEditingController!.text} ${descriptionEditingController!.text}");
                // Handle saving the task here
                // You can call a method or trigger an event to save the task
                if (titleEditingController!.text.isNotEmpty &&
                    descriptionEditingController!.text.isNotEmpty) {
                  TodoModal todo = TodoModal(
                      id: DateTime.now().toString(),
                      title: titleEditingController!.text,
                      description: descriptionEditingController!.text,
                      date: DateTime.tryParse(selectedDate!),
                      isDone: isComplete.toString());

                  widget.todoBloc!
                      .add(OnEditTodoList(title: currentTitle, todo: todo));
                  Navigator.of(context).pop();
                } else {
                  isPressed = true;
                  setState(() {
                    
                  });
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
