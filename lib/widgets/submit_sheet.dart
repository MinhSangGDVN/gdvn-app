import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

const BorderRadius _sheetBorderRadius = BorderRadius.only(
  topLeft: Radius.circular(24),
  topRight: Radius.circular(24),
);

class SubmitSheetDialogConfig {
  const SubmitSheetDialogConfig({
    required this.sectionTitle,
    required this.sectionDescription,
    required this.buttonLabel,
    required this.title,
    required this.description,
  });

  final String sectionTitle;
  final String sectionDescription;
  final String buttonLabel;
  final String title;
  final String description;
}

Future<void> showSubmitSheet(
  BuildContext context, {
  required List<String> steps,
  required int currentStep,
  required String placeholderTitle,
  required String placeholderDescription,
  required SubmitSheetDialogConfig dialog,
}) async {
  await showFSheet<void>(
    context: context,
    side: FLayout.btt,
    mainAxisMaxRatio: null,
    draggable: false,
    style: const FModalSheetStyleDelta.delta(
      motion: FModalSheetMotionDelta.delta(
        expandDuration: Duration(milliseconds: 260),
        collapseDuration: Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      ),
    ),
    builder: (sheetContext) {
      return _SubmitSheet(
        steps: steps,
        currentStep: currentStep,
        placeholderTitle: placeholderTitle,
        placeholderDescription: placeholderDescription,
        dialog: dialog,
      );
    },
  );
}

class _SubmitSheet extends StatelessWidget {
  _SubmitSheet({
    this.steps = const ['Loại'],
    this.currentStep = 1,
    this.placeholderTitle = 'Form submit',
    this.placeholderDescription =
        'Giữ chỗ cho nội dung form khi hot reload đang dùng state cũ.',
    this.dialog = const SubmitSheetDialogConfig(
      sectionTitle: 'Dialog',
      sectionDescription:
          'Giữ chỗ cho dialog khi hot reload đang dùng state cũ.',
      buttonLabel: 'Mở dialog',
      title: 'Dialog placeholder',
      description: 'Nội dung dialog mặc định.',
    ),
  }) : assert(steps.isNotEmpty),
       assert(1 <= currentStep && currentStep <= steps.length);

  final List<String> steps;
  final int currentStep;
  final String placeholderTitle;
  final String placeholderDescription;
  final SubmitSheetDialogConfig dialog;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0,
      maxChildSize: 1,
      shouldCloseOnMinExtent: true,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colors.card,
            border: Border.all(
              color: theme.colors.border,
              width: theme.style.borderWidth,
            ),
            borderRadius: _sheetBorderRadius,
          ),
          child: ClipRRect(
            borderRadius: _sheetBorderRadius,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colors.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const SizedBox(width: 52, height: 4),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _SubmitSheetStepper(steps: steps, currentStep: currentStep),
                    const SizedBox(height: 24),
                    _SubmitSectionCard(
                      title: placeholderTitle,
                      description: placeholderDescription,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          _PlaceholderField(label: 'Tên'),
                          SizedBox(height: 12),
                          _PlaceholderField(label: 'Link video hoặc chứng cứ'),
                          SizedBox(height: 12),
                          _PlaceholderField(label: 'Ghi chú thêm', lines: 4),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SubmitSectionCard(
                      title: dialog.sectionTitle,
                      description: dialog.sectionDescription,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FButton(
                            onPress: () => _showPlaceholderDialog(
                              context,
                              title: dialog.title,
                              description: dialog.description,
                            ),
                            child: Text(dialog.buttonLabel),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SubmitSheetStepper extends StatelessWidget {
  const _SubmitSheetStepper({required this.steps, required this.currentStep});

  final List<String> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final estimatedMinWidth =
            (steps.length * 88) + ((steps.length - 1) * 40);
        final width = constraints.maxWidth < estimatedMinWidth
            ? estimatedMinWidth.toDouble()
            : constraints.maxWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: SizedBox(
            width: width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < steps.length; index++) ...[
                  Expanded(
                    flex: 11,
                    child: _SubmitSheetStepItem(
                      index: index,
                      label: steps[index],
                      isActive: currentStep == index + 1,
                    ),
                  ),
                  if (index != steps.length - 1)
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: theme.colors.border,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const SizedBox(height: 2),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SubmitSheetStepItem extends StatelessWidget {
  const _SubmitSheetStepItem({
    required this.index,
    required this.label,
    required this.isActive,
  });

  final int index;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final circleColor = isActive
        ? theme.colors.foreground
        : theme.colors.background;
    final circleTextColor = isActive
        ? theme.colors.background
        : theme.colors.mutedForeground;
    final labelColor = isActive
        ? theme.colors.foreground
        : theme.colors.mutedForeground;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colors.border,
              width: theme.style.borderWidth,
            ),
          ),
          child: SizedBox(
            width: 42,
            height: 42,
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: circleTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: labelColor,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SubmitSectionCard extends StatelessWidget {
  const _SubmitSectionCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colors.border,
          width: theme.style.borderWidth,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                color: theme.colors.foreground,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: theme.colors.mutedForeground,
                fontSize: 14,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _PlaceholderField extends StatelessWidget {
  const _PlaceholderField({required this.label, this.lines = 1});

  final String label;
  final int lines;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colors.border,
          width: theme.style.borderWidth,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: theme.colors.foreground,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Placeholder',
              style: TextStyle(
                color: theme.colors.mutedForeground,
                fontSize: 14,
              ),
            ),
            if (1 < lines) ...[
              const SizedBox(height: 10),
              ...List.generate(
                lines - 1,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    '................................................................',
                    style: TextStyle(
                      color: theme.colors.mutedForeground,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Future<void> _showPlaceholderDialog(
  BuildContext context, {
  required String title,
  required String description,
}) async {
  await showFDialog<void>(
    context: context,
    builder: (dialogContext, _, animation) {
      return FDialog(
        animation: animation,
        title: Text(title),
        body: Text(description),
        actions: [
          FButton(
            onPress: () => Navigator.of(dialogContext).pop(),
            child: const Text('Đóng'),
          ),
        ],
      );
    },
  );
}
