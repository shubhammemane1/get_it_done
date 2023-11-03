import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it_done/bloc/todo_bloc.dart';

import '../modal/todoModal.dart';
import '../utils/constants.dart';
import '../utils/customLogs.dart';
import '../widgets/edit_task_dialog.dart';

class SearchTodoList extends StatefulWidget {
  final TodoBloc? todoBloc;
  const SearchTodoList({super.key, this.todoBloc});

  @override
  State<SearchTodoList> createState() => _SearchTodoListState();
}

class _SearchTodoListState extends State<SearchTodoList> {
  List<TodoModal> listOfTodo = [];
  List<TodoModal> listOfFilterTodo = [];

  @override
  void initState() {
    // TODO: implement initState

    widget.todoBloc!.add(OnInitialTodoList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      bloc: widget.todoBloc,
      listener: (context, state) {
        // TODO: implement listener

        if (state is TodoLoadingState) {
          customLogs("Loading");
        } else if (state is TodoSuccessState) {
          customLogs("Success State");
          listOfTodo = state.list;
          // listOfSortedTodo = getFilteredTodos(selectedIndex);
          // customLogs(listOfSortedTodo.length);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                )),
            title: const Text(
              AppConstants.APP_NAME,
              style: TextStyle(
                  fontFamily: "Nexa", fontSize: 24, color: Colors.black),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) {
                    listOfFilterTodo.clear();
                    for (var element in listOfTodo) {
                      if (element.title!.contains(value)) {
                        listOfFilterTodo.add(element);
                        customLogs(listOfFilterTodo.length);
                      }
                      setState(() {});
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Search Todos',
                    hintText: 'Enter a title or description',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: listOfFilterTodo.length,
                  itemBuilder: (context, index) {
                    TodoModal todo = listOfFilterTodo[index];
                    return ListTile(
                      title: Text(todo.title!),
                      subtitle: Text(todo.description!),
                      onTap: () {
                        customLogs('Tapped on: ${todo.title}');
                        showDialog(
                          context: context,
                          builder: (context) => EditTaskDialoug(
                            todoBloc: widget.todoBloc,
                            todoModal: todo,
                          ),
                        );
                        // Handle tap action here
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
