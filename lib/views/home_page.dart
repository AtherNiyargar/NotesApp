import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:notes_app/views/account_and_settings_page.dart';
import 'package:notes_app/views/notes_page.dart';
import 'package:notes_app/views/todo_page.dart';

class HomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<Widget> _screens;

  @override
  void initState() {
    _screens = [NotesPage(), TodoPage(), AccountAndSettingsPage()];
    super.initState();
  }

  @override
  void dispose() {
    // _minimize.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == .dark;
    return LiquidGlassScaffold(
      bottomNavigationBar: LiquidGlassTabBar(
        style: const LiquidGlassStyle(
          shape: LiquidGlassShape.continuousRoundedRectangle(
            cornerRadius: 30,
            borderWidth: 3,
            lightIntensity: 0,
          ),
          appearance: LiquidGlassAppearance(
            color: Color.fromARGB(14, 0, 0, 0),
            blur: LiquidGlassBlur(sigmaX: 10, sigmaY: 10),
          ),
          refraction: LiquidGlassRefraction(chromaticAberration: 0),



        ),



        pillStyle: LiquidGlassTabPillStyle(
          growHeight: 4,
          distortionWidth: 9,
          distortion: 0.04
          // magnifierPill: LiquidGlassTabMagnifierPillStyle(enabled: true, magnification: 0)
        ),

        itemStyle: LiquidGlassTabItemStyle(
          selectedColor: CupertinoColors.activeBlue,
          unselectedColor: isDark
              ? CupertinoColors.white
              : CupertinoColors.black,
          iconSize: 24,
          underGlassIconSize: 21, // cancels the pill's magnification
          labelFontSize: 12,
          selectedFontWeight: FontWeight.w600,
        ),
        selectedIndex: _selectedIndex,
        onChanged: (value) => setState(() {
          _selectedIndex = value;
        }),
        items: [
          LiquidGlassTabBarItem(
            icon: CupertinoIcons.create,
            selectedIcon: CupertinoIcons.create_solid,

            label: 'Notes',
          ),
          LiquidGlassTabBarItem(
            icon: CupertinoIcons.list_bullet,
            selectedIcon: CupertinoIcons.list_bullet,
            label: 'Todos',
          ),
          LiquidGlassTabBarItem(
            icon: CupertinoIcons.settings,
            selectedIcon: CupertinoIcons.settings_solid,
            label: 'Settings',
          ),
        ],
      ),
      // bottomBar: GlassTabBar.minimizable(
      //   innerBlur: 5,
      //   backgroundQuality: .minimal,
      //   platformViewBackdrop: true,
      //   selectedIconColor: CupertinoColors.activeBlue,
      //   selectedIndex: _selectedIndex,
      //   onTabSelected: (value) {
      //     setState(() {
      //       _selectedIndex = value;
      //     });
      //   },
      //   tabs: const [
      //     GlassTab(icon: Icon(CupertinoIcons.create), label: 'Notes'),
      //     GlassTab(icon: Icon(CupertinoIcons.list_bullet), label: 'Todos'),
      //     GlassTab(icon: Icon(CupertinoIcons.settings), label: 'Settings'),
      //   ],
      // ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
    );
  }
}

class CreateOption extends StatelessWidget {
  final Icon icon;
  final String optionName;
  const new({super.key, required this.icon, required this.optionName});

  @override
  Widget build(BuildContext context) {
    final themeMode = CupertinoTheme.brightnessOf(context);
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Padding(padding: const EdgeInsets.only(left: 10), child: icon),
        Text(
          optionName,

          style: TextStyle(
            color: themeMode == .dark ? CupertinoColors.white : CupertinoColors.black,
            fontSize: 18,
          ),
        ),
        SizedBox(width: 30),
      ],
    );
  }
}
