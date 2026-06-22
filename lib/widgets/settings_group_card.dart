import 'package:flutter/cupertino.dart';

import 'package:gdvn/theme/app_theme.dart';

class SettingsGroupCard extends StatelessWidget {
  const SettingsGroupCard({
    required this.children,
    super.key,
    this.header,
    this.footer,
  });

  final String? header;
  final String? footer;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final palette = _SettingsPalette.fromContext(context);
    final sectionChildren = <Widget>[];

    for (var index = 0; index < children.length; index++) {
      sectionChildren.add(children[index]);
      if (index < children.length - 1) {
        sectionChildren.add(
          SizedBox(
            height: 0.5,
            child: ColoredBox(color: palette.separator),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              header!,
              style: TextStyle(
                color: palette.secondaryText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(18),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(children: sectionChildren),
          ),
        ),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(
              footer!,
              style: TextStyle(
                color: palette.secondaryText,
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
      ],
    );
  }
}

class SettingsRowTile extends StatelessWidget {
  const SettingsRowTile({
    required this.title,
    super.key,
    this.leading,
    this.subtitle,
    this.value,
    this.onTap,
    this.selected = false,
    this.showChevron = false,
  });

  final String title;
  final Widget? leading;
  final String? subtitle;
  final String? value;
  final VoidCallback? onTap;
  final bool selected;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final palette = _SettingsPalette.fromContext(context);
    final row = ConstrainedBox(
      constraints: BoxConstraints(minHeight: subtitle == null ? 56 : 72),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment:
              subtitle == null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: palette.primaryText,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: palette.secondaryText,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (value != null) ...[
              const SizedBox(width: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Text(
                  value!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: palette.secondaryText,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
            if (selected) ...[
              const SizedBox(width: 12),
              const Icon(
                CupertinoIcons.check_mark,
                color: Color(0xFF007AFF),
                size: 20,
              ),
            ],
            if (showChevron) ...[
              const SizedBox(width: 12),
              Icon(
                CupertinoIcons.chevron_forward,
                color: palette.secondaryText,
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );

    if (onTap == null) {
      return row;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: row,
    );
  }
}

class SettingsLeadingIcon extends StatelessWidget {
  const SettingsLeadingIcon({
    required this.icon,
    required this.backgroundColor,
    super.key,
    this.foregroundColor = CupertinoColors.white,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(9),
      ),
      child: SizedBox(
        width: 30,
        height: 30,
        child: Center(
          child: Icon(icon, color: foregroundColor, size: 18),
        ),
      ),
    );
  }
}

class _SettingsPalette {
  const _SettingsPalette({
    required this.surface,
    required this.separator,
    required this.primaryText,
    required this.secondaryText,
  });

  final Color surface;
  final Color separator;
  final Color primaryText;
  final Color secondaryText;

  factory _SettingsPalette.fromContext(BuildContext context) {
    final themeController = AppThemeScope.of(context);
    final brightness = themeController.effectiveBrightness(
      MediaQuery.maybePlatformBrightnessOf(context) ?? Brightness.light,
    );

    return brightness == Brightness.dark
        ? const _SettingsPalette(
            surface: Color(0xFF1C1C1E),
            separator: Color(0xFF38383A),
            primaryText: Color(0xFFF2F2F7),
            secondaryText: Color(0xFF8E8E93),
          )
        : const _SettingsPalette(
            surface: Color(0xFFFFFFFF),
            separator: Color(0xFFD1D1D6),
            primaryText: Color(0xFF1C1C1E),
            secondaryText: Color(0xFF8E8E93),
          );
  }
}