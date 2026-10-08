import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:notes_app/backend/database_functionality.dart';
import 'package:notes_app/backend/sync_todos_service.dart';
import 'package:notes_app/backend/todo_state_provider.dart';
import 'package:notes_app/views/todo_task_page.dart';

// import 'package:share_plus/share_plus.dart';

class TodoPage extends StatefulWidget {
  const new({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final DatabaseFunctionality _databaseFunctionality = DatabaseFunctionality();

  final TextEditingController _controller = TextEditingController();

  final TodoStateProvider _stateProvider = TodoStateProvider();

  @override
  Widget build(BuildContext context) {
    final darkTheme = CupertinoTheme.brightnessOf(context) == .dark;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            transitionBetweenRoutes: false,
            padding: EdgeInsetsDirectional.only(top: 10),
            bottomMode: .always,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Row(
                      spacing: 10,
                      children: [Icon(CupertinoIcons.doc), Text("Todo pages")],
                    ),
                    GlassMenu(
                      quality: .premium,
                      settings: LiquidGlassSettings(blur: 10),

                      menuHeight: MediaQuery.heightOf(context) / 5,
                      menuWidth: MediaQuery.widthOf(context) - 20,
                      // settings: _kMenuGlass(context),
                      menuBorderRadius: 32,

                      // quality: GlassQuality.premium,
                      triggerBuilder: (context, toggleMenu) {
                        // final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
                        return GlassButton.custom(
                          onTap: toggleMenu,
                          width: 44,
                          height: 44,
                          // settings: _kTriggerGlass(context),
                          shape: const LiquidRoundedRectangle(borderRadius: 22),
                          // quality: GlassQuality.premium,
                          useOwnLayer: true,
                          persistPressOnDrag: true,
                          // ambientBaseLight: isDark ? 0.0 : 0.25,
                          child: Center(child: Icon(CupertinoIcons.add)),
                        );
                      },

                      items: [
                        SizedBox(height: 15),
                        Column(
                          spacing: 0,
                          mainAxisAlignment: .center,
                          children: [
                            CupertinoTextField.borderless(
                              controller: _controller,
                              prefix: Icon(CupertinoIcons.doc),
                              maxLength: 50,
                              placeholder: " Create todo page",
                              style: TextStyle(fontSize: 32, fontWeight: .w500),
                            ),
                          ],
                        ),
                        GlassMenuItem(
                          title: "Create",

                          onTap: () async {
                            final pageName = _controller.text.trim();
                            if (pageName.isNotEmpty) {
                              await _databaseFunctionality.addPage(pageName);
                              _stateProvider.refreshList();
                            }
                            _controller.clear();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            largeTitle: Text("Todos"),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await SyncTodosService().syncTodos(context);
              _stateProvider.refreshList();
            },
            refreshIndicatorExtent: 40,
            refreshTriggerPullDistance: 150,
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24)),
          ListenableBuilder(
            listenable: _stateProvider,
            builder: (context, _) => FutureBuilder<List<Map<String, Object?>>>(
              // future: Future.delayed(Duration(seconds: 3)),
              future: _databaseFunctionality.getAllPage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == .done) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final page = snapshot.data;
                    return SliverList.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CupertinoContextMenu(
                          actions: [
                            CupertinoContextMenuAction(
                              trailingIcon: CupertinoIcons.share,
                              child: Text("Share"),
                              onPressed: () async {
                                // final tasksToShare = await _databaseFunctionality
                                //     .getTasksToShare(
                                //       page![index]["page_name"] as String,
                                //     );
                                // SharePlus.instance.share(
                                //   ShareParams(
                                //     text:
                                //         "${page[index]["page_name"]}\n$tasksToShare",
                                //   ),
                                // );
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoContextMenuAction(
                              trailingIcon: CupertinoIcons.delete,
                              isDestructiveAction: true,
                              child: Text("Delete"),
                              onPressed: () async {
                                await _databaseFunctionality.deletePage(
                                  page![index]["unique_id"] as String,
                                );
                                _stateProvider.refreshList();
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              },
                            ),
                          ],
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: darkTheme
                                  ? CupertinoColors.black
                                  : CupertinoColors.systemBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                width: 2,
                                color: darkTheme
                                    ? const Color.fromARGB(255, 56, 56, 56)
                                    : const Color.fromARGB(255, 208, 208, 212),
                              ),
                            ),
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width - 16,
                              child: CupertinoListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => TodoTaskPage(
                                        pageName:
                                            page[index]["page_name"] as String,
                                        pageId: page[index]["unique_id"] as String,
                                        // stateProvider: _stateProvider,
                                        // databaseFunctionality:
                                        //     _databaseFunctionality,
                                      ),
                                    ),
                                  );
                                },
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                title: Text(
                                  page![index]["page_name"] as String,
                                  softWrap: true,
                                  maxLines: 4,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: .w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SliverToBoxAdapter(
                      child: Center(child: Text("No Pages")),
                    );
                  }
                }
                return SliverToBoxAdapter(
                  child: Center(child: CupertinoActivityIndicator()),
                );
              },
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
