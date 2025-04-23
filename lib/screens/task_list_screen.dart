import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/utiles/theme_provider.dart';
import 'add_edit_task_screen.dart';
import '../providers/task_provider.dart';
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddEditTaskScreen()),
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) => ListView.builder(
          itemCount: taskProvider.tasks.length,
          itemBuilder: (context, index) {
            final task = taskProvider.tasks[index];
            return ListTile(
              title: Text(task.title),
              subtitle: Text(task.description),
              trailing: Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  taskProvider.updateTask(
                    task.id,
                    task.copyWith(isCompleted: value),
                  );
                },
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditTaskScreen(task: task),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}