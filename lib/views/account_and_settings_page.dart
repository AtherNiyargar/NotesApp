import 'package:flutter/cupertino.dart';
import 'package:material_ui/material_ui.dart' show Colors;
import 'package:notes_app/backend/auh_service.dart';
import 'package:notes_app/backend/database_functionality.dart';

class AccountAndSettingsPage extends StatelessWidget {
  new({super.key});

  final DatabaseFunctionality databaseFunctionality = DatabaseFunctionality();

  @override
  Widget build(BuildContext context) {
    AuthService authService = .new();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: "Home",
        middle: Text("Account and Settings"),
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
                  TileElement(
                    onTap: () async {
                      await databaseFunctionality.deleteAllNotes();
                    },
                    color: Colors.redAccent,
                    leadingIcon: Icon(
                      CupertinoIcons.trash,
                      color: Colors.white,
                    ),
                    leadingText: "Delete all notes",
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
                      CupertinoIcons.person,
                      color: Colors.white,
                    ),
                    leadingText: "Delete Account",
                    trailingText: null,
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
