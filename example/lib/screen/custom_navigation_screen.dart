import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:story_editor/story_editor.dart';

class CustomNavigationScreen extends HookWidget {
  final _editor = GlobalKey<StoryEditorState>();
  CustomNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bytes = useState<Uint8List?>(null);

    useEffect(() {
      var url = 'https://picsum.photos/2000';
      fetchImageAsUint8List(url).then((value) => bytes.value = value);

      return null;
    }, []);

    if (bytes.value == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final storyEditor = StoryEditor.memory(
      bytes.value!,
      onStoryEditingComplete: (bytes) async {
        Navigator.pop(context);
        final history = await _editor.currentState
            ?.exportStateHistory(
              // All configurations are optional
              configs: const ExportEditorConfigs(
                exportPainting: true,
                exportText: true,
                exportCropRotate: false,
                exportFilter: false,
                exportEmoji: true,
                exportSticker: true,
                historySpan: ExportHistorySpan.current,
              ),
            )
            .toMap();
        debugPrint(history.toString());
      },
      configs: StoryEditorConfigs(
        customWidgets: ImageEditorCustomWidgets(
          // Custom widgets for the editor
          // You can customize the editor with your own widgets
          // For example, you can add a custom button to the bottom navigation bar
          bottomNavigationBar: IconButton(
            icon: const Icon(Icons.layers_outlined),
            onPressed: () {
              debugPrint('object');
              // storyEditor.openStickerEditor()
              // storyEditor.openStickerEditor()
            },
          ),
        ),
      ),
    );

    return Scaffold(
        body: storyEditor,
        bottomNavigationBar: ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.image),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.abc),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.emoji_emotions),
              onPressed: () {
                // storyEditor.openFilterEditor()
              },
            ),
          ],
        ));
  }
}
