import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

enum ActionBottomSheetDestination { submitRecord, submitLevelChallenge }

FTile _buildTile({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onPress,
}) {
  return FTile(
    prefix: Icon(icon),
    title: Text(title),
    subtitle: Text(subtitle),
    suffix: const Icon(FIcons.chevronRight),
    onPress: onPress,
  );
}

Future<ActionBottomSheetDestination?> showActionBottomSheet(
  BuildContext context,
) {
  return showFSheet<ActionBottomSheetDestination>(
    context: context,
    side: FLayout.btt,
    style: const FModalSheetStyleDelta.delta(
      motion: FModalSheetMotionDelta.delta(
        expandDuration: Duration(milliseconds: 260),
        collapseDuration: Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      ),
    ),
    builder: (sheetContext) {
      return Builder(
        builder: (context) {
          final theme = context.theme;
          final borderRadius = const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          );

          return DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colors.card,
              border: Border.all(
                color: theme.colors.border,
                width: theme.style.borderWidth,
              ),
              borderRadius: borderRadius,
            ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FTileGroup(
                        children: [
                          _buildTile(
                            icon: FIcons.fileText,
                            title: 'Nộp bản ghi',
                            subtitle:
                                'Nộp kết quả chơi level Insane Demon trở lên',
                            onPress: () => Navigator.of(
                              sheetContext,
                            ).pop(ActionBottomSheetDestination.submitRecord),
                          ),
                          _buildTile(
                            icon: FIcons.trophy,
                            title: 'Nộp level challenge',
                            subtitle:
                                'Đề xuất thêm challenge level mới vào danh sách',
                            onPress: () => Navigator.of(sheetContext).pop(
                              ActionBottomSheetDestination.submitLevelChallenge,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
