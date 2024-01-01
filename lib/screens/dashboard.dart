import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it_done/bloc/todo_bloc.dart';
import 'package:get_it_done/modal/todoModal.dart';
import 'package:get_it_done/screens/search_todo_screen.dart';
import 'package:get_it_done/utils/constants.dart';
import 'package:get_it_done/utils/customLogs.dart';
import 'package:get_it_done/utils/data.dart';
import 'package:get_it_done/widgets/add_task_bottomSheet.dart';
import 'package:get_it_done/widgets/todo_list_widget.dart';


class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final TodoBloc todoBloc = TodoBloc();
  TextEditingController? titleController = TextEditingController();

  TextEditingController? descriptionController = TextEditingController();

  int selectedIndex = 0;

  DateTime? dateTime;
  String? selectedDate;

  List<TodoModal> listOfTodo = [];
  List<TodoModal> listOfSortedTodo = [];
  List<TodoModal> listOfFilterTodo = [];

  bool? isSearchEnable = false;

  List<DateTime> tabDates = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 1)),
    DateTime.now(),
  ];

  @override
  void initState() {

    todoBloc.add(OnInitialTodoList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      bloc: todoBloc,
      listener: (context, state) {

        if (state is TodoLoadingState) {
          customLogs("Loading");
        } else if (state is TodoSuccessState) {
          customLogs("Success State");
          listOfTodo = state.list;
          listOfSortedTodo = getFilteredTodos(selectedIndex);
          customLogs(listOfSortedTodo.length);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              AppConstants.APP_NAME,
              style: TextStyle(
                  fontFamily: "Nexa", fontSize: 24, color: Colors.black),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SearchTodoList(todoBloc: todoBloc),
                      ));
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.13,
                height: MediaQuery.of(context).size.height,
                // color: Colors.transparent,
                child: NavigationRail(
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: Colors.transparent,
                  selectedLabelTextStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  unselectedLabelTextStyle: const TextStyle(
                    color: Colors.black38,
                  ),
                  selectedIconTheme: const IconThemeData(
                    color: Colors.black,
                  ),
                  unselectedIconTheme:
                      const IconThemeData(color: Colors.black38),
                  destinations: List.generate(
                    listOfTabs.length,
                    (index) => NavigationRailDestination(
                      icon: IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => GlobalModalBottomSheet(
                                todoBloc: todoBloc,
                                date: tabDates[index],
                              ),
                            );

                            customLogs("pressed on plus $index");
                          }),
                      label: Center(
                        child: RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              listOfTabs[index],
                            )),
                      ),
                    ),
                  ),
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                      todoBloc.add(OnUpdateTodoList());
                    });

                    customLogs(selectedIndex);
                  },
                  selectedIndex: selectedIndex,
                ),
              ),
              ToDoListWidget(listOfTodo: listOfSortedTodo, todoBloc: todoBloc)
            ],
          ),
        );
      },
    );
  }

  List<TodoModal> getFilteredTodos(int selectedTabIndex) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    switch (selectedTabIndex) {
      case 0:
        return listOfTodo.where((todo) {
          if (todo.date != null) {
            DateTime todoDate = DateTime.parse(todo.date.toString());
            return isSameDay(todoDate, today);
          }
          return false;
        }).toList();
      case 1:
        return listOfTodo.where((todo) {
          if (todo.date != null) {
            DateTime todoDate = DateTime.parse(todo.date.toString());
            return isSameDay(todoDate, tomorrow);
          }
          return false;
        }).toList();
      case 2:
        return listOfTodo.where((todo) {
          if (todo.date != null) {
            DateTime todoDate = DateTime.parse(todo.date.toString());
            return !isSameDay(todoDate, today) &&
                !isSameDay(todoDate, tomorrow);
          }
          return false;
        }).toList();
      default:
        return [];
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // List<TodoModal> getFilteredTodos(int selectedTabIndex) {
  //   final today = DateTime.now();
  //   final tomorrow = today.add(const Duration(days: 1));

  //   switch (selectedTabIndex) {
  //     case 0:
  //       return listOfTodo.where((todo) {
  //         return todo.date!.year == today.year &&
  //             todo.date!.month == today.month &&
  //             todo.date!.day == today.day;
  //       }).toList();
  //     case 1:
  //       return listOfTodo.where((todo) {
  //         return todo.date!.year == tomorrow.year &&
  //             todo.date!.month == tomorrow.month &&
  //             todo.date!.day == tomorrow.day;
  //       }).toList();
  //     case 2:
  //       return listOfTodo.where((todo) {
  //         return todo.date!.day != today.day && todo.date!.day != tomorrow.day;
  //       }).toList();
  //     default:
  //       return [];
  //   }
  // }
}
