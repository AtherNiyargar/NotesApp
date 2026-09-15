import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;

class CreateNotePage extends StatefulWidget {
  const new({super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  late final TextEditingController _controller;
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        // previousPageTitle: "Tt",
        // bottom: PreferredSize(preferredSize: .new(0, 0), child: SizedBox.shrink()),
        // padding: EdgeInsetsDirectional.only(top: 10, start: 10, end: 10, bottom: 10),
        middle: Text("Create Note"),
        // leading: CupertinoButton(
        //   // alignment: .centerLeft,
        //   // minimumSize: Size(14, 14),
        //   // padding: EdgeInsets.all(8),
        //   // sizeStyle: .small,
        //   child: Text("Exit"),
        //   // child: Icon(CupertinoIcons.person_crop_circle, size: 25),
        //   onPressed: () {},
        // ),
        leading: CupertinoButton(
          sizeStyle: .medium,
          child: Text("", style: .new(fontSize: 18)),
          // child: Icon(CupertinoIcons.person_crop_circle, size: 25),
          onPressed: () {},
        ),
        // leading: CupertinoButton(onPressed: () {Navigator.pop(context);}, sizeStyle: .small,child: Text("Exit"),),
        trailing: CupertinoButton(
          sizeStyle: .small,
          child: Text("Save", style: .new(fontSize: 18)),
          // child: Icon(CupertinoIcons.person_crop_circle, size: 25),
          onPressed: () {},
        ),
        // trailing: CupertinoButton(
        //   onPressed: () {},
        //   sizeStyle: .medium,
        //   child: Text("Save"),
        // ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Divider(color: const Color.fromARGB(126, 153, 153, 153)),
                Flexible(
                  // fit: .tight,
                  flex: 0,
                  child: CupertinoTextField(
                    // scrollPhysics: NeverScrollableScrollPhysics(),
                    placeholder: "Title",
                    controller: _titleController,
                    style: TextStyle(fontSize: 32, fontWeight: .bold),

                    // keyboardType: .multiline,
                    // expands: true,
                    // maxLines: null,
                    // minLines: null,
                    decoration: BoxDecoration(
                      border: Border.all(color: .new(0)),
                    ),
                  ),
                ),
                Divider(color: const Color.fromARGB(126, 153, 153, 153)),
                CupertinoTextField(
                  textAlignVertical: .top,

                  placeholder: "Text",
                  controller: _controller,
                  style: TextStyle(fontSize: 18),
                  keyboardType: .multiline,
                  expands: true,
                  maxLines: null,
                  minLines: null,

                  decoration: BoxDecoration(border: Border.all(color: .new(0))),
                ),
              ],
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
