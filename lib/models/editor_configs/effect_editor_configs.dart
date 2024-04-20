import 'package:flutter/widgets.dart';

class EffectEditorConfigs {
  final bool enabled;
  final double initWidth;
  final BuildEffects builder;

  /// A callback triggered each time the search value changes.
  ///
  /// This callback is activated exclusively when the editor mode is set to 'WhatsApp'.
  final Function(String value)? onSearchChanged;

  /// Creates an instance of StickerEditorConfigs with optional settings.
  ///
  /// By default, the editor is disabled (if not specified), and other properties
  /// are set to reasonable defaults.
  const EffectEditorConfigs({
    required this.builder,
    this.onSearchChanged,
    this.initWidth = 100,
    this.enabled = false,
  });
}

typedef BuildEffects = Widget Function(Function(Widget) setLayer);
