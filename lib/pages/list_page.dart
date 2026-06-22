import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:forui/forui.dart';

import 'package:gdvn/widgets/top_bar.dart';

enum ListPageVariant {
  classic,
  platformer,
  challenge;

  String get label => switch (this) {
    ListPageVariant.classic => 'Classic',
    ListPageVariant.platformer => 'Platformer',
    ListPageVariant.challenge => 'Challenge',
  };
}

class ListPage extends StatelessWidget {
  final ValueListenable<ListPageVariant> variantListenable;

  const ListPage({super.key, required this.variantListenable});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ListPageVariant>(
      valueListenable: variantListenable,
      builder: (context, variant, _) {
        return TopBarContent(
          child: SafeArea(
            top: false,
            child: Center(
              child: Text(
                '${variant.label} list',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ListPageHeaderVariantSwitcher extends StatelessWidget {
  final ValueNotifier<ListPageVariant> controller;

  const ListPageHeaderVariantSwitcher({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ListPageVariant>(
      valueListenable: controller,
      builder: (context, selectedVariant, _) {
        return FPopoverMenu.tiles(
          menuAnchor: Alignment.topCenter,
          childAnchor: Alignment.bottomCenter,
          offset: const Offset(0, 4),
          semanticsLabel: 'Chọn biến thể danh sách',
          builder: (context, popoverController, child) =>
              FTappable(onPress: popoverController.toggle, child: child),
          menuBuilder: (context, popoverController, _) {
            return [
              FTileGroup(
                divider: FItemDivider.full,
                children: ListPageVariant.values
                    .map(
                      (variant) => FTile(
                        title: Text(
                          variant.label,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                        onPress: () {
                          if (controller.value != variant) {
                            controller.value = variant;
                          }

                          popoverController.hide();
                        },
                      ),
                    )
                    .toList(growable: false),
              ),
            ];
          },
          child: Semantics(
            button: true,
            label: 'Biến thể hiện tại ${selectedVariant.label}',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: IconTheme.merge(
                data: const IconThemeData(size: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(selectedVariant.label),
                    const SizedBox(width: 6),
                    const Icon(CupertinoIcons.chevron_down),
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
