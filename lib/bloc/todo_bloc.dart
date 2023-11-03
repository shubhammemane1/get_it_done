import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it_done/databaseHelper/localDatabase.dart';
import 'package:get_it_done/modal/todoModal.dart';
import 'package:meta/meta.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<OnInitialTodoList>(onInitialTodoList);
    on<DeleteTodoEvent>(deleteTodoEvent);
    on<OnUpdateTodoList>(onUpdateTodoList);
    on<OnEditTodoList>(onEditTodoList);
  }

  FutureOr<void> onInitialTodoList(
      OnInitialTodoList event, Emitter<TodoState> emit) async {
    emit(TodoLoadingState());
    List<TodoModal> list = [];
    list = await LocalDatabaseHelper().getAllTodos();
    emit(TodoSuccessState(list: list));
  }

  FutureOr<void> deleteTodoEvent(
      DeleteTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoadingState());
    await LocalDatabaseHelper().deleteTodoById(event.title!);
    List<TodoModal> list = [];
    list = await LocalDatabaseHelper().getAllTodos();
    emit(TodoSuccessState(list: list));
  }

  FutureOr<void> onUpdateTodoList(
      OnUpdateTodoList event, Emitter<TodoState> emit) async {
    emit(TodoLoadingState());
    List<TodoModal> list = [];
    list = await LocalDatabaseHelper().getAllTodos();
    emit(TodoSuccessState(list: list));
  }

  FutureOr<void> onEditTodoList(
      OnEditTodoList event, Emitter<TodoState> emit) async {
    emit(TodoLoadingState());
    List<TodoModal> list = [];
    await LocalDatabaseHelper().updateTodo(title : event.title,todo: event.todo);
    list = await LocalDatabaseHelper().getAllTodos();
    emit(TodoSuccessState(list: list));
  }
}
