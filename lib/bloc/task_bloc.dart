import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_event.dart';
import 'task_state.dart';
import '../repositories/task_repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  int currentPage = 0;
  static const int _limit = 10;
  bool _isLoading = false;

  TaskBloc({required this.taskRepository}) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<LoadMoreTasks>(_onLoadMoreTasks);
  }

  void _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await taskRepository.fetchTasks(event.limit, event.skip);
      currentPage = 1;
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void _onLoadMoreTasks(LoadMoreTasks event, Emitter<TaskState> emit) async {
    if (_isLoading) return;
    _isLoading = true;
    final currentState = state;
    if (currentState is TaskLoaded) {
      emit(TaskLoaded(currentState.tasks, isLoadingMore: true));
      try {
        final tasks = await taskRepository.fetchTasks(event.limit, event.skip);
        currentPage++;
        emit(TaskLoaded(currentState.tasks + tasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      } finally {
        _isLoading = false;
      }
    }
  }

  void _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.addTask(event.task);
      add(LoadTasks());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.updateTask(event.task);
      add(LoadTasks());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.deleteTask(event.id);
      add(LoadTasks());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
