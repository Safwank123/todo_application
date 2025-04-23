import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/services/notification_services.dart';


class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _deadline = widget.task?.deadline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
        actions: [
          if (widget.task != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                Provider.of<TaskProvider>(context, listen: false)
                    .deleteTask(widget.task!.id);
                NotificationService.cancelNotification(widget.task!.id.hashCode);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Title is required' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              ListTile(
                title: Text(_deadline == null
                    ? 'Select Deadline'
                    : DateFormat.yMMMd().add_jm().format(_deadline!)),
                trailing: const Icon(Icons.calendar_today),
               onTap: () async {
  final date = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),  
    lastDate: DateTime(2030),   
  );
  if (date != null) {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _deadline = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      });
    }
  }
},
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                 // backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  fixedSize: const Size(150, 50),
                ),
                child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
                onPressed: () => _saveTask(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTask(BuildContext context) {
    if (_formKey.currentState!.validate() && _deadline != null) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final task = Task(
        id: widget.task?.id ?? DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        deadline: _deadline!,
        isCompleted: widget.task?.isCompleted ?? false,
      );

      if (widget.task == null) {
        taskProvider.addTask(task);
      } else {
        taskProvider.updateTask(task.id, task);
        NotificationService.cancelNotification(task.id.hashCode);
      }

      NotificationService.scheduleNotification(
        id: task.id.hashCode,
        title: 'Task Deadline: ${task.title}',
        body: task.description,
        scheduledTime: task.deadline,
      );

      Navigator.pop(context);
    }
  }
}