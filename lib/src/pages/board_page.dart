import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterclass_tests/src/cubits/board_cubit.dart';
import 'package:masterclass_tests/src/models/task.dart';
import 'package:masterclass_tests/src/states/board_states.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  BoardPageState createState() => BoardPageState();
}

class BoardPageState extends State<BoardPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // É adicionado depois que a tela for contruída
      context.read<BoardCubit>().fetchTasks();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<BoardCubit>();

    final state = cubit.state;

    Widget body = Container();

    if (state is EmptyBoardState) {
      body = Center(
        key: const Key('EmptyState'),
        child: Text(
          'Adicionar uma nova task',
          style: const TextTheme().bodyMedium,
        ),
      );
    } else if (state is GettedTaskBoardState) {
      final tasks = state.tasks;

      body = ListView.builder(
        key: const Key('GettedState'),
        itemCount: tasks.length,
        itemBuilder: (_, index) {
          final task = tasks[index];
          return GestureDetector(
            onLongPress: () {
              cubit.removeTask(task);
            },
            child: CheckboxListTile(
              value: task.check,
              title: Text(task.description),
              onChanged: (value) {
                cubit.checkTask(task);
              },
            ),
          );
        },
      );
    } else if (state is FailureBoardState) {
      body = Center(
        key: const Key('FailureState'),
        child: Text(
          'Erro ao buscar as tasks',
          style: const TextTheme().bodyMedium,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTaskDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void addTaskDialog() {
    var description = '';
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            child: AlertDialog.adaptive(
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Sair'),
                ),
                TextButton(
                  onPressed: () {
                    print('entrou aqui');
                    final task = Task(id: -1, description: description);
                    context.read<BoardCubit>().addTask(task);
                    Navigator.pop(context);
                  },
                  child: const Text('Criar'),
                ),
              ],
              title: const Text('Adicionar uma task'),
              content: TextField(
                onChanged: (value) => description = value,
              ),
            ),
          );
        });
  }
}
