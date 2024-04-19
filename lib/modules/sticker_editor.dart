import 'package:flutter/material.dart';
import 'package:story_editor/story_editor.dart';

import '../models/layer.dart';

/// The `StickerEditor` class is responsible for creating a widget that allows users to select emojis.
///
/// This widget provides an EmojiPicker that allows users to choose emojis, which are then returned
/// as `EmojiLayerData` containing the selected emoji text.
class StickerEditor extends StatefulWidget {
  /// The image editor configs
  final ProImageEditorConfigs configs;

  /// Creates an `StickerEditor` widget.
  const StickerEditor({
    super.key,
    required this.configs,
  });

  @override
  createState() => StickerEditorState();
}

/// The state class for the `StickerEditor` widget.
class StickerEditorState extends State<StickerEditor> {
  /// Closes the editor without applying changes.
  void close() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.configs.stickerEditorConfigs!.buildStickers(setLayer);
  }

  void setLayer(Widget sticker) {
    Navigator.of(context).pop(
      StickerLayerData(sticker: sticker),
    );
  }
}
