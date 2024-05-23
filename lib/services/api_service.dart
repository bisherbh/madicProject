import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com';

  Future<List<Task>> fetchTasks(int limit, int skip, String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/todos?limit=$limit&skip=$skip'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print("${response.body}");
      List<dynamic> body = json.decode(response.body)['todos'];
      return body.map((dynamic item) => Task.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> addTask(Task task, String token) async {
    print("qqqqqqqqqqqqqqqqqqqq${task.toJson()}");
    final response = await http
        .post(
          Uri.parse('$_baseUrl/todos/add'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(task.toJson()),
        )
        .then((value) => print("lllllllllllllllllllll ${value.body}"));

    // if (response.statusCode != 200) {
    //   throw Exception('Failed to add task');
    // }
  }

  Future<void> updateTask(Task task, String token) async {
    print("eeee ${task.id}");
    final response = await http.put(
      Uri.parse('$_baseUrl/todos/${task.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(task.toJson()),
    ).then((value) => print(value));

    // if (response.statusCode != 200) {
    //   throw Exception('Failed to update task');
    // }
  }

  Future<void> deleteTask(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/todos/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
