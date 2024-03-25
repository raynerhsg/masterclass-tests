// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:masterclass_tests/src/models/task.dart';
import 'package:masterclass_tests/src/repositories/board_repository.dart';
import 'package:masterclass_tests/src/states/board_states.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepository repository;

  BoardCubit(
    this.repository,
  ) : super(EmptyBoardState());

  Future<void> fetchTasks() async {
    try {
      emit(LoadingBoardState());
      final tasks = await repository.fetch();
      emit(GettedTaskBoardState(tasks));
    } catch (e) {
      emit(FailureBoardState('Error'));
    }
  }

  Future<void> addTask(Task newTask) async {
    final tasks = _getTasks();

    if (tasks == null) return;
    tasks.add(newTask);

    await emitTasks(tasks);
  }

  Future<void> removeTask(Task newTask) async {
    final tasks = _getTasks();

    if (tasks == null) return;
    tasks.remove(newTask);

    await emitTasks(tasks);
  }

  Future<void> checkTask(Task newTask) async {
    final tasks = _getTasks();

    if (tasks == null) return;
    final index = tasks.indexOf(newTask);
    tasks[index] = newTask.copyWith(check: !newTask.check);

    await emitTasks(tasks);
  }

  @visibleForTesting
  void addTasks(List<Task> tasks) {
    emit(GettedTaskBoardState(tasks));
  }

  List<Task>? _getTasks() {
    final state = this.state;
    if (state is! GettedTaskBoardState) {
      return null;
    }

    return state.tasks.toList();
  }

  Future<void> emitTasks(List<Task> tasks) async {
    try {
      await repository.update(tasks);
      emit(GettedTaskBoardState(tasks));
    } catch (e) {
      emit(FailureBoardState('Error'));
    }
  }
}
