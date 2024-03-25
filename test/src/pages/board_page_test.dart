import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterclass_tests/src/cubits/board_cubit.dart';
import 'package:masterclass_tests/src/pages/board_page.dart';
import 'package:masterclass_tests/src/repositories/board_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockBoardRepository extends Mock implements BoardRepository {}

void main() {
  late MockBoardRepository mockRepository;
  late BoardCubit cubit;

  setUp(() {
    mockRepository = MockBoardRepository();
    cubit = BoardCubit(mockRepository);
  });

  testWidgets('board page with all tasks', (tester) async {
    when(() => mockRepository.fetch()).thenAnswer((invocation) async => []);

    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: const MaterialApp(home: BoardPage()),
      ),
    );

    expect(find.byKey(const Key('EmptyState')), findsOneWidget);
    await tester.pump(Durations.extralong4);
    expect(find.byKey(const Key('GettedState')), findsOneWidget);
  });

  testWidgets('board page with failure state', (tester) async {
    when(() => mockRepository.fetch()).thenThrow(Exception('Error'));

    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: const MaterialApp(home: BoardPage()),
      ),
    );

    expect(find.byKey(const Key('EmptyState')), findsOneWidget);
    await tester.pump(Durations.extralong4);
    expect(find.byKey(const Key('FailureState')), findsOneWidget);
  });
}
