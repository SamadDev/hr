import 'package:nandrlon/models/crm/task/task-parameter.dart';
import 'package:nandrlon/models/crm/task/task-result.dart';
import 'package:nandrlon/models/crm/task/task.dart';
import 'package:nandrlon/models/crm/task/tasks-priority.dart';
import 'package:nandrlon/models/crm/task/tasks-status.dart';
import 'package:nandrlon/services/crm.service.dart';

class TaskService {
  static String api = "/api/crm/tasks";

  static Future<Task> getTask(int id) async {
    final result = await CRMDataService.get('$api/$id');
    return Task.fromJson(result);
  }

  static Future<List<TaskResult>> getTasks(TaskParameters search) async {
    final result = await CRMDataService.get(api + search.toString());
    return TaskResult.toList(result);
  }

  static Future<List<TaskStatus>> getStatuses() async {
    final result = await CRMDataService.get("$api/statuses");
    return TaskStatus.toList(result);
  }

  static Future<List<TaskPriority>> getPriorities() async {
    final result = await CRMDataService.get("$api/priorities");
    return TaskPriority.toList(result);
  }

  static Future<void> create(Task task) async {
    final result = await CRMDataService.post(api, task);
    return TaskResult.fromJson(result.data);
  }

  static Future<void> update(Task task) async {
    final result = await CRMDataService.put("$api", task);
    return TaskResult.fromJson(result.data);
  }
}
