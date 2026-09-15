import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    // final theme = CupertinoTheme.brightnessOf(context);
    return CupertinoPageScaffold(
      // backgroundColor: theme == .light
      //     ? CupertinoContextMenu.kBackgroundColor
      //     : CupertinoColors.black,
      // physics: NeverScrollableScrollPhysics(),
      navigationBar: CupertinoNavigationBar(
        middle: Text("Account and Settings"),

        // largeTitle: Text("Settings"),
        // stretch: true,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CupertinoFormSection(
                header: Text("App Settings"),
                children: [
                  CupertinoListTile(
                    leadingSize: 35,
                    onTap: () {},
                    leading: Stack(
                      alignment: .center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.orange,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.textformat_size,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    title: Text("Font size"),

                    trailing: Row(
                      spacing: 5,
                      children: [
                        Text("21"),
                        Icon(CupertinoIcons.chevron_right),
                      ],
                    ),
                  ),
                  CupertinoListTile(
                    leadingSize: 35,
                    onTap: () {},
                    leading: Stack(
                      alignment: .center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.grey,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.gear_solid,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    title: Text("Theme mode"),

                    trailing: Row(
                      spacing: 5,
                      children: [
                        Text("System default"),
                        Icon(CupertinoIcons.chevron_right),
                      ],
                    ),
                  ),
                ],
              ),
              CupertinoFormSection(
                header: Text("Account Settings"),
                children: [
                  CupertinoListTile(
                    leadingSize: 35,
                    onTap: () {},
                    leading: Stack(
                      alignment: .center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.blue,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.person,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    title: Text("Change name"),

                    trailing: Row(
                      spacing: 5,
                      children: [
                        Text("Ather Niyargar"),
                        Icon(CupertinoIcons.chevron_right),
                      ],
                    ),
                  ),
                  CupertinoListTile(
                    leadingSize: 35,
                    onTap: () {},
                    leading: Stack(
                      alignment: .center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.red,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.delete,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    title: Text("Delete Account"),

                    trailing: Row(
                      spacing: 5,
                      children: [
                        // Text("Delete Account"),
                        Icon(CupertinoIcons.chevron_right),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
