import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../models/task.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<TaskBloc>().add(LoadTasks());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      context.read<TaskBloc>().add(LoadMoreTasks(skip: context.read<TaskBloc>().currentPage * 10));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Manager',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading && state is! TaskLoaded) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.0),
              itemCount: state.tasks.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.tasks.length) {
                  return Center(child: CircularProgressIndicator());
                }
                final task = state.tasks[index];
                return TaskCard(task: task);
              },
            );
          } else if (state is TaskError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('No tasks available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddTaskDialog();
            },
          );
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;

  TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(
          task.todo!,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        trailing: Checkbox(
          value: task.completed,
          onChanged: (bool? value) {
            context.read<TaskBloc>().add(UpdateTask(
              Task(
                id: task.id,
                todo: task.todo,
                completed: value ?? false,
              ),
            ));
          },
        ),
        onLongPress: () {
          context.read<TaskBloc>().add(DeleteTask(task.id!));
        },
      ),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        'Add Task',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Task Title',
            labelStyle: GoogleFonts.poppins(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a task title';
            }
            return null;
          },
          onSaved: (value) {
            _title = value!;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              context.read<TaskBloc>().add(AddTask(Task(id: 0, todo: _title, completed: false)));
              Navigator.of(context).pop();
            }
          },
          child: Text(
            'Add',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ),
      ],
    );
  }
}
