import '../models/task.dart';
import '../services/api_service.dart';
import 'auth_repository.dart';

class TaskRepository {
  final ApiService apiService;
  final AuthRepository authRepository;

  TaskRepository({required this.apiService, required this.authRepository});

  Future<List<Task>> fetchTasks(int limit, int skip) async {
    final token = await authRepository.getToken();
    if (token == null) throw Exception('No token found');
    return apiService.fetchTasks(limit, skip, token);
  }

  Future<void> addTask(Task task) async {
    final token = await authRepository.getToken();
    if (token == null) throw Exception('No token found');
    return apiService.addTask(task, token);
  }

  Future<void> updateTask(Task task) async {
    final token = await authRepository.getToken();
    if (token == null) throw Exception('No token found');
    return apiService.updateTask(task, token);
  }

  Future<void> deleteTask(int id) async {
    final token = await authRepository.getToken();
    if (token == null) throw Exception('No token found');
    return apiService.deleteTask(id, token);
  }
}
