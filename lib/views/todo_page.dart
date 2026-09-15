import 'package:cupertino_lists_enhanced/list_section.dart';
import 'package:cupertino_lists_enhanced/list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// https://www.reddit.com/r/whatsapp/s/qYjCiG2At3

final List<String> completedTasks = [];

final List<String> inCompletedTasks = [
  "BGMI Rank Push",
  "Doom Scrolling",
  "Goon on goth mommy",
  "Get a life",
  "Steal hot-ass neighbour's underwear",
  "Hate LGBTQ",
  "Thank god for not making me israel dih sucker",
  "Survive in office",
  "Defend hitler on a random reddit forum",
  "Visit basement and roleplay lord jeffery epstine 🛐",
];

class UIRefresh extends ChangeNotifier {
  static final UIRefresh _instance = UIRefresh._internal();
  factory UIRefresh() {
    return _instance;
  }
  UIRefresh._internal();

  void updateUI() {
    notifyListeners();
  }
}

class TodoPage extends StatelessWidget {
  new({super.key});
  final UIRefresh uiRefresh = UIRefresh();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Todos"),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
        ),
        trailing: CupertinoButton(
          sizeStyle: .medium,
          child: Icon(CupertinoIcons.add, size: 25),
          onPressed: () {
            Navigator.pushNamed(context, "/create_todo_page");
            // showCupertinoDialog(
            //   barrierDismissible: true,
            //   context: context,
            //   builder: (context) {
            //     return CupertinoAlertDialog(
            //       title: Text("Create Task"),

            //       content: Padding(
            //         padding: const EdgeInsets.only(top: 15),
            //         child: CupertinoTextField(
            //           // decoration: InputDecoration(),

            //           padding: EdgeInsetsGeometry.only(top: 20),
            //         ),
            //       ),

            //       // content: Text("You cannot undo this action"),
            //       actions: [
            //         CupertinoDialogAction(
            //           isDefaultAction: true,

            //           // isDestructiveAction: true,
            //           child: Text("Cancel"),
            //           onPressed: () => Navigator.pop(context),
            //         ),

            //         CupertinoDialogAction(
            //           // isDefaultAction: true,

            //           isDestructiveAction: true,
            //           child: Text("Delete"),
            //           onPressed: () => Navigator.pop(context),
            //         ),
            //       ],
            //     );
            //   },
            // );
          },
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ListenableBuilder(
              listenable: uiRefresh,
              builder: (context, child) => Column(
                children: [
                  inCompletedTasks.isNotEmpty
                      ? InCompletedTasks()
                      : SizedBox.shrink(),
                  completedTasks.isNotEmpty
                      ? CompletedTasks()
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InCompletedTasks extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return EnhancedCupertinoListSection.insetGrouped(
      header: const Text('TODO'),
      children: List.generate(
        growable: false,
        inCompletedTasks.length,
        (index) => GestureDetector(
          onLongPress: () {
            // print("=========");
            showCupertinoDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text("Do you want to delete this\ntask?"),

                  content: Text("You cannot undo this action"),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,

                      // isDestructiveAction: true,
                      child: Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),

                    CupertinoDialogAction(
                      // isDefaultAction: true,

                      isDestructiveAction: true,
                      child: Text("Delete"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              },
            );
          },
          child: FalseCheckBoxElement(
            todoName: inCompletedTasks[index],
            isCompleted: false,
            position: index,
          ).animate().fade(),
        ),
      ),
    );
  }
}

class CompletedTasks extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return EnhancedCupertinoListSection.insetGrouped(
      header: const Text('Completed'),
      children: List.generate(
        growable: false,
        completedTasks.length,
        (index) => GestureDetector(
          onLongPress: () => showCupertinoDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text("Do you want to delete this\ntask?"),

                content: Text("You cannot undo this action"),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,

                    // isDestructiveAction: true,
                    child: Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),

                  CupertinoDialogAction(
                    // isDefaultAction: true,

                    isDestructiveAction: true,
                    child: Text("Delete"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            },
          ),
          child: TrueCheckBoxElement(
            todoName: completedTasks[index],
            isCompleted: true,
            position: index,
          ).animate().fade(),
        ),
      ),
    );
  }
}

class TrueCheckBoxElement extends StatelessWidget {
  final String todoName;
  final bool isCompleted;
  final int position;
  const new({
    super.key,
    required this.todoName,
    required this.isCompleted,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    UIRefresh uiRefresh = UIRefresh();
    return EnhancedCupertinoListTile(
      onTap: () {
        inCompletedTasks.add(todoName);
        completedTasks.removeAt(position);
        uiRefresh.updateUI();
      },

      titleBuilder: (context) => Text(todoName),

      leading: Transform.scale(
        scale: 2,
        child: CupertinoCheckbox(
          value: isCompleted,
          onChanged: (_) {
            inCompletedTasks.add(todoName);
            completedTasks.removeAt(position);
            uiRefresh.updateUI();
          },
        ),
      ),
    );
  }
}

class FalseCheckBoxElement extends StatelessWidget {
  final String todoName;
  final bool isCompleted;
  final int position;

  const new({
    super.key,
    required this.todoName,
    required this.isCompleted,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    UIRefresh uiRefresh = UIRefresh();
    return EnhancedCupertinoListTile(
      onTap: () {
        completedTasks.add(todoName);
        inCompletedTasks.removeAt(position);
        uiRefresh.updateUI();
      },
      titleBuilder: (context) => Text(todoName),
      leading: Transform.scale(
        scale: 2,
        child: CupertinoCheckbox(
          value: isCompleted,
          onChanged: (_) {
            completedTasks.add(todoName);
            inCompletedTasks.removeAt(position);
            uiRefresh.updateUI();
          },
        ),
      ),
    );
  }
}
