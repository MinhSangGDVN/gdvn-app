import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

class PageBackButton extends StatelessWidget {
  const PageBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = FTheme.of(context).colors;

    return Semantics(
      button: true,
      label: 'Quay lại',
      child: GestureDetector(
        onTap: () => Navigator.maybePop(context),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.card,
            shape: BoxShape.circle,
            border: Border.all(color: colors.border),
          ),
          child: const SizedBox.square(
            dimension: 44,
            child: Center(child: Icon(FIcons.arrowLeft, size: 24)),
          ),
        ),
      ),
    );
  }
}
