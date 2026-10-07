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
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          transitionBetweenRoutes: false,
          largeTitle: Text("Settings"),
        ),
        SliverToBoxAdapter(
          child: CupertinoFormSection(
            header: Text("Account Settings"),
            children: [
              TileElement(
                onTap: () async {
                  final navigator = Navigator.of(context, rootNavigator: true);

                  showCupertinoDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return const CupertinoAlertDialog(
                        title: Column(
                          children: [
                            Text("Signing Out"),
                            SizedBox(height: 20),
                            CupertinoActivityIndicator(),
                          ],
                        ),
                      );
                    },
                  );

                  await DatabaseFunctionality().deleteAllTables();
                  await authService.signOut();

                  if (navigator.mounted) {
                    navigator.pop(); // close Signing Out dialog
                  }
                },
                color: Colors.orange,
                leadingIcon: Icon(CupertinoIcons.power, color: Colors.white),
                leadingText: "Sign Out",
                trailingText: null,
              ),
            ],
          ),
        ),
      ],
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
