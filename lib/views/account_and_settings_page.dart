import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:notes_app/backend/auh_service.dart';
import 'package:notes_app/backend/database_functionality.dart';
import 'package:notes_app/backend/sync_todos_service.dart';
import 'package:notes_app/elements/show_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountAndSettingsPage extends StatefulWidget {
  const new({super.key});

  @override
  State<AccountAndSettingsPage> createState() => _AccountAndSettingsPageState();
}

class _AccountAndSettingsPageState extends State<AccountAndSettingsPage> {
  // late final DatabaseFunctionality databaseFunctionality;
  SharedPreferences? _prefs;
  bool _isLoading = true;

  late final AuthService authService;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    authService = .new();
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;
    setState(() {
      _prefs = prefs;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            transitionBetweenRoutes: false,
            largeTitle: Text("Settings"),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                CupertinoFormSection(
                  header: Text("Account Settings"),
                  children: [
                    TileElement(
                      onTap: () async {
                        final navigator = Navigator.of(
                          context,
                          rootNavigator: true,
                        );

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
                      color: CupertinoColors.activeOrange,
                      leadingIcon: Icon(
                        CupertinoIcons.power,
                        color: CupertinoColors.white,
                      ),
                      leadingText: "Sign Out",
                      trailingText: null,
                    ),

                    TileElement(
                      onTap: () async {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: Text("Refreshing data from the server"),
                            content: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                        );
                        try {
                          await SyncTodosService().refresAppDataFromServer();
                        } finally {
                          if (context.mounted) {
                            Navigator.maybePop(context);
                          }
                        }
                      },
                      color: CupertinoColors.activeGreen,
                      leadingIcon: Icon(
                        CupertinoIcons.cloud_download,
                        color: CupertinoColors.white,
                      ),
                      leadingText: "Refresh content from server",
                      trailingText: null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
  final Widget? rightMostWidget;
  const new({
    super.key,
    required this.color,
    required this.leadingIcon,
    required this.leadingText,
    this.trailingText,
    this.onTap,
    this.rightMostWidget,
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
          rightMostWidget ?? Icon(CupertinoIcons.chevron_right),
        ],
      ),
    );
  }
}
