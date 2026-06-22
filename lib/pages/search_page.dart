import 'package:flutter/cupertino.dart';
import 'package:forui/forui.dart';

import 'package:gdvn/pages/about_page.dart';
import 'package:gdvn/pages/settings_page.dart';
import 'package:gdvn/widgets/top_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _controller;
  final List<String> _recentSearches = ['giao diện', 'forui', 'phiên bản'];

  static const List<_SearchEntry> _entries = [
    _SearchEntry(
      title: 'Cài đặt',
      subtitle: 'Đi tới các tùy chọn giao diện và hành vi ứng dụng.',
      icon: CupertinoIcons.gear_alt_fill,
      target: _SearchTarget.settings,
      keywords: ['cài đặt', 'settings', 'tùy chọn', 'giao diện'],
    ),
    _SearchEntry(
      title: 'Chế độ tối',
      subtitle: 'Mở cài đặt để chuyển sang giao diện tối.',
      icon: CupertinoIcons.moon_fill,
      target: _SearchTarget.settings,
      keywords: ['tối', 'dark', 'theme', 'giao diện'],
    ),
    _SearchEntry(
      title: 'Theo hệ thống',
      subtitle: 'Đồng bộ giao diện ứng dụng theo thiết bị.',
      icon: CupertinoIcons.device_phone_portrait,
      target: _SearchTarget.settings,
      keywords: ['system', 'hệ thống', 'thiết bị', 'giao diện'],
    ),
    _SearchEntry(
      title: 'Giới thiệu',
      subtitle: 'Xem thông tin tổng quan về ứng dụng và các điểm nhấn mới.',
      icon: CupertinoIcons.info_circle_fill,
      target: _SearchTarget.about,
      keywords: ['giới thiệu', 'about', 'thông tin', 'ứng dụng'],
    ),
    _SearchEntry(
      title: 'ForUI',
      subtitle:
          'Xem trang giới thiệu để biết giao diện đang dùng thành phần nào.',
      icon: CupertinoIcons.sparkles,
      target: _SearchTarget.about,
      keywords: ['forui', 'ui', 'component', 'giao diện'],
    ),
    _SearchEntry(
      title: 'Phiên bản ứng dụng',
      subtitle: 'Mở trang giới thiệu để xem phiên bản hiện tại.',
      icon: CupertinoIcons.number_circle_fill,
      target: _SearchTarget.about,
      keywords: ['version', 'phiên bản', 'build'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_handleQueryChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleQueryChanged)
      ..dispose();
    super.dispose();
  }

  void _handleQueryChanged() {
    setState(() {});
  }

  String get _query => _controller.text.trim().toLowerCase();

  List<_SearchEntry> get _results {
    if (_query.isEmpty) {
      return _entries;
    }

    return _entries.where((entry) => entry.matches(_query)).toList();
  }

  Future<void> _openTarget(_SearchTarget target) async {
    final trimmed = _controller.text.trim();
    if (trimmed.isNotEmpty) {
      _rememberQuery(trimmed);
    }

    final page = switch (target) {
      _SearchTarget.settings => const SettingsPage(),
      _SearchTarget.about => const AboutPage(),
    };

    await Navigator.of(
      context,
    ).push<void>(CupertinoPageRoute<void>(builder: (_) => page));
  }

  void _applyQuery(String value) {
    _controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    _rememberQuery(value);
  }

  void _rememberQuery(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final existingIndex = _recentSearches.indexWhere(
      (query) => query.toLowerCase() == trimmed.toLowerCase(),
    );

    setState(() {
      if (existingIndex != -1) {
        _recentSearches.removeAt(existingIndex);
      }

      _recentSearches.insert(0, trimmed);
      if (_recentSearches.length > 5) {
        _recentSearches.removeRange(5, _recentSearches.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return TopBar(
      title: 'Tìm kiếm',
      leadingAction: TopBarAction(
        icon: const Icon(CupertinoIcons.back),
        onTap: () => Navigator.maybePop(context),
        semanticsLabel: 'Quay lại',
      ),
      child: FScaffold(
        child: TopBarContent(
          child: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FTextField(
                    control: FTextFieldControl.managed(controller: _controller),
                    label: const Text('Tìm trong ứng dụng'),
                    hint: 'Cài đặt, giao diện, giới thiệu...',
                    description: const Text(
                      'Mở nhanh các điểm đến quan trọng ngay từ thanh tìm kiếm.',
                    ),
                    textInputAction: TextInputAction.search,
                    autofocus: true,
                    clearable: (value) => value.text.isNotEmpty,
                    prefixBuilder: (context, style, variants) =>
                        FTextField.prefixIconBuilder(
                          context,
                          style,
                          variants,
                          const Icon(FIcons.search),
                        ),
                    onSubmit: _rememberQuery,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FCard(
                    title: Text(
                      _query.isEmpty
                          ? 'Khám phá nhanh'
                          : '${results.length} kết quả phù hợp',
                    ),
                    subtitle: Text(
                      _query.isEmpty
                          ? 'Bắt đầu từ những từ khóa thường dùng nhất.'
                          : 'Đang lọc theo "${_controller.text.trim()}".',
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FBadge(child: const Text('Cài đặt')),
                            FBadge(
                              variant: .secondary,
                              child: const Text('Giới thiệu'),
                            ),
                            FBadge(
                              variant: .outline,
                              child: const Text('ForUI'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _QuickQueryButton(
                              label: 'giao diện',
                              onPress: () => _applyQuery('giao diện'),
                            ),
                            _QuickQueryButton(
                              label: 'cài đặt',
                              onPress: () => _applyQuery('cài đặt'),
                            ),
                            _QuickQueryButton(
                              label: 'forui',
                              onPress: () => _applyQuery('forui'),
                            ),
                            _QuickQueryButton(
                              label: 'phiên bản',
                              onPress: () => _applyQuery('phiên bản'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Kết quả gợi ý',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: results.isEmpty
                      ? FCard(
                          title: const Text('Không có kết quả'),
                          subtitle: const Text(
                            'Hãy thử những từ khóa gần hơn với Cài đặt hoặc Giới thiệu.',
                          ),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _QuickQueryButton(
                                label: 'cài đặt',
                                onPress: () => _applyQuery('cài đặt'),
                              ),
                              _QuickQueryButton(
                                label: 'giới thiệu',
                                onPress: () => _applyQuery('giới thiệu'),
                              ),
                            ],
                          ),
                        )
                      : FTileGroup(
                          children: results
                              .map(
                                (entry) => FTile(
                                  prefix: Icon(entry.icon),
                                  title: Text(entry.title),
                                  subtitle: Text(entry.subtitle),
                                  suffix: const Icon(FIcons.chevronRight),
                                  onPress: () => _openTarget(entry.target),
                                ),
                              )
                              .toList(),
                        ),
                ),
                if (_recentSearches.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Tìm gần đây',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _recentSearches
                          .map(
                            (query) => _QuickQueryButton(
                              label: query,
                              onPress: () => _applyQuery(query),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _SearchTarget { settings, about }

class _SearchEntry {
  final String title;
  final String subtitle;
  final IconData icon;
  final _SearchTarget target;
  final List<String> keywords;

  const _SearchEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.target,
    required this.keywords,
  });

  bool matches(String query) {
    if (query.isEmpty) {
      return true;
    }

    final haystacks = [title, subtitle, ...keywords];
    return haystacks.any((value) => value.toLowerCase().contains(query));
  }
}

class _QuickQueryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPress;

  const _QuickQueryButton({required this.label, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return FButton(
      variant: .outline,
      mainAxisSize: MainAxisSize.min,
      onPress: onPress,
      child: Text(label),
    );
  }
}
