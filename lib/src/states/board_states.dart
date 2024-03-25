import 'package:masterclass_tests/src/models/task.dart';

sealed class BoardState {}

class LoadingBoardState implements BoardState {}

class GettedTaskBoardState implements BoardState {
  final List<Task> tasks;

  GettedTaskBoardState(this.tasks);
}

class EmptyBoardState extends GettedTaskBoardState {
  EmptyBoardState() : super([]);
}

class FailureBoardState implements BoardState {
  final String message;

  FailureBoardState(this.message);
}
