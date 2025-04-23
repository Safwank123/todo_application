import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/task_model.dart';


class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final String _storageKey = 'tasks';

  List<Task> get tasks => _tasks;

  TaskProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskStrings = prefs.getStringList(_storageKey) ?? [];
    _tasks = taskStrings
        .map((taskString) => Task.fromJson(json.decode(taskString)))
        .toList();
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskStrings = _tasks.map((task) => json.encode(task.toJson())).toList();
    await prefs.setStringList(_storageKey, taskStrings);
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    _saveTasks();
  }

  void updateTask(String id, Task newTask) {
    final index = _tasks.indexWhere((task) => task.id == id);
    _tasks[index] = newTask;
    _saveTasks();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasks();
  }
}