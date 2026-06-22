import 'package:flutter/widgets.dart';
import 'package:gdvn/widgets/page_content_container.dart';
import 'package:gdvn/widgets/top_bar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TopBarContent(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: 30,
        itemBuilder: (context, index) => PageContentContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF888888).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Mục ${index + 1}',
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
