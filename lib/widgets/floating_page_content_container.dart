import 'package:flutter/widgets.dart';

const double floatingPageContentHorizontalInset = 16;

class PageContentContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const PageContentContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(
      horizontal: floatingPageContentHorizontalInset,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}