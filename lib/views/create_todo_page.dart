import 'package:flutter/cupertino.dart';
import 'package:material_ui/material_ui.dart' show Divider;
import 'package:notes_app/backend/database_functionality.dart';
import 'package:notes_app/backend/todo_state_provider.dart';
import 'package:notes_app/elements/show_dialogs.dart' show showDialogs;

class CreateTodoPagePage extends StatefulWidget {
  final TodoStateProvider _stateProvider;
  final DatabaseFunctionality _databaseFunctionality;
  const new({
    super.key,
    required this._stateProvider,
    required this._databaseFunctionality,
  });

  @override
  State<CreateTodoPagePage> createState() => _CreateTodoPagePageState();
}

class _CreateTodoPagePageState extends State<CreateTodoPagePage> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(previousPageTitle: "Todos"),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 0,
          mainAxisAlignment: .center,
          children: [
            CupertinoTextField.borderless(
              prefix: Icon(CupertinoIcons.doc),
              controller: _textEditingController,
              maxLength: 50,
              maxLines: null,

              placeholder: " Page Name",
              style: TextStyle(fontSize: 32, fontWeight: .w500),
            ),
            Divider(color: const Color.fromARGB(126, 153, 153, 153)),
            CupertinoButton(
              child: Text("Create"),
              onPressed: () async {
                final page = _textEditingController.text.trim();
                if (page.isEmpty) return;
                try {
                  await widget._databaseFunctionality.addPage(
                    _textEditingController.text.trim(),
                  );
                  widget._stateProvider.refreshList();
                  if (!context.mounted) return;
                  Navigator.pop(context);
                } catch (e) {
                  await showDialogs(
                    context,
                    title: "Unable to add folder",
                    content: "The folder with this name may already exist.${e}",
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
