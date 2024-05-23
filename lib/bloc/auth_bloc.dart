import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../repositories/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;

  const AuthLoginRequested(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String username;

  const AuthAuthenticated(this.username);

  @override
  List<Object> get props => [username];
}

class AuthUnauthenticated extends AuthState {}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatus>(_onCheckStatus);
  }

  void _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
   
    emit(AuthLoading());
    try {
   
      await authRepository.login(event.username, event.password);
      emit(AuthAuthenticated(event.username));
    } catch (error) {
          print("object");
      emit(AuthUnauthenticated());
    }
  }

  void _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }

  void _onCheckStatus(AuthCheckStatus event, Emitter<AuthState> emit) async {
    final isLoggedIn = await authRepository.isLoggedIn();
    if (isLoggedIn) {
      emit(AuthAuthenticated(
          'username')); // Fetch the username from shared preferences
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
