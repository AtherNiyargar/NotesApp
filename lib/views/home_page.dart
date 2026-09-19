import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart' show Theme, Colors;
import 'package:notes_app/elements/notes_preview.dart';

class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SafeArea(
          child: CustomScrollView(
            // shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar.search(
                trailing: CupertinoButton(
                  sizeStyle: .small,
                  child: Icon(CupertinoIcons.person_crop_circle, size: 25),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/account_and_settings_page",
                      // PageTransition(type: .leftToRight,
                      // curve: Curves.linearToEaseOut,
                      // duration: Duration(milliseconds: 400),
                      // child: AccountPage()
                      // ),
                      // CupertinoPageRoute(
                      //   // title: "Accounts",
                      //   // fullscreenDialog: true,
                      //   // barrierDismissible: true,
                      //   // settings: RouteSettings(

                      //   // ),
                      //   maintainState: false,
                      //   builder: (context) {
                      //     return AccountPage();
                      //   },
                      // ),
                    );
                  },
                ),
                // trailing:
                searchField: CupertinoSearchTextField(
                  // placeholder: searchIsActive ? 'Enter search text' : 'Search',
                  onChanged: (String value) {},
                ),

                largeTitle: Text("Notes App"),
                bottomMode: .always,
              ),

              SliverFillRemaining(
                // fillOverscroll: true,
                // hasScrollBody: true,
                // child: Stack(
                //   children: [
                child: Column(
                  // mainAxisAlignment: .start,
                  // crossAxisAlignment: .start,
                  children: [
                    Row(
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
                          onPressed: () {},
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
                                  // CupertinoActionSheetAction(onPressed: () {}, child: Icon(CupertinoIcons.add_circled)),
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      // Navigator.of(
                                      //   context,
                                      // ).pushNamedAndRemoveUntil(
                                      //   "/create_page_route",
                                      //   (_) => false,
                                      //   // (route) => CreateNotePage(),
                                      //   // CupertinoPageRoute(builder: (context) {
                                      //   //   return CreateNotePage();
                                      //   // },)
                                      // );
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                        context,
                                        "/create_note_page",
                                      );
                                    },
                                    child: const CreateOption(
                                      icon: Icon(CupertinoIcons.textformat),
                                      optionName: "Note",
                                    ),
                                  ),

                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                        context,
                                        "/todo_page",
                                      );
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
                    Expanded(
                      child: ListView.builder(
                        // padding: EdgeInsets.all(value),
                        // physics: NeverScrollableScrollPhysics(),
                        // shrinkWrap: true,
                        itemCount: 10,
                        // padding: EdgeInsets.symmetric(vertical: 10),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: NotesPreview(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // Positioned(
                //   bottom: 20,
                //   right: 20,
                //   child: LiquidGlassLayer(
                //     child: LiquidGlass.withOwnLayer(
                //       fake: true,
                //       settings: LiquidGlassSettings(
                //         ambientStrength: 999,
                //         blur: 3,
                //         lightIntensity: 1,
                //         refractiveIndex: 1.2,
                //         saturation: 50,
                //         thickness: 100,
                //         visibility: 0.7,
                //         glassColor: themeMode == .dark
                //             ? Colors.transparent
                //             : Color.fromARGB(255, 98, 88, 88),
                //       ),

                //       shape: LiquidRoundedSuperellipse(borderRadius: 25),
                //       glassContainsChild: true,
                //       child: GestureDetector(
                //         behavior: .opaque,
                // onTap: () => showCupertinoModalPopup(
                //   semanticsDismissible: true,
                //   barrierDismissible: true,
                //   useRootNavigator: true,

                //   context: context,
                //   builder: (context) => CupertinoActionSheet(
                //     title: Text("Create"),

                //     actions: [
                //       // CupertinoActionSheetAction(onPressed: () {}, child: Icon(CupertinoIcons.add_circled)),
                //       CupertinoActionSheetAction(
                //         onPressed: () {
                //           // Navigator.of(
                //           //   context,
                //           // ).pushNamedAndRemoveUntil(
                //           //   "/create_page_route",
                //           //   (_) => false,
                //           //   // (route) => CreateNotePage(),
                //           //   // CupertinoPageRoute(builder: (context) {
                //           //   //   return CreateNotePage();
                //           //   // },)
                //           // );
                //           Navigator.pop(context);
                //           Navigator.pushNamed(
                //             context,
                //             "/create_note_page",
                //           );
                //         },
                //         child: const CreateOption(
                //           icon: Icon(CupertinoIcons.textformat),
                //           optionName: "Note",
                //         ),
                //       ),

                //       CupertinoActionSheetAction(
                //         onPressed: () {},
                //         child: const CreateOption(
                //           icon: Icon(CupertinoIcons.list_number),
                //           optionName: "Todo list",
                //         ),
                //       ),
                //       CupertinoActionSheetAction(
                //         onPressed: () {},
                //         child: const CreateOption(
                //           icon: Icon(CupertinoIcons.mic),
                //           optionName: "Transcribe",
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                //         child: SizedBox.square(
                //           dimension: 70,
                //           child: Icon(
                //             CupertinoIcons.create,
                //             size: 30,
                //             color: themeMode == .dark
                //                 ? CupertinoColors.activeBlue
                //                 : Colors.white,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                //   ],
                // ),
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
