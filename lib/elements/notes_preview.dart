import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/backend/database_functionality.dart';
import 'package:notes_app/backend/variables/notes.dart';
import 'package:notes_app/views/create_or_edit_note.dart';
import 'package:share_plus/share_plus.dart';

class NotesPreview extends StatelessWidget {
  final int id;
  final String title;
  final String content;
  final String createdAt;
  final String modifiedAt;
  final String? pinned;
  final Function(bool) callBackFunction;
  const new({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.modifiedAt,
    required this.pinned,
    required this.callBackFunction,
  });

  @override
  Widget build(BuildContext context) {
    IconData? pinnedIcon;
    if (pinned != null) {
      pinnedIcon = CupertinoIcons.pin;
    }
    final noteColor = CupertinoTheme.brightnessOf(context) == .dark
        ? CupertinoColors.black
        : CupertinoColors.systemBackground;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CupertinoContextMenu(
            actions: [
              CupertinoContextMenuAction(
                trailingIcon: pinned != null ? CupertinoIcons.pin_slash : CupertinoIcons.pin,
                child: Text(pinned != null ? "Unpin" : "Pin"),
                onPressed: () async {
                  String? pinTime;
                  if (pinned == null) {
                    pinTime = DateTime.now().toUtc().toIso8601String();
                  } else {
                    pinTime = null;
                  }
                  await DatabaseFunctionality().pinOrUnpinNote(
                    pinTime,
                    createdAt,
                    {
                      "title": title,
                      "content": content,
                      "created_at": createdAt,
                      "modified_at": modifiedAt,
                      "pinned": pinTime,
                    },
                  );
                  callBackFunction(true);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
              ),
              content.isEmpty
                  ? SizedBox.shrink()
                  : CupertinoContextMenuAction(
                      trailingIcon: CupertinoIcons.share,
                      child: Text("Share"),
                      onPressed: () {
                        SharePlus.instance.share(
                          .new(text: "$title\n\n$content"),
                        );
                        Navigator.pop(context);
                      },
                    ),
              content.isEmpty
                  ? SizedBox.shrink()
                  : CupertinoContextMenuAction(
                      isDestructiveAction: false,
                      trailingIcon: CupertinoIcons.doc_on_doc,
                      child: Text("Copy"),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: content));
                        Navigator.pop(context);
                      },
                    ),
              CupertinoContextMenuAction(
                isDestructiveAction: true,
                trailingIcon: CupertinoIcons.delete,
                child: Text("Delete Note"),
                onPressed: () async {
                  await DatabaseFunctionality().deleteANote(createdAt);
                  callBackFunction(true);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
              ),
            ],
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: noteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 2,
                  color: CupertinoTheme.brightnessOf(context) == .dark
                      ? const Color.fromARGB(255, 56, 56, 56)
                      : const Color.fromARGB(255, 208, 208, 212),
                ),
              ),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width - 16,
                child: CupertinoListTile(
                  trailing: Icon(pinnedIcon),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  onTap: () async {
                    final shouldRefresh = await Navigator.of(context)
                        .push<bool>(
                          CupertinoPageRoute(
                            builder: (context) {
                              return CreateOrEditNotePage(
                                id: id,
                                title: title,
                                content: content,
                                createdAt: createdAt,
                              );
                            },
                          ),
                        );
                    callBackFunction(shouldRefresh!);
                    if (context.mounted &&
                        shouldRefresh &&
                        Navigator.canPop(context)) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  },
                  title: title.isNotEmpty
                      ? Text(
                          title,
                          style: TextStyle(fontSize: 20, fontWeight: .bold),
                        )
                      : Text(
                          "Untitled",
                          style: TextStyle(
                            fontSize: 20,
                            fontStyle: .italic,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                  subtitle: content.isNotEmpty
                      ? Text(
                          content,
                          maxLines: 6,
                          overflow: .ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            color: CupertinoTheme.brightnessOf(context) == .dark
                                ? const Color.fromARGB(180, 255, 255, 255)
                                : const Color.fromARGB(180, 0, 0, 0),
                          ),
                          softWrap: true,
                        )
                      : null,
                ),
              ),
            ),
          ),
          notesData.last["created_at"] == createdAt
              ? SizedBox(height: 100)
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
