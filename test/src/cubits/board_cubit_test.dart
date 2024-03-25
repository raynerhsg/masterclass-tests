import 'package:flutter_test/flutter_test.dart';
import 'package:masterclass_tests/src/cubits/board_cubit.dart';
import 'package:masterclass_tests/src/models/task.dart';
import 'package:masterclass_tests/src/repositories/board_repository.dart';
import 'package:masterclass_tests/src/states/board_states.dart';
import 'package:mocktail/mocktail.dart';

class MockBoardRepository extends Mock implements BoardRepository {}

void main() {
  late MockBoardRepository repository = MockBoardRepository();
  late BoardCubit cubit = BoardCubit(repository);

  setUp(() {
    repository = MockBoardRepository();
    cubit = BoardCubit(repository);
  });

  group('fetchTasks | ', () {
    test(
      'Deve pegar todas as tasks',
      () async {
        //Arrange

        when(() => repository.fetch()).thenAnswer(
          (_) async => [
            const Task(id: 1, description: 'description', check: true),
          ],
        );

        expect(
          cubit.stream,
          emitsInOrder([
            isA<LoadingBoardState>(),
            isA<GettedTaskBoardState>(),
          ]),
        );
        //Act
        await cubit.fetchTasks();

        //Assert
      },
    );

    test(
      'Deve retornar um estado de error ao falhar',
      () async {
        //Arrange
        when(() => repository.fetch()).thenThrow(Exception('Error'));
        //Act

        expect(
          cubit.stream,
          emitsInOrder(
            [
              isA<LoadingBoardState>(),
              isA<FailureBoardState>(),
            ],
          ),
        );

        //Assert

        await cubit.fetchTasks();
      },
    );
  });

  group('addTask | ', () {
    const task = Task(id: 1, description: 'description', check: true);

    test(
      'Deve adicioanr uma task',
      () async {
        //Arrange

        when(() => repository.update(any())).thenAnswer((_) async => []);

        expect(
          cubit.stream,
          emitsInOrder([
            isA<GettedTaskBoardState>(),
          ]),
        );
        //Act
        await cubit.addTask(task);
        //Assert
        final state = cubit.state as GettedTaskBoardState;
        expect(state.tasks.length, 1);
        expect(state.tasks, [task]);
      },
    );

    test(
      'Deve retornar um estado de error ao falhar',
      () async {
        //Arrange
        when(() => repository.update(any())).thenThrow(Exception('Error'));
        //Act

        expect(
          cubit.stream,
          emitsInOrder(
            [
              isA<FailureBoardState>(),
            ],
          ),
        );

        //Assert

        await cubit.addTask(task);
      },
    );
  });

  group('removeTask | ', () {
    const task = Task(id: 1, description: 'description', check: true);

    test(
      'Deve remove uma task',
      () async {
        //Arrange

        when(() => repository.update(any())).thenAnswer((_) async => []);

        cubit.addTasks([task]);
        expect((cubit.state as GettedTaskBoardState).tasks.length, 1);

        expect(
          cubit.stream,
          emitsInOrder([
            isA<GettedTaskBoardState>(),
          ]),
        );

        //Act
        await cubit.removeTask(task);
        //Assert
        final state = cubit.state as GettedTaskBoardState;
        expect(state.tasks.length, 0);
      },
    );

    test(
      'Deve retornar um estado de error ao falhar',
      () async {
        //Arrange
        when(() => repository.update(any())).thenThrow(Exception('Error'));

        cubit.addTasks([task]);
        //Act

        expect(
          cubit.stream,
          emitsInOrder(
            [
              isA<FailureBoardState>(),
            ],
          ),
        );

        //Assert

        await cubit.removeTask(task);
      },
    );
  });

  group('checkTask | ', () {
    const task = Task(id: 1, description: 'description');

    test(
      'Deve checkar uma task',
      () async {
        //Arrange

        when(() => repository.update(any())).thenAnswer((_) async => []);

        cubit.addTasks([task]);
        expect((cubit.state as GettedTaskBoardState).tasks.length, 1);
        expect((cubit.state as GettedTaskBoardState).tasks.first.check, false);

        expect(
          cubit.stream,
          emitsInOrder([
            isA<GettedTaskBoardState>(),
          ]),
        );

        //Act
        await cubit.checkTask(task);
        //Assert
        final state = cubit.state as GettedTaskBoardState;
        expect(state.tasks.length, 1);
        expect(state.tasks.first.check, true);
      },
    );

    test(
      'Deve retornar um estado de error ao falhar',
      () async {
        //Arrange
        when(() => repository.update(any())).thenThrow(Exception('Error'));

        cubit.addTasks([task]);
        //Act

        expect(
          cubit.stream,
          emitsInOrder(
            [
              isA<FailureBoardState>(),
            ],
          ),
        );

        //Assert

        await cubit.checkTask(task);
      },
    );
  });
}
