import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:material_ui/material_ui.dart' show Theme, Colors;
import 'package:notes_app/views/account_and_settings_page.dart';
import 'package:notes_app/views/notes_page.dart';
import 'package:notes_app/views/todo_page.dart';

class HomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final _minimize = GlassTabBarMinimizeController(
    
  //   behavior: GlassBarMinimizeBehavior.never,
  // );

  late final List<Widget> _screen;

  @override
  void initState() {
    _screen = [
      NotesPage(),
      TodoPage(),
      AccountAndSettingsPage(),
    ];
    super.initState();
  }

  @override
  void dispose() {
    // _minimize.dispose();
    super.dispose();
  }

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      // backgroundColor: const Color.fromARGB(0, 142, 142, 147),
      bottomBar: GlassTabBar.minimizable(
        innerBlur: 5,
        // settings: LiquidGlassSettings(bodyMode: .clear, ),
        // indicatorColor: const Color.fromARGB(32, 0, 0, 0),
        backgroundQuality: .minimal,
        platformViewBackdrop: true,
        // quality: .minimal,
        // maskingQuality: .off,
        
        // backgroundQuality: .minimal,
        // minimizeController: _minimize,
        // onMinimizedTabTap: _minimize.expand,

        selectedIconColor: CupertinoColors.activeBlue,

        selectedIndex: _selectedIndex,
        onTabSelected: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        tabs: const [
          GlassTab(icon: Icon(CupertinoIcons.create), label: 'Notes' ),
          GlassTab(icon: Icon(CupertinoIcons.list_bullet), label: 'Todos'),
          GlassTab(icon: Icon(CupertinoIcons.settings), label: 'Settings'),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _screen),
      // body: _screen[_selectedIndex],
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
