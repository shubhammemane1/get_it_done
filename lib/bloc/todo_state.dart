part of 'todo_bloc.dart';

@immutable
sealed class TodoState {}

final class TodoInitial extends TodoState {}

final class TodoLoadingState extends TodoState {}

final class TodoSuccessState extends TodoState {
  final List<TodoModal> list;

  TodoSuccessState({required this.list});
  
}
