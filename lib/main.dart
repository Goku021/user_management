import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management/api_service.dart';
import 'package:user_management/user_bloc.dart';
import 'package:user_management/user_event.dart';
import 'package:user_management/user_list_screen.dart';
import 'package:user_management/user_repository.dart';
import 'package:user_management/detail_repository.dart';

void main() {
  final apiService = ApiService();
  final userRepository = UserRepository(apiService);
  final detailRepository = DetailRepository(apiService);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>.value(value: userRepository),
        RepositoryProvider<DetailRepository>.value(value: detailRepository),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get userRepository from context
    final userRepository = RepositoryProvider.of<UserRepository>(context);

    return MaterialApp(
      title: 'User Manager',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: BlocProvider(
        create: (_) => UserBloc(userRepository)..add(FetchUsersEvent()),
        child: const UserListScreen(),
      ),
    );
  }
}
