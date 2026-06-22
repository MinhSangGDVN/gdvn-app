import 'package:flutter/widgets.dart';

import 'package:gdvn/widgets/submit_sheet.dart';

Future<void> showSubmitRecordSheet(BuildContext context) async {
  await showSubmitSheet(
    context,
    steps: const [
      'Loại',
      'Bản ghi',
      'Level',
      'Xác nhận',
      'Chi tiết',
      'Tùy chọn',
    ],
    currentStep: 1,
    placeholderTitle: 'Form nộp bản ghi',
    placeholderDescription:
        'Giữ chỗ cho các field như tên người chơi, link video, thông tin level và phần validation trước khi submit thật.',
    dialog: const SubmitSheetDialogConfig(
      sectionTitle: 'Dialog bản ghi',
      sectionDescription:
          'Giữ chỗ cho dialog xác nhận submit, báo lỗi hoặc thông báo thành công của flow nộp bản ghi.',
      buttonLabel: 'Mở dialog bản ghi',
      title: 'Dialog placeholder cho bản ghi',
      description:
          'Thay nội dung này bằng dialog xác nhận submit, báo lỗi hoặc thông báo thành công khi form thật được hoàn thiện.',
    ),
  );
}
