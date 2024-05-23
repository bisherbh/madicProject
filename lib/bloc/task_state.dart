import 'package:equatable/equatable.dart';
import '../models/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final bool isLoadingMore;

  const TaskLoaded(this.tasks, {this.isLoadingMore = false});

  @override
  List<Object> get props => [tasks, isLoadingMore];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}
