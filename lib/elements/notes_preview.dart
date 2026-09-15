import 'package:flutter/cupertino.dart';

class NotesPreview extends StatelessWidget {
  const new({super.key});

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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: CupertinoListTile(
          // padding: EdgeInsets.all(8),
          title: Text(
            "Project",
            style: TextStyle(fontSize: 20, fontWeight: .bold),
          ),
          subtitle: Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip",

            maxLines: 6,

            overflow: .ellipsis,
            style: TextStyle(
              fontSize: 20,
              color: CupertinoTheme.brightnessOf(context) == .dark
                  ? const Color.fromARGB(180, 255, 255, 255)
                  : const Color.fromARGB(180, 0, 0, 0),
            ),
            softWrap: true,
          ),
        ),
      ),
    );
  }
}
