import 'package:flutter/cupertino.dart';
import 'package:material_ui/material_ui.dart' show Colors;
// import 'package:flutter/material.dart';
import 'package:notes_app/backend/auh_service.dart';

class AccountAndSettingsPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = .new();
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
                  TileElement(
                    onTap: () async {},
                    color: Colors.deepPurpleAccent,
                    leadingIcon: Icon(
                      CupertinoIcons.textformat_size,
                      color: Colors.white,
                    ),
                    leadingText: "Font size",
                    trailingText: "21",
                  ),
                  TileElement(
                    onTap: () async {},
                    color: Colors.grey,
                    leadingIcon: Icon(
                      CupertinoIcons.gear_solid,
                      color: Colors.white,
                    ),
                    leadingText: "Theme mode",
                    trailingText: "System default",
                  ),
                ],
              ),
              CupertinoFormSection(
                header: Text("Account Settings"),
                children: [
                  TileElement(
                    onTap: () async {},
                    color: Colors.blue,
                    leadingIcon: Icon(
                      CupertinoIcons.person,
                      color: Colors.white,
                    ),
                    leadingText: "Change name",
                    trailingText: "Ather Niyargar",
                  ),
                  TileElement(
                    onTap: () async {
                      await authService.signOut();
                      if (!context.mounted) return;
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                    color: Colors.orange,
                    leadingIcon: Icon(
                      CupertinoIcons.power,
                      color: Colors.white,
                    ),
                    leadingText: "Sign Out",
                    trailingText: null,
                  ),
                  TileElement(
                    color: Colors.red,
                    leadingIcon: Icon(
                      CupertinoIcons.delete,
                      color: Colors.white,
                    ),
                    leadingText: "Delete Account",
                    trailingText: null,
                  ),

                  // CupertinoListTile(
                  //   leadingSize: 35,
                  //   onTap: () {},
                  //   leading: Stack(
                  //     alignment: .center,
                  //     children: [
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(2),
                  //           color: Colors.blue,
                  //         ),
                  //       ),
                  //       Icon(CupertinoIcons.person, color: Colors.white),
                  //     ],
                  //   ),
                  //   title: Text("Change name"),

                  //   trailing: Row(
                  //     spacing: 5,
                  //     children: [
                  //       Text("Ather Niyargar"),
                  //       Icon(CupertinoIcons.chevron_right),
                  //     ],
                  //   ),
                  // ),
                  // CupertinoListTile(
                  //   leadingSize: 35,
                  //   onTap: () async {
                  //     await authService.signOut();
                  //     // if (!context.mounted) return;
                  //     // Navigator.popUntil(context, ModalRoute.withName('/'));
                  //   },
                  //   leading: Stack(
                  //     alignment: .center,
                  //     children: [
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(2),
                  //           color: Colors.orange,
                  //         ),
                  //       ),
                  //       Icon(CupertinoIcons.power, color: Colors.white),
                  //     ],
                  //   ),
                  //   title: Text("Sign Out"),

                  //   trailing: Row(
                  //     spacing: 5,
                  //     children: [
                  //       // Text("Ather Niyargar"),
                  //       Icon(CupertinoIcons.chevron_right),
                  //     ],
                  //   ),
                  // ),
                  // CupertinoListTile(
                  //   leadingSize: 35,
                  //   onTap: () {},
                  //   leading: Stack(
                  //     alignment: .center,
                  //     children: [
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(2),
                  //           color: Colors.red,
                  //         ),
                  //       ),
                  //       Icon(CupertinoIcons.delete, color: Colors.white),
                  //     ],
                  //   ),
                  //   title: Text("Delete Account"),

                  //   trailing: Row(
                  //     spacing: 5,
                  //     children: [
                  //       // Text("Delete Account"),
                  //       Icon(CupertinoIcons.chevron_right),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TileElement extends StatelessWidget {
  final Color color;
  final Widget leadingIcon;
  final String leadingText;
  final String? trailingText;
  final Future Function()? onTap;
  const new({
    super.key,
    required this.color,
    required this.leadingIcon,
    required this.leadingText,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      leadingSize: 35,
      onTap: onTap,
      leading: Stack(
        alignment: .center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: color,
            ),
          ),
          // Icon(CupertinoIcons.delete, color: Colors.white),
          leadingIcon,
        ],
      ),
      title: Text(leadingText),

      trailing: Row(
        spacing: 5,
        children: [
          Text(trailingText ?? ""),
          Icon(CupertinoIcons.chevron_right),
        ],
      ),
    );
  }
}
