import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:material_ui/material_ui.dart' show Theme, Colors;
import 'package:notes_app/backend/database_functionality.dart';
import 'package:notes_app/backend/sync_notes_service.dart';
import 'package:notes_app/backend/variables/notes.dart';
import 'package:notes_app/elements/notes_preview.dart';
import 'package:notes_app/elements/show_dialogs.dart';
import 'package:notes_app/views/create_or_edit_note.dart';
import 'package:shared_preferences/shared_preferences.dart';

import "dart:isolate";

class HomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final DatabaseFunctionality _databaseFunctionality;
  late Future<void> Function() loadApp;
  SharedPreferences? _sharedPreferences;

  Future<void> sortNotesAndRefresh() async {
    final notesDataCopy = notesData;
    final sortByCopy = sortBy;
    notesData = await Isolate.run(() {
      return sortNotes(sortByCopy, notesDataCopy);
    });
  }

  Future<void> fetchDbNotesAndSortAndRefresh() async {
    await _databaseFunctionality.populateNotes();
    final notesDataCopy = notesData;
    final sortByCopy = sortBy;
      // print("=========== $notesData");
    notesData = await Isolate.run(() {
      return sortNotes(sortByCopy, notesDataCopy);
    });
  }

  Future<void> _initApp() async {
    await _databaseFunctionality.populateNotes();
    _sharedPreferences ??= await SharedPreferences.getInstance();
    sortBy = _sharedPreferences!.getString("sortBy") ?? "created_at_  asc";
    final notesDataCopy = notesData;
    final sortByCopy = sortBy;
    notesData = await Isolate.run(() {
      return sortNotes(sortByCopy, notesDataCopy);
    });
  }

  @override
  void initState() {
    super.initState();
    _databaseFunctionality = DatabaseFunctionality();
    loadApp = _initApp;
  }

  @override
  void dispose() {
    super.dispose();
  }
  

  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SafeArea(
          child: CustomScrollView(
            dragStartBehavior: .down,
            // physics: LockableScrollPhysics(isLocked: () => _isMenuInteraction),
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
                  await SyncNotesService().syncNotes();
                  loadApp = fetchDbNotesAndSortAndRefresh;
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
                            "Sort",
                            style: .new(
                              color: CupertinoColors.systemBlue,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        showCupertinoModalPopup(
                          semanticsDismissible: true,
                          barrierDismissible: true,
                          useRootNavigator: true,
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            title: Text("Sort by"),
                            actions: [
                              CupertinoActionSheetAction(
                                onPressed: () async {
                                  loadApp = sortNotesAndRefresh;

                                  sortBy = sortBy == "title_asc"
                                      ? "title_desc"
                                      : "title_asc";
                                  await _sharedPreferences!.setString(
                                    "sortBy",
                                    sortBy,
                                  );
                                  setState(() {});
                                },
                                child: const CreateOption(
                                  icon: Icon(CupertinoIcons.textformat_abc),
                                  optionName: "Title",
                                ),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () async {
                                  loadApp = sortNotesAndRefresh;

                                  sortBy = sortBy == "modified_at_asc"
                                      ? "modified_at_desc"
                                      : "modified_at_asc";
                                  await _sharedPreferences!.setString(
                                    "sortBy",
                                    sortBy,
                                  );
                                  setState(() {});
                                },
                                child: const CreateOption(
                                  icon: Icon(CupertinoIcons.pencil),
                                  optionName: "Modified",
                                ),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () async {
                                  loadApp = sortNotesAndRefresh;
                                  sortBy = sortBy == "created_at_asc"
                                      ? "created_at_desc"
                                      : "created_at_asc";
                                  await _sharedPreferences!.setString(
                                    "sortBy",
                                    sortBy,
                                  );
                                  setState(() {});
                                },
                                child: const CreateOption(
                                  icon: Icon(CupertinoIcons.time),
                                  optionName: "Created",
                                ),
                              ),
                            ],
                          ),
                        );
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
                                    loadApp = fetchDbNotesAndSortAndRefresh;
                                    setState(() {});
                                  }
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
                future: loadApp(),
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

                              callBackFunction: (shouldRefresh) async {
                                if (shouldRefresh) {
                                  loadApp = fetchDbNotesAndSortAndRefresh;
                                  setState(() {});
                                }
                              },
                              id: note["id"],
                              title: note["title"],
                              content: note["content"],
                              createdAt: note["created_at"],
                              modifiedAt: note["modified_at"],
                              pinned: note["pinned"],
                            ),
                          );
                        },
                      );
                    }
                    return SliverFillRemaining(
                      child: Center(child: Text("No notes found!")),
                    );
                  } else if (snapshot.hasError) {
                    showDialogs(
                      context,
                      title: "Failed to get notes. Please try again",
                    );
                  }
                  return SliverFillRemaining(
                    child: CupertinoActivityIndicator(),
                  );
                },
              ),
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