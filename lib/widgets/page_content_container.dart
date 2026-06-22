import 'package:flutter/widgets.dart';

const double pageContentHorizontalInset = 0;

class PageContentContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const PageContentContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(
      horizontal: pageContentHorizontalInset,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}