import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:story_editor/story_editor.dart';

import '../models/layer.dart';

class EffectEditor extends HookConsumerWidget {
  /// The image editor configs
  final StoryEditorConfigs configs;

  /// Creates an `StickerEditor` widget.
  const EffectEditor({
    super.key,
    required this.configs,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // void close() {
    //   Navigator.pop(context);
    // }

    void setLayer(Widget effect) {
      Navigator.of(context).pop(
        EffectLayerData(effect: effect),
      );
    }

    return configs.effectEditorConfigs!.builder(setLayer);
  }
}
