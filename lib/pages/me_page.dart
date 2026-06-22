import 'package:flutter/cupertino.dart';
import 'package:forui/forui.dart';

import 'package:gdvn/pages/settings_page.dart';
import 'package:gdvn/widgets/page_content_container.dart';
import 'package:gdvn/widgets/top_bar.dart';
import 'package:gdvn/widgets/settings_group_card.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  void _openSettings(BuildContext context) {
    Navigator.of(context).push<void>(
      CupertinoPageRoute<void>(builder: (context) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TopBarContent(
      child: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            PageContentContainer(
              child: FTileGroup(
                children: [
                  FTile(
                    prefix: SettingsLeadingIcon(
                      icon: CupertinoIcons.gear_alt_fill,
                      backgroundColor: Color(0xFF8E8E93),
                    ),
                    title: const Text('Cài đặt'),
                    subtitle: const Text('Giao diện và các tuỳ chọn ứng dụng'),
                    suffix: const Icon(FIcons.chevronRight),
                    onPress: () => _openSettings(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
