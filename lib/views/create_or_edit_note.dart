import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;
import 'package:notes_app/backend/database_functionality.dart';

class CreateOrEditNotePage extends StatefulWidget {
  final String? title;
  final String? content;
  final int? id;
  const new({super.key, this.id, this.title, this.content});

  @override
  State<CreateOrEditNotePage> createState() => _CreateOrEditNotePageState();
}

class _CreateOrEditNotePageState extends State<CreateOrEditNotePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  late final DatabaseFunctionality _databaseFunctionality;

  int? tempSno;

  bool isNoteEdited = false;

  @override
  void initState() {
    super.initState();
    tempSno = widget.id;

    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _databaseFunctionality = DatabaseFunctionality();
    _titleController.text = widget.title ?? "";
    _contentController.text = widget.content ?? "";
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final title = _titleController.text.trim();
        final content = _contentController.text;

        if (title.isEmpty && content.isEmpty) {
          Navigator.pop(context, false);
          return;
        }
        if (title == widget.title && content == widget.content) {
          Navigator.pop(context, false);
          return;
        }

        await _databaseFunctionality.insertOrUpdateNote(
          context,
          tempSno ?? widget.id,
          title,
          content,
        );
        if (!context.mounted) return;
        Navigator.pop(context, true);
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Flexible(
                    flex: 0,
                    child: CupertinoTextField(
                      placeholder: "Title",
                      controller: _titleController,
                      style: TextStyle(fontSize: 32, fontWeight: .bold),
                      decoration: BoxDecoration(
                        border: Border.all(color: .new(0)),
                      ),
                    ),
                  ),
                  Divider(color: const Color.fromARGB(126, 153, 153, 153)),
                  CupertinoTextField(
                    textAlignVertical: .top,

                    placeholder: "Text",
                    controller: _contentController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: .multiline,
                    expands: true,
                    maxLines: null,
                    minLines: null,

                    decoration: BoxDecoration(
                      border: Border.all(color: .new(0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*

import 'package:flutter/cupertino.dart';

/// Flutter code sample for [CupertinoTabScaffold].

void main() => runApp(const TabScaffoldApp());

class TabScaffoldApp extends StatelessWidget {
  const TabScaffoldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(brightness: .light),
      home: TabScaffoldExample(),
    );
  }
}

class TabScaffoldExample extends StatefulWidget {
  const TabScaffoldExample({super.key});

  @override
  State<TabScaffoldExample> createState() => _TabScaffoldExampleState();
}

class _TabScaffoldExampleState extends State<TabScaffoldExample> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search_circle_fill),
            label: 'Explore',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text('Page 1 of tab $index'),
              ),
              child: Center(
                child: CupertinoButton(
                  child: const Text('Next page'),
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                        builder: (BuildContext context) {
                          return CupertinoPageScaffold(
                            navigationBar: CupertinoNavigationBar(
                              middle: Text('Page 2 of tab $index'),
                            ),
                            child: Center(
                              child: CupertinoButton(
                                child: const Text('Back'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
 */

/*
class CreateNote extends StatefulWidget {
  const new({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      // appBar: AppBar(),

      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      // color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  // child: TextField(
                  //   maxLines: null,
                  //   style: TextStyle(
                  //     // color: Theme.of(context).colorScheme.onSurface
                  //   ),
                  //   decoration: InputDecoration(
                  //     border: InputBorder.none,
                  //     // prefix: Icon(Icons.abc),
                  //     // labelText: "Fdsfds",

                  //     // helperText: "sf"
                  //     hint: Text(
                  //       "Say your magical thoughts!",
                  //       // style: Theme.of(context).textTheme.bodyMedium,
                  //       // style: TextStyle(fontFeatures: [FontFeature("GPOS", 1)]),
                  //     ),
                  //   ),
                  // ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),

                child: Row(
                  mainAxisAlignment: .center,
                  spacing: 8,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.format_italic_rounded),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.format_bold_rounded),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.format_underline_rounded),
                    ),
                    Expanded(child: SizedBox.shrink()),
                    FilledButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.star_rounded),
                      label: Text("Post", style: TextStyle(fontSize: 18)),
                      style: ButtonStyle(
                        iconSize: WidgetStatePropertyAll(20),
                        fixedSize: WidgetStatePropertyAll(Size(120, 48)),
                      ),
                    ),
                  ],

                  // crossAxisAlignment: .center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/
