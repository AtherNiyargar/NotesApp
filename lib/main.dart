import 'package:flutter/cupertino.dart';
import 'package:notes_app/views/account_page.dart';
import 'package:notes_app/views/create_note.dart';
import 'package:notes_app/views/create_todo_page.dart';
import 'package:notes_app/views/home_page.dart';
import 'package:notes_app/views/todo_page.dart';

void main() {
  runApp(
    // MainApp()
    CupertinoApp(
      initialRoute: "/",
      routes: {
        "/": (_) => HomePage(),
        "/create_note_page": (_) => CreateNotePage(),
        "/todo_page" :(_) => TodoPage(),
        "/create_todo_page":(_) => CreateTodoPage(),
        "/account_page": (_) => AccountPage()

      },
      debugShowCheckedModeBanner: false,
    ),
  );
}
/*
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return CupertinoApp(
      theme: CupertinoThemeData(),
      title: "Notes App",
      home: SafeArea(
        child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: [
              BottomNavigationBarItem(icon: Icon(CupertinoIcons.home)),
              BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings)),
            ],
          ),
          tabBuilder: (context, index) => CupertinoPageScaffold(
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  CupertinoSliverNavigationBar(
                    // middle: Text("`data`"),
                    bottom: PreferredSize(
                      preferredSize: Size(0, 20),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 20,
                            bottom: 20,
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                              },
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: CupertinoColors.activeBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.add,
                                  color: CupertinoColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    bottomMode: .always,
                    stretch: true,

                    leading: CupertinoButton(
                      focusNode: FocusNode(),
                      alignment: .center,
                      padding: EdgeInsets.all(16),
                      minimumSize: Size(40, 40),

                      onPressed: () {},
                      sizeStyle: .small,
                      child: Icon(CupertinoIcons.add_circled, size: 30),
                    ),

                    trailing: CupertinoButton(
                      focusNode: FocusNode(),
                      alignment: .center,
                      padding: EdgeInsets.all(16),
                      minimumSize: Size(40, 40),

                      onPressed: () {
                      },
                      sizeStyle: .small,
                      child: Icon(CupertinoIcons.add_circled, size: 30),
                    ),
                    largeTitle: Text("Notes App"),
                  ),
                  SliverFillRemaining(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(16),
                      itemCount: 25,

                      itemBuilder: (context, index) {
                        return CupertinoListTile(
                          title: Text("data"),
                          additionalInfo: Text("data"),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateOption extends StatelessWidget {
  final Icon icon;
  final Text text;
  const new({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Padding(padding: const EdgeInsets.only(left: 10), child: icon),
          text,
          SizedBox(width: 30),
        ],
      ),
    );
  }
}
*/
