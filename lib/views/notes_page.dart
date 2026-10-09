import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/backend/database_functionality.dart'
    show DatabaseFunctionality;
import 'package:notes_app/backend/sync_notes_service.dart';
import 'package:notes_app/backend/variables/notes.dart'
    show notesData, sortBy, sortNotes;
import 'package:notes_app/elements/notes_preview.dart';
import 'package:notes_app/elements/show_dialogs.dart';
import 'package:notes_app/views/create_or_edit_note.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';

late final TextEditingController _searchController;

class SearchNotes extends ChangeNotifier {
  void refreshSearchedNotes() {
    searchedNotes = notesData;
    notifyListeners();
  }

  List<Map<String, dynamic>> searchedNotes = notesData;
  List<Map<String, dynamic>> get getNotes => searchedNotes;
  void searchNotes(String searchQuery) {
    if (searchQuery.trim().isEmpty) {
      searchedNotes = notesData;
      notifyListeners();
      return;
    }
    searchedNotes = notesData
        .where((note) => note["title"].contains(searchQuery.trim()))
        .toList();
    notifyListeners();
  }
}

class NotesPage extends StatefulWidget {
  const new({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final DatabaseFunctionality _databaseFunctionality;
  late Future<void> Function() loadApp;
  SharedPreferences? _sharedPreferences;
  final SearchNotes searchNotes = SearchNotes();

  Future<void> sortNotesAndRefresh() async {
    final notesDataCopy = notesData;
    final sortByCopy = sortBy;
    notesData = await Isolate.run(() {
      return sortNotes(sortByCopy, notesDataCopy);
    });
    searchNotes.refreshSearchedNotes();
  }

  Future<void> fetchDbNotesAndSortAndRefresh() async {
    await _databaseFunctionality.populateNotes();
    final notesDataCopy = notesData;
    final sortByCopy = sortBy;
    notesData = await Isolate.run(() {
      return sortNotes(sortByCopy, notesDataCopy);
    });
    searchNotes.refreshSearchedNotes();
  }

  Future<void> _initApp() async {
    await SyncNotesService().syncNotes(context);
    await _databaseFunctionality.populateNotes();
    _sharedPreferences ??= await SharedPreferences.getInstance();
    sortBy = _sharedPreferences!.getString("sortBy") ?? "created_at_asc";
    final notesDataCopy = notesData;
    final sortByCopy = sortBy;
    notesData = await Isolate.run(() {
      return sortNotes(sortByCopy, notesDataCopy);
    });
    searchNotes.refreshSearchedNotes();
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
    final isDarkTheme = Theme.brightnessOf(context) == .dark;
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SafeArea(
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            slivers: [
              SearchBar(searchNotes: searchNotes),

              CupertinoSliverRefreshControl(
                refreshIndicatorExtent: 40,
                refreshTriggerPullDistance: 150,
                onRefresh: () async {
                  await SyncNotesService().syncNotes(context);
                  loadApp = fetchDbNotesAndSortAndRefresh;
                  _searchController.clear();
                  setState(() {});
                },
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      GlassMenu(
                        menuWidth: 200,
                        // settings: _kMenuGlass(context),
                        menuBorderRadius: 32,
                        // quality: GlassQuality.premium,

                        triggerBuilder: (context, toggleMenu) {
                          // final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
                          return GlassButton.custom(
                            onTap: toggleMenu,
                            width: 90,
                            height: 44,
                            // settings: _kTriggerGlass(context),
                            shape: const LiquidRoundedRectangle(
                              borderRadius: 22,
                            ),
                            // quality: GlassQuality.premium,
                            useOwnLayer: true,
                            persistPressOnDrag: true,
                            // ambientBaseLight: isDark ? 0.0 : 0.25,
                            child: Center(
                              child: Row(
                                spacing: 8,
                                mainAxisAlignment: .center,
                                children: [
                                  Icon(
                                    CupertinoIcons.line_horizontal_3_decrease,
                                  ),
                                  Text(
                                    'Sort',
                                    style: TextStyle(
                                      color: CupertinoColors.activeBlue,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: -0.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        items: [
                          GlassMenuItem(
                            iconSize: 25,
                            title: "Title",
                            // iconColor: CupertinoColors.activeBlue,
                            icon: Icon(CupertinoIcons.textformat_abc),
                            onTap: () async {
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
                          ),
                          GlassMenuItem(
                            iconSize: 25,
                            icon: Icon(CupertinoIcons.pencil),
                            title: "Modified",
                            onTap: () async {
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
                          ),
                          GlassMenuItem(
                            iconSize: 25,
                            icon: Icon(CupertinoIcons.time),
                            title: "Created",
                            onTap: () async {
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
                          ),
                        ],
                      ),

                      GlassButton(
                        height: 44,
                        width: 44,
                        iconColor: CupertinoColors.activeBlue,
                        icon: Icon(CupertinoIcons.add),
                        onTap: () async {
                          final shouldRefresh = await Navigator.of(context)
                              .push<bool>(
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
                      ),
                    ],
                  ),
                ),
              ),
              FutureBuilder(
                future: loadApp(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == .done) {
                    loadApp = sortNotesAndRefresh;
                    if (notesData.isNotEmpty) {
                      return ListenableBuilder(
                        listenable: searchNotes,
                        builder: (context, child) => SliverList.builder(
                          itemCount: searchNotes.getNotes.length,
                          itemBuilder: (context, index) {
                            final note = searchNotes.getNotes[index];
                            return NotesPreview(
                              callBackFunction: (shouldRefresh) async {
                                if (shouldRefresh) {
                                  _searchController.clear();
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
                            );
                          },
                        ),
                      );
                    }
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          "No notes found!",
                          style: TextStyle(
                            color: isDarkTheme
                                ? CupertinoColors.white
                                : CupertinoColors.black,
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    debugPrint('Error: ${snapshot.error}');
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

class SearchBar extends StatefulWidget {
  final SearchNotes searchNotes;
  const new({super.key, required this.searchNotes});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar.search(
      transitionBetweenRoutes: false,
      searchField: CupertinoSearchTextField(
        controller: _searchController,
        onChanged: (String value) {
          widget.searchNotes.searchNotes(value);
        },
      ),

      largeTitle: Text("Home"),
      bottomMode: .always,
    );
  }
}
