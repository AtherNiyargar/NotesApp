import 'package:flutter/cupertino.dart';
import 'package:material_ui/material_ui.dart' show Divider;
import 'package:notes_app/views/todo_task_page.dart';

class CreateTask extends StatefulWidget {
  final TaskStateProvider _taskStateProvider;
  final String page;

  const new({super.key, required this._taskStateProvider, required this.page});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: "Todos",
        middle: Text("Create Todo"),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              CupertinoTextField.borderless(
                controller: _controller,
                placeholder: "Task name",
                style: TextStyle(fontSize: 32),
              ),
              Divider(color: const Color.fromARGB(126, 153, 153, 153)),
              CupertinoButton(
                child: Text("Create"),
                onPressed: () async {
                  if (_controller.text.trim().isEmpty) return;
                  await widget._taskStateProvider.addTask(
                    _controller.text.trim(),
                    widget.page,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
