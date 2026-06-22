import 'package:flutter/widgets.dart';

import 'package:gdvn/widgets/submit_sheet.dart';

Future<void> showSubmitLevelChallengeSheet(BuildContext context) async {
  await showSubmitSheet(
    context,
    steps: const ['Loại', 'Lưu ý', 'Level', 'Xác nhận', 'Chi tiết', 'Tùy chọn'],
    currentStep: 1,
    placeholderTitle: 'Form đề xuất challenge level',
    placeholderDescription:
        'Giữ chỗ cho thông tin level, độ khó, creator, link tham khảo và các tiêu chí duyệt challenge mới.',
    dialog: const SubmitSheetDialogConfig(
      sectionTitle: 'Dialog challenge',
      sectionDescription:
          'Giữ chỗ cho xác nhận submit, cảnh báo thiếu dữ liệu hoặc trạng thái review của đề xuất challenge.',
      buttonLabel: 'Mở dialog challenge',
      title: 'Dialog placeholder cho challenge',
      description:
          'Dùng dialog này làm chỗ đặt xác nhận gửi đề xuất, cảnh báo thiếu dữ liệu hoặc trạng thái review sau này.',
    ),
  );
}
