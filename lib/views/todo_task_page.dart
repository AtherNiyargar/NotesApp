import 'package:cupertino_lists_enhanced/list_section.dart';
import 'package:cupertino_lists_enhanced/list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:liquid_glass_widgets/widgets/interactive/glass_button.dart';
import 'package:notes_app/backend/database_functionality.dart';
import 'package:notes_app/views/create_task.dart';
import 'package:share_plus/share_plus.dart';

class TaskStateProvider extends ChangeNotifier {
  final DatabaseFunctionality _databaseFunctionality = DatabaseFunctionality();

  List<Map<String, Object?>> _completedTask = [];
  List<Map<String, Object?>> _incompletedTask = [];

  List<Map<String, Object?>> get completedTask => _completedTask;
  List<Map<String, Object?>> get incompletedTask => _incompletedTask;

  Future<void> populateTasks(String pageUid) async {
    _completedTask = await _databaseFunctionality.fetchCompletedTask(pageUid);
    _incompletedTask = await _databaseFunctionality.fetchIncompletedTask(
      pageUid,
    );
    notifyListeners();
  }

  Future editTask(String pageId, String newTaskName, String taskId) async {
    await _databaseFunctionality.editTask(newTaskName, taskId);
    await populateTasks(pageId);
  }

  Future<void> updateTask(String taskId, bool check, String pageId) async {
    await _databaseFunctionality.updateTask(taskId, check);
    await populateTasks(pageId);
  }

  Future<void> addTask(String task, String pageUid) async {
    await _databaseFunctionality.addTask(task, pageUid);
    await populateTasks(pageUid);
  }

  Future<void> deleteTask(String taskId, String pageId) async {
    await _databaseFunctionality.deleteATask(taskId);
    await populateTasks(pageId);
  }
}

class TodoTaskPage extends StatefulWidget {
  final String pageId;
  final String pageName;

  const TodoTaskPage({super.key, required this.pageName, required this.pageId});

  @override
  State<TodoTaskPage> createState() => _TodoTaskPageState();
}

class _TodoTaskPageState extends State<TodoTaskPage> {
  late final TaskStateProvider _taskStateProvider;
  late final TextEditingController _editTaskController;

  @override
  void initState() {
    super.initState();
    _taskStateProvider = TaskStateProvider();
    _editTaskController = TextEditingController();
    // Fetch initial data once on mount
    _taskStateProvider.populateTasks(widget.pageId);
  }

  @override
  void dispose() {
    _taskStateProvider.dispose();
    _editTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Tasks"),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoNavigationBarBackButton(
                  previousPageTitle: "Todos",
                  onPressed: () => Navigator.maybePop(context),
                ),
                SizedBox(
                  height: 44,
                  width: 44,
                  child: GlassButton(
                    width: 44,
                    iconColor: CupertinoColors.activeBlue,
                    icon: const Icon(CupertinoIcons.add),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => CreateTask(
                            taskStateProvider: _taskStateProvider,
                            pageUid: widget.pageId,
                          ),
                        ),
                      );
                      // Refresh upon returning in case new task was added
                      // _taskStateProvider.populateTasks(widget.pageName);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // CupertinoSliverRefreshControl(
            //   refreshIndicatorExtent: 40,
            //   refreshTriggerPullDistance: 150,
            //   onRefresh: () async {
            //     await _taskStateProvider.populateTasks(widget.pageName);
            //   },
            // ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                  widget.pageName,
                  style: const TextStyle(
                    fontSize: 44,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: TaskListSection(
                taskStateProvider: _taskStateProvider,
                pageName: widget.pageName,
                pageId: widget.pageId,
                editingController: _editTaskController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskListSection extends StatelessWidget {
  final TaskStateProvider taskStateProvider;
  final String pageName;
  final String pageId;
  final TextEditingController _editingController;

  const TaskListSection({
    super.key,
    required this.taskStateProvider,
    required this.pageName,
    required this.pageId,
    required this._editingController,
  });

  void _showDeleteDialog(
    BuildContext context,
    String taskId,
    String taskName,
    String pageId,
    bool isCompleted,
  ) {
    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Task"),
          content: Text(taskName),
          actions: [
            CupertinoContextMenuAction(
              isDefaultAction: true,
              trailingIcon: CupertinoIcons.create,
              child: const Text("Edit"),
              onPressed: () async {
                _editingController.text = taskName;
                await showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text("Update task name"),
                      ),
                      content: CupertinoTextField(
                        placeholder: "New name",
                        controller: _editingController,
                      ),
                      actions: [
                        CupertinoContextMenuAction(
                          child: Center(child: const Text("Cancel")),
                          onPressed: () => Navigator.pop(context),
                        ),
                        CupertinoContextMenuAction(
                          isDefaultAction: true,
                          child: Center(
                            child: const Text(
                              "OK",
                              style: TextStyle(
                                color: CupertinoColors.activeBlue,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            final text = _editingController.text.trim();
                            if (text == taskName) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              return;
                            }
                            if (text.isNotEmpty) {
                              await taskStateProvider.editTask(
                                pageId,
                                text,
                                taskId,
                              );
                              _editingController.clear();
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                            _editingController.clear();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            CupertinoContextMenuAction(
              isDefaultAction: true,
              trailingIcon: CupertinoIcons.share,
              child: const Text("Share"),
              onPressed: () {
                SharePlus.instance.share(
                  ShareParams(text: "${isCompleted ? "✅" : "❌"} $taskName"),
                );
                Navigator.pop(context);
              },
            ),
            CupertinoContextMenuAction(
              trailingIcon: CupertinoIcons.delete,
              isDestructiveAction: true,
              child: const Text("Delete"),
              onPressed: () async {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text("Are you sure you want to delete this task?"),
                    content: Text(taskName),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: Text("Delete"),
                        onPressed: () async {
                          await taskStateProvider.deleteTask(
                            taskId,
                            pageId,
                          );
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: taskStateProvider,
      builder: (context, child) {
        final incompleted = taskStateProvider.incompletedTask;
        final completed = taskStateProvider.completedTask;
        return Column(
          children: [
            if (incompleted.isNotEmpty)
              EnhancedCupertinoListSection.insetGrouped(
                footer: completed.isEmpty ? const SizedBox(height: 100) : null,
                header: const Text('TODO'),
                children: List.generate(incompleted.length, growable: false, (
                  index,
                ) {
                  final task = incompleted[index];
                  final taskId = task["task_id"] as String;
                  final taskTitle = task["task"] as String;
                  return GestureDetector(
                    onLongPress: () => _showDeleteDialog(
                      context,
                      taskId,
                      taskTitle,
                      pageId,
                      false,
                    ),
                    child: EnhancedCupertinoListTile(
                      onTap: () async {
                        await taskStateProvider.updateTask(
                          taskId,
                          true,
                          pageId,
                        );
                      },
                      titleBuilder: (context) => Text(taskTitle),
                      leading: Transform.scale(
                        scale: 2,
                        child: CupertinoCheckbox(
                          value: false,
                          onChanged: (_) async {
                            await taskStateProvider.updateTask(
                              taskId,
                              true,
                              pageId,
                            );
                          },
                        ),
                      ),
                    ).animate().fade(),
                  );
                }),
              ),
            if (completed.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: EnhancedCupertinoListSection.insetGrouped(
                  header: const Text('Completed'),
                  children: List.generate(completed.length, growable: false, (
                    index,
                  ) {
                    final task = completed[index];
                    final taskId = task["task_id"] as String;
                    final taskTitle = task["task"] as String;
                    return GestureDetector(
                      onLongPress: () => _showDeleteDialog(
                        context,
                        taskId,
                        taskTitle,
                        pageId,
                        true,
                      ),
                      child: EnhancedCupertinoListTile(
                        onTap: () async {
                          await taskStateProvider.updateTask(
                            taskId,
                            false,
                            pageId,
                          );
                        },
                        titleBuilder: (context) => Text(taskTitle),
                        leading: Transform.scale(
                          scale: 2,
                          child: CupertinoCheckbox(
                            value: true,
                            onChanged: (_) async {
                              await taskStateProvider.updateTask(
                                taskId,
                                false,
                                pageId,
                              );
                            },
                          ),
                        ),
                      ).animate().fade(),
                    );
                  }),
                ),
              ),
          ],
        );
      },
    );
  }
}
