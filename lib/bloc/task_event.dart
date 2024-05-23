import 'package:equatable/equatable.dart';
import '../models/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {
  final int limit;
  final int skip;

  const LoadTasks({this.limit = 10, this.skip = 0});
}

class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);
}

class UpdateTask extends TaskEvent {
  final Task task;

  const UpdateTask(this.task);
}

class DeleteTask extends TaskEvent {
  final int id;

  const DeleteTask(this.id);
}

class LoadMoreTasks extends TaskEvent {
  final int limit;
  final int skip;

  const LoadMoreTasks({this.limit = 10, this.skip = 0});
}
