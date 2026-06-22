import 'package:flutter/cupertino.dart';
import 'package:forui/forui.dart';

import 'package:gdvn/pages/about_page.dart';
import 'package:gdvn/pages/dashboard_page.dart';
import 'package:gdvn/widgets/top_bar.dart';
import 'package:gdvn/pages/list_page.dart';
import 'package:gdvn/pages/me_page.dart';
import 'package:gdvn/pages/notification_page.dart';
import 'package:gdvn/pages/search_page.dart';
import 'package:gdvn/sheets/submit_level_challenge_sheet.dart';
import 'package:gdvn/sheets/submit_record_sheet.dart';
import 'package:gdvn/widgets/action_bottom_sheet.dart';
import 'package:gdvn/widgets/app_bottom_nav_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  final ValueNotifier<ListPageVariant> _listVariant = ValueNotifier(
    ListPageVariant.classic,
  );

  late final List<NavItemConfig> _leftItems = [
    const NavItemConfig(
      icon: FIcons.layoutDashboard,
      label: 'Trang chủ',
      page: DashboardPage(),
    ),
    NavItemConfig(
      icon: FIcons.list,
      label: 'List',
      page: ListPage(variantListenable: _listVariant),
      headerTitleBuilder: (_) =>
          ListPageHeaderVariantSwitcher(controller: _listVariant),
    ),
  ];

  late final List<NavItemConfig> _rightItems = [
    const NavItemConfig(
      icon: FIcons.bell,
      label: 'Thông báo',
      page: NotificationPage(),
    ),
    const NavItemConfig(icon: FIcons.user, label: 'Tôi', page: MePage()),
  ];

  late final List<NavItemConfig> _allItems = [..._leftItems, ..._rightItems];

  late final _navigatorKeys = List.generate(
    _allItems.length,
    (_) => GlobalKey<NavigatorState>(),
  );

  late final _observers = List.generate(
    _allItems.length,
    (i) => _TabNavigatorObserver(onChanged: () => _onTabChanged(i)),
  );

  late final _canPops = List.filled(_allItems.length, false);

  /// Maps the bottom nav [_selectedIndex] (which includes the action button slot)
  /// to a 0-based tab index into [_allItems].
  int get _tabIndex =>
      _selectedIndex < actionButtonIndex ? _selectedIndex : _selectedIndex - 1;

  bool get _currentCanPop => _canPops[_tabIndex];

  NavigatorState? get _currentNavigator =>
      _navigatorKeys[_tabIndex].currentState;

  void _onTabChanged(int tabIndex) {
    final canPop = _navigatorKeys[tabIndex].currentState?.canPop() ?? false;
    if (_canPops[tabIndex] != canPop) {
      setState(() => _canPops[tabIndex] = canPop);
    }
  }

  Future<void> _pushOnCurrentNavigator(Widget page) async {
    final navigator = _currentNavigator;
    if (navigator == null) {
      return;
    }

    await navigator.push<void>(CupertinoPageRoute<void>(builder: (_) => page));
  }

  Future<void> _openAboutPage() => _pushOnCurrentNavigator(const AboutPage());

  Future<void> _openSearchPage() => _pushOnCurrentNavigator(const SearchPage());

  Future<void> _openSidebar() async {
    final destination = await showFSheet<_SidebarDestination>(
      context: context,
      side: FLayout.ltr,
      useSafeArea: false,
      draggable: true,
      mainAxisMaxRatio: 0.9,
      builder: (sheetContext) =>
          _AppSidebar(width: MediaQuery.sizeOf(sheetContext).width * 0.9),
    );

    if (!mounted || destination == null) {
      return;
    }

    switch (destination) {
      case _SidebarDestination.about:
        await _openAboutPage();
    }
  }

  Future<void> _handleActionPressed() async {
    final action = await showActionBottomSheet(context);
    if (!mounted || action == null) {
      return;
    }

    switch (action) {
      case ActionBottomSheetDestination.submitRecord:
        await showSubmitRecordSheet(context);
      case ActionBottomSheetDestination.submitLevelChallenge:
        await showSubmitLevelChallengeSheet(context);
    }
  }

  @override
  void dispose() {
    _listVariant.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_currentCanPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _navigatorKeys[_tabIndex].currentState?.maybePop();
        }
      },
      child: FScaffold(
        childPad: false,
        footer: AppBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemSelected: (index) => setState(() => _selectedIndex = index),
          onActionPressed: _handleActionPressed,
          leftItems: _leftItems,
          rightItems: _rightItems,
        ),
        child: IndexedStack(
          index: _tabIndex,
          children: List.generate(_allItems.length, (i) {
            final item = _allItems[i];

            return Navigator(
              key: _navigatorKeys[i],
              observers: [_observers[i]],
              onGenerateRoute: (settings) => CupertinoPageRoute<void>(
                settings: settings,
                builder: (context) => TopBar(
                  title: item.headerTitleBuilder == null ? item.label : null,
                  titleDropdown: item.headerTitleBuilder?.call(context),
                  leadingAction: TopBarAction(
                    icon: const Icon(FIcons.menu),
                    onTap: _openSidebar,
                    semanticsLabel: 'Mở menu',
                  ),
                  rightButtonIcon: const Icon(FIcons.search),
                  rightButtonAction: _openSearchPage,
                  child: FScaffold(child: item.page),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _TabNavigatorObserver extends NavigatorObserver {
  final VoidCallback onChanged;

  _TabNavigatorObserver({required this.onChanged});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      onChanged();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      onChanged();

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      onChanged();

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      onChanged();
}

enum _SidebarDestination { about }

class _AppSidebar extends StatelessWidget {
  final double width;

  const _AppSidebar({required this.width});

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.viewPaddingOf(context);

    return FSidebar(
      style: FSidebarStyleDelta.delta(
        constraints: BoxConstraints.tightFor(width: width),
        headerPadding: EdgeInsetsGeometryDelta.value(
          EdgeInsets.fromLTRB(0, viewPadding.top + 8, 0, 0),
        ),
        footerPadding: EdgeInsetsGeometryDelta.value(
          EdgeInsets.fromLTRB(0, 0, 0, viewPadding.bottom + 8),
        ),
      ),
      header: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GDVN',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4),
          Text('Đi tới những mục chính của ứng dụng.'),
        ],
      ),
      children: [
        FSidebarGroup(
          label: const Text('Điều hướng'),
          children: [
            FSidebarItem(
              icon: const Icon(CupertinoIcons.info_circle_fill),
              label: const Text('Giới thiệu'),
              onPress: () =>
                  Navigator.of(context).pop(_SidebarDestination.about),
            ),
          ],
        ),
      ],
    );
  }
}
