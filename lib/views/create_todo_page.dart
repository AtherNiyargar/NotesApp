import 'package:flutter/cupertino.dart';
import 'package:material_ui/material_ui.dart' show Divider;

class CreateTodoPage extends StatefulWidget {
  const new({super.key});

  @override
  State<CreateTodoPage> createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends State<CreateTodoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Create Todo")),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              CupertinoTextField.borderless(
                placeholder: "Task name",
                style: TextStyle(fontSize: 32),
              ),
              Divider(color: const Color.fromARGB(126, 153, 153, 153)),
              CupertinoButton(child: Text("Create"), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
