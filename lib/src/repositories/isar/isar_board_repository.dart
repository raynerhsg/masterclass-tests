import 'package:masterclass_tests/src/models/task.dart';
import 'package:masterclass_tests/src/repositories/board_repository.dart';
import 'package:masterclass_tests/src/repositories/isar/isar_datasouce.dart';
import 'package:masterclass_tests/src/repositories/isar/task_model.dart';

class IsarBoardRepository implements BoardRepository {
  final IsarDataSouce dataSouce;
  IsarBoardRepository(this.dataSouce);

  @override
  Future<List<Task>> fetch() async {
    final models = await dataSouce.getTasks();
    return models.map((e) => Task(id: e.id, description: e.description, check: e.check)).toList();
  }

  @override
  Future<List<Task>> update(List<Task> tasks) async {
    final models = tasks.map((e) {
      final model = TaskModel()
        ..check = e.check
        ..description = e.description
        ..id = e.id;

      if (e.id != -1) {
        model.id = e.id;
      }
      return model;
    }).toList();

    await dataSouce.deleteAllTask();
    await dataSouce.putAllTasks(models);
    return tasks;
  }
}
