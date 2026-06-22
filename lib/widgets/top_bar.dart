import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

const double topBarHeight = 44;
const double topBarHorizontalInset = 12;
const double topBarSpacing = 10;
const double topBarBottomSpacing = 18;

double topBarContentTopPadding(
  BuildContext context, {
  double bottomSpacing = topBarBottomSpacing,
  double height = topBarHeight,
}) {
  final viewPadding = MediaQuery.viewPaddingOf(context);
  return viewPadding.top + height + bottomSpacing;
}

class TopBarContent extends StatelessWidget {
  final Widget child;
  final double bottomSpacing;
  final double height;

  const TopBarContent({
    super.key,
    required this.child,
    this.bottomSpacing = topBarBottomSpacing,
    this.height = topBarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: topBarContentTopPadding(
          context,
          bottomSpacing: bottomSpacing,
          height: height,
        ),
      ),
      child: child,
    );
  }
}

class TopBarAction {
  final Widget icon;
  final VoidCallback onTap;
  final String? semanticsLabel;

  const TopBarAction({
    required this.icon,
    required this.onTap,
    this.semanticsLabel,
  });
}

class TopBar extends StatelessWidget {
  final Widget child;
  final TopBarAction? leadingAction;
  final Widget? rightButtonIcon;
  final VoidCallback? rightButtonAction;
  final String? title;
  final Widget? titleDropdown;

  const TopBar({
    super.key,
    required this.child,
    this.leadingAction,
    this.rightButtonIcon,
    this.rightButtonAction,
    this.title,
    this.titleDropdown,
  }) : assert(
         title == null || titleDropdown == null,
         'Provide either title or titleDropdown, not both.',
       );

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final colors = FTheme.of(context).colors;
    final titleStyle = TextStyle(
      color: colors.foreground,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
    );
    final resolvedTitle =
        titleDropdown ?? (title == null ? null : Text(title!));

    return Stack(
      children: [
        child,
        Positioned(
          top: viewPadding.top,
          left: topBarHorizontalInset,
          right: topBarHorizontalInset,
          child: SizedBox(
            height: topBarHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _TopBarActionSlot(
                      action: leadingAction,
                      backgroundColor: colors.card,
                      borderColor: colors.border,
                      iconColor: colors.foreground,
                    ),
                    _TopBarIconSlot(
                      icon: rightButtonIcon,
                      onTap: rightButtonAction,
                      backgroundColor: colors.card,
                      borderColor: colors.border,
                      iconColor: colors.foreground,
                    ),
                  ],
                ),
                if (resolvedTitle != null)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: topBarHeight + topBarSpacing,
                    ),
                    child: Center(
                      child: DefaultTextStyle(
                        style: titleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        child: IconTheme(
                          data: IconThemeData(
                            color: colors.foreground,
                            size: 14,
                          ),
                          child: resolvedTitle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TopBarActionSlot extends StatelessWidget {
  final TopBarAction? action;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;

  const _TopBarActionSlot({
    required this.action,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final action = this.action;
    if (action == null) {
      return const SizedBox.square(dimension: topBarHeight);
    }

    return _TopBarButton(
      icon: action.icon,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      iconColor: iconColor,
      onTap: action.onTap,
      semanticsLabel: action.semanticsLabel,
    );
  }
}

class _TopBarIconSlot extends StatelessWidget {
  final Widget? icon;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;

  const _TopBarIconSlot({
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    if (icon == null) {
      return const SizedBox.square(dimension: topBarHeight);
    }

    return _TopBarButton(
      icon: icon,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      iconColor: iconColor,
      onTap: onTap,
    );
  }
}

class _TopBarButton extends StatelessWidget {
  final Widget icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  const _TopBarButton({
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.onTap,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: topBarHeight,
          height: topBarHeight,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor),
          ),
          child: Center(
            child: IconTheme(
              data: IconThemeData(color: iconColor, size: 18),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
