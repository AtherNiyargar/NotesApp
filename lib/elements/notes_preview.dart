import 'package:flutter/cupertino.dart';
import 'package:notes_app/views/create_or_edit_note.dart';

class NotesPreview extends StatelessWidget {
  final String title;
  final String content;
  final int id;
  final Function(bool) callBackFunction;
  const new({
    super.key,
    required this.title,
    required this.content,
    required this.id,
    required this.callBackFunction,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
    
        border: Border.all(
          width: 2,
          color: CupertinoTheme.brightnessOf(context) == .dark
              ? const Color.fromARGB(255, 56, 56, 56)
              : const Color.fromARGB(255, 208, 208, 212),
        ),
      ),
      child: CupertinoListTile(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        onTap: () async {
          final shouldRefresh = await Navigator.of(context).push<bool>(
            CupertinoPageRoute(
              builder: (context) {
                return CreateOrEditNotePage(
                id: id,
                title: title,
                content: content,
              );
              },
            ),
          );
          // if (shouldRefresh) {
            callBackFunction(shouldRefresh!);
          // }
          // if (_shouldRefresh) {
          //   shouldRefresh(true);
          // } else {
          
          // }
        },
        title: title.isNotEmpty
            ? Text(title, style: TextStyle(fontSize: 20, fontWeight: .bold))
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
    );
  }
}
