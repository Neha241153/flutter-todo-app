
import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  final TodoService _service = TodoService();

  List<Todo> todos = [];
  bool isLoading = false;
  String? errorMessage;

  // Count completed todos
  int get completedCount {
    return todos.where((todo) => todo.completed).length;
  }

  // Fetch todos from API
  Future<void> fetchTodos() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      todos = await _service.getTodos();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


Future<void> addTodo(String title) async {
  try {
    final newTodo = await _service.createTodo(title);

    todos.insert(0, newTodo);

    notifyListeners();
  } catch (e) {
    errorMessage = e.toString();
    notifyListeners();
  }
}

}
