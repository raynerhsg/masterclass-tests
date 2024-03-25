import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterclass_tests/src/cubits/board_cubit.dart';
import 'package:masterclass_tests/src/pages/board_page.dart';
import 'package:masterclass_tests/src/repositories/board_repository.dart';
import 'package:masterclass_tests/src/repositories/isar/isar_board_repository.dart';
import 'package:masterclass_tests/src/repositories/isar/isar_datasouce.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider(create: (ctx) => IsarDataSouce()),
        RepositoryProvider<BoardRepository>(create: (ctx) => IsarBoardRepository(ctx.read())),
        BlocProvider(create: (ctx) => BoardCubit(ctx.read())),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const BoardPage(),
      ),
    );
  }
}
