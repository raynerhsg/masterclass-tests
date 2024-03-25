import 'package:flutter_test/flutter_test.dart';
import 'package:masterclass_tests/src/models/task.dart';
import 'package:masterclass_tests/src/repositories/isar/isar_board_repository.dart';
import 'package:masterclass_tests/src/repositories/isar/isar_datasouce.dart';
import 'package:masterclass_tests/src/repositories/isar/task_model.dart';
import 'package:mocktail/mocktail.dart';

class MockIsarDataSouce extends Mock implements IsarDataSouce {}

void main() {
  late MockIsarDataSouce dataSouce;
  late IsarBoardRepository repository;

  setUp(() {
    dataSouce = MockIsarDataSouce();
    repository = IsarBoardRepository(dataSouce);
  });

  group('fetch |', () {
    test(
      'SHould return a list of Tasks when getTasks return a list of TaskModel',
      () async {
        //Arrange
        when(() => dataSouce.getTasks()).thenAnswer((invocation) async => [
              TaskModel()
                ..id = 1
                ..description = 'description'
                ..check = true
            ]);
        //Act
        final tasks = await repository.fetch();
        //Assert
        expect(tasks.length, 1);
      },
    );
  });

  group('update |', () {
    test(
      'SHould return a list of Tasks when getTasks return a list of TaskModel',
      () async {
        //Arrange
        when(() => dataSouce.deleteAllTask()).thenAnswer((invocation) async => []);
        when(() => dataSouce.putAllTasks(any())).thenAnswer((invocation) async => []);
        //Act
        final tasks = await repository.update([
          const Task(id: -1, description: 'description', check: true),
          const Task(id: 2, description: 'description', check: true),
        ]);
        //Assert
        expect(tasks.length, 2);
      },
    );
  });
}
