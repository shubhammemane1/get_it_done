import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it_done/bloc/todo_bloc.dart';
import 'package:intl/intl.dart';

import '../databaseHelper/localDatabase.dart';
import '../modal/todoModal.dart';
import '../utils/commonFunctions.dart';
import '../utils/constants.dart';
import '../utils/customLogs.dart';
import 'text_field_with_header.dart';

class GlobalModalBottomSheet extends StatefulWidget {
  final TodoBloc? todoBloc;
  final DateTime? date;
  const GlobalModalBottomSheet({
    super.key,
    this.todoBloc,
    this.date,
  });

  @override
  _GlobalModalBottomSheetState createState() => _GlobalModalBottomSheetState();
}

class _GlobalModalBottomSheetState extends State<GlobalModalBottomSheet> {
  DateTime? dateTime;
  String? selectedDate;
  String? currentTitle;

  bool? isPressed = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    selectedDate = DateFormat('yyyy-MM-dd').format(widget.date!.toLocal());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      bloc: widget.todoBloc,
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Container(
          margin: MediaQuery.of(context).viewInsets,
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              )),
          child: Column(
            children: [
              const Text(
                AppConstants.ADD_TASK,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextFieldWithHeader(
                header: "Title",
                controller: titleController,
              ),
              TextFieldWithHeader(
                header: "Description",
                controller: descriptionController,
              ),
              isPressed!
                  ? (titleController.text.isEmpty ||
                          descriptionController.text.isEmpty)
                      ? Text(
                          "Please Fill Data ",
                          style: TextStyle(color: Colors.red),
                        )
                      : Container()
                  : Container(),
              TextButton(
                onPressed: () async {
                  final newDateTime = await selectDate(context, widget.date!);
                  if (newDateTime != null) {
                    dateTime = newDateTime;
                    selectedDate = DateFormat('yyyy-MM-dd').format(dateTime!);
                  }
                  setState(() {});
                  customLogs(newDateTime);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selectedDate != null
                          ? 'Date : $selectedDate'
                          : 'Select Date',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.edit,
                      size: 20,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: FilledButton(
                  onPressed: () {
                    DateTime date = DateTime.parse(selectedDate!);
                    customLogs(
                        "$date ${titleController.text} ${descriptionController.text}");
                    if (titleController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty) {
                      TodoModal todo = TodoModal(
                        id: DateTime.now().toString(),
                        title: titleController.text.toString(),
                        description: descriptionController.text,
                        date: date,
                        isDone: "false",
                      );
                      LocalDatabaseHelper().insertTodo(todo);

                      widget.todoBloc!.add(OnUpdateTodoList());
                      customLogs("List is Updated");
                      Navigator.pop(context);
                    } else {
                      isPressed = true;
                      setState(() {});
                    }
                  },
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ToastWidget extends StatefulWidget {
  final String message;

  ToastWidget({required this.message});

  @override
  _ToastWidgetState createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget> {
  @override
  void initState() {
    super.initState();
    _showToast();
  }

  void _showToast() async {
    await Future.delayed(Duration(milliseconds: 100));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.message),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void showToast(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ToastWidget(message: message);
    },
  );
}
