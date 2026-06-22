import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

class NavItemConfig {
  final IconData icon;
  final String label;
  final Widget page;
  final WidgetBuilder? headerTitleBuilder;

  const NavItemConfig({
    required this.icon,
    required this.label,
    required this.page,
    this.headerTitleBuilder,
  });
}

const int actionButtonIndex = 2;

class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onActionPressed;
  final List<NavItemConfig> leftItems;
  final List<NavItemConfig> rightItems;

  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onActionPressed,
    required this.leftItems,
    required this.rightItems,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final actionColor =
        theme.bottomNavigationBarStyle.itemStyle.iconStyle.base.color ??
        theme.colors.mutedForeground;

    return FBottomNavigationBar(
      index: selectedIndex,
      onChange: (index) {
        if (index == actionButtonIndex) {
          onActionPressed();
        } else {
          onItemSelected(index);
        }
      },
      children: [
        ...leftItems.map(
          (item) => FBottomNavigationBarItem(
            icon: Icon(item.icon),
            label: Text(item.label),
          ),
        ),
        FBottomNavigationBarItem(
          icon: SizedBox.square(
            dimension: 40,
            child: CustomPaint(
              painter: _TransparentPlusButtonPainter(color: actionColor),
            ),
          ),
          label: const SizedBox.shrink(),
        ),
        ...rightItems.map(
          (item) => FBottomNavigationBarItem(
            icon: Icon(item.icon),
            label: Text(item.label),
          ),
        ),
      ],
    );
  }

}

class _TransparentPlusButtonPainter extends CustomPainter {
  const _TransparentPlusButtonPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final center = bounds.center;
    final plusHalfLength = size.shortestSide * 0.17;
    final plusThickness = size.shortestSide * 0.055;
    final plusRadius = Radius.circular(plusThickness / 2);

    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: size.shortestSide / 2));

    final horizontalBar = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center,
            width: plusHalfLength * 2,
            height: plusThickness,
          ),
          plusRadius,
        ),
      );

    final verticalBar = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center,
            width: plusThickness,
            height: plusHalfLength * 2,
          ),
          plusRadius,
        ),
      );

    final plusPath = Path.combine(
      PathOperation.union,
      horizontalBar,
      verticalBar,
    );

    final buttonPath = Path.combine(
      PathOperation.difference,
      circlePath,
      plusPath,
    );

    canvas.drawPath(
      buttonPath,
      Paint()
        ..color = color
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(covariant _TransparentPlusButtonPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
