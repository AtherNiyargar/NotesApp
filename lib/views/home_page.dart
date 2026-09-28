import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart' show Theme, Colors;
import 'package:notes_app/backend/database_functionality.dart';
import 'package:notes_app/backend/variables/notes.dart';
import 'package:notes_app/elements/notes_preview.dart';
import 'package:notes_app/views/create_or_edit_note.dart';

class HomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final DatabaseFunctionality _databaseFunctionality;

  @override
  void initState() {
    super.initState();
    _databaseFunctionality = DatabaseFunctionality();
  }

  @override
  Widget build(BuildContext context) {
    // print("=========CHECK=========");
    // showDialogs(context, title: "Refershed");
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar.search(

                trailing: CupertinoButton(
                  sizeStyle: .small,
                  child: Icon(CupertinoIcons.person_crop_circle, size: 25),
                  onPressed: () {
                    Navigator.pushNamed(context, "/account_and_settings_page");
                  },
                ),
                searchField: CupertinoSearchTextField(
                  onChanged: (String value) {},
                ),

                largeTitle: Text("Home"),
                bottomMode: .always,
              ),
              CupertinoSliverRefreshControl(
                refreshIndicatorExtent: 40,
                refreshTriggerPullDistance: 150,
                onRefresh: () async {
                  setState(() {});
                },
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.only(left: 20),
                      sizeStyle: .large,
                      child: Row(
                        spacing: 10,
                        children: [
                          Icon(
                            CupertinoIcons.line_horizontal_3_decrease,
                            size: 24,
                          ),
                          Text(
                            "Sort by",
                            style: .new(
                              color: CupertinoColors.systemBlue,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        _databaseFunctionality.deleteAllNotes();
                      },
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.only(right: 20),
                      sizeStyle: .large,

                      child: Icon(CupertinoIcons.add, size: 25),
                      onPressed: () {
                        showCupertinoModalPopup(
                          semanticsDismissible: true,
                          barrierDismissible: true,
                          useRootNavigator: true,

                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            title: Text("Create"),

                            actions: [
                              CupertinoActionSheetAction(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  final shouldRefresh =
                                      await Navigator.of(context).push<bool>(
                                        CupertinoPageRoute(
                                          builder: (context) {
                                            return CreateOrEditNotePage();
                                          },
                                        ),
                                      );
                                  if (shouldRefresh!) {
                                    setState(() {});
                                  }
                                  // callBackFunction(shouldRefresh!);
                                  // }
                                  // if (_shouldRefresh) {
                                  //   shouldRefresh(true);
                                  // } else {

                                  // }

                                  // Navigator.pushNamed(
                                  //   context,
                                  //   "/create_note_page",
                                  // );
                                },
                                child: const CreateOption(
                                  icon: Icon(CupertinoIcons.textformat),
                                  optionName: "Note",
                                ),
                              ),

                              CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, "/todo_page");
                                },
                                child: const CreateOption(
                                  icon: Icon(CupertinoIcons.list_number),
                                  optionName: "Todo list",
                                ),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () {},
                                child: const CreateOption(
                                  icon: Icon(CupertinoIcons.mic),
                                  optionName: "Transcribe",
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: _databaseFunctionality.populateNotes(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == .done) {
                    if (notesData.isNotEmpty) {
                      return SliverList.builder(
                        itemCount: notesData.length,

                        itemBuilder: (context, index) {
                          final note = notesData[index];
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: NotesPreview(
                              callBackFunction: (shouldRefresh) {
                                if (shouldRefresh) {
                                  setState(() {});
                                }
                              },
                              id: note["id"],
                              title: note["title"],
                              content: note["content"],
                            ),
                          );
                        },
                      );
                    }
                    return SliverFillRemaining(
                      child: Center(child: Text("No notes found!")),
                    );
                  }
                  return SliverFillRemaining(
                    child: CupertinoActivityIndicator(),
                  );
                },
              ),
              // SliverList.builder(

              //   itemCount: 10,
              //   itemBuilder: (context, index) {
              //     return Padding(
              //       padding: const EdgeInsets.all(8),
              //       child: NotesPreview(),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateOption extends StatelessWidget {
  final Icon icon;
  final String optionName;
  const new({super.key, required this.icon, required this.optionName});

  @override
  Widget build(BuildContext context) {
    final themeMode = Theme.brightnessOf(context);
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Padding(padding: const EdgeInsets.only(left: 10), child: icon),
        Text(
          optionName,

          style: TextStyle(
            color: themeMode == .dark ? Colors.white : Colors.black,
            fontSize: 18,
          ),
        ),
        SizedBox(width: 30),
      ],
    );
  }
}
