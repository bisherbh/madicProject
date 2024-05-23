import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'repositories/auth_repository.dart';
import 'services/auth_service.dart';
import 'bloc/auth_bloc.dart';
import 'repositories/task_repository.dart';
import 'services/api_service.dart';
import 'bloc/task_bloc.dart';
import 'pages/login_page.dart';
import 'pages/task_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository(authService: AuthService());
    final apiService = ApiService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepository)..add(AuthCheckStatus()),
        ),
        BlocProvider(
          create: (context) => TaskBloc(
            taskRepository: TaskRepository(
              apiService: apiService,
              authRepository: authRepository,
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        routes: {
          '/login': (context) => LoginPage(),
          '/tasks': (context) => TaskListPage(),
        },
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return TaskListPage();
            } else {
              return LoginPage();
            }
          },
        ),
      ),
    );
  }
}
