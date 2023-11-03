part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

class OnInitialTodoList extends TodoEvent {
  final List<TodoModal>? list;
  OnInitialTodoList({this.list});
}

class OnUpdateTodoList extends TodoEvent {
  final List<TodoModal>? list;
  OnUpdateTodoList({this.list});
}

class DeleteTodoEvent extends TodoEvent {
  final String? title;
  DeleteTodoEvent({this.title});
}

class OnEditTodoList extends TodoEvent {
  final TodoModal? todo;
  final String? title;
  OnEditTodoList( {this.title, this.todo});
}
