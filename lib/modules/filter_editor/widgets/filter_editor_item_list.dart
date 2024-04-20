import 'dart:io';
import 'dart:typed_data';

import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:colorfilter_generator/presets.dart';
import 'package:flutter/material.dart';
import 'package:story_editor/models/editor_configs/story_editor_configs.dart';
import 'package:story_editor/models/filter_state_history.dart';
import 'package:story_editor/widgets/story_editor_desktop_mode.dart';

import '../../../models/blur_state_history.dart';
import '../../../models/editor_image.dart';
import 'image_with_filter.dart';

class FilterEditorItemList extends StatefulWidget {
  /// A byte array representing the image data.
  final Uint8List? byteArray;

  /// The file representing the image.
  final File? file;

  /// The asset path of the image.
  final String? assetPath;

  /// The network URL of the image.
  final String? networkUrl;

  /// The image editor configs.
  final StoryEditorConfigs configs;

  /// Specifies the scale factor for items.
  ///
  /// If provided, this value scales the items in the editor by the specified factor.
  final double? itemScaleFactor;

  /// Specifies the list of active filter state histories.
  ///
  /// If provided, this list contains the history of active filters applied to the image.
  final List<FilterStateHistory>? activeFilters;

  /// Specifies the blur state history.
  ///
  /// If provided, this object contains the history of blur states applied to the image.
  final BlurStateHistory? blur;

  /// Specifies the selected filter.
  ///
  /// This property represents the currently selected filter for the image editor.
  final ColorFilterGenerator selectedFilter;

  /// Callback function for selecting a filter.
  ///
  /// This function is called when a filter is selected in the editor. It takes a [ColorFilterGenerator] as a parameter, representing the selected filter.
  final Function(ColorFilterGenerator filter) onSelectFilter;

  const FilterEditorItemList({
    super.key,
    this.byteArray,
    this.file,
    this.assetPath,
    this.networkUrl,
    this.activeFilters,
    this.blur,
    this.itemScaleFactor,
    required this.selectedFilter,
    required this.onSelectFilter,
    required this.configs,
  });

  @override
  State<FilterEditorItemList> createState() => _FilterEditorItemListState();
}

class _FilterEditorItemListState extends State<FilterEditorItemList> {
  late ScrollController _scrollCtrl;

  /// A list of `ColorFilterGenerator` objects that define the image filters available in the editor.
  List<ColorFilterGenerator> get _filters =>
      widget.configs.filterEditorConfigs.filterList ?? presetFiltersList;

  @override
  void initState() {
    _scrollCtrl = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFilterList();
  }

  /// Builds a horizontal list of filter preview buttons.
  SizedBox _buildFilterList() {
    return SizedBox(
      height: 120,
      child: Scrollbar(
        controller: _scrollCtrl,
        scrollbarOrientation: ScrollbarOrientation.bottom,
        thumbVisibility: isDesktop,
        trackVisibility: isDesktop,
        child: SingleChildScrollView(
          controller: _scrollCtrl,
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: MediaQuery.of(context).size.width),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                alignment: WrapAlignment.spaceAround,
                spacing: 15,
                children: <Widget>[
                  for (int i = 0; i < _filters.length; i++)
                    filterPreviewButton(
                      filter: _filters[i],
                      name: _filters[i].name,
                      index: i,
                      activeFilters: widget.activeFilters,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Create a button for filter preview.
  Widget filterPreviewButton({
    required ColorFilterGenerator filter,
    required String name,
    required int index,
    List<FilterStateHistory>? activeFilters,
  }) {
    var size = const Size(64, 64);
    return GestureDetector(
      key: ValueKey('Filter-$name-$index'),
      onTap: () {
        widget.onSelectFilter(filter);
      },
      child: Center(
        child: Column(children: [
          Container(
            height: size.height,
            width: size.width,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: const Color(0xFF242424),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: ImageWithFilter(
                image: EditorImage(
                  file: widget.file,
                  byteArray: widget.byteArray,
                  networkUrl: widget.networkUrl,
                  assetPath: widget.assetPath,
                ),
                activeFilters: widget.activeFilters,
                size: size,
                designMode: widget.configs.designMode,
                filter: filter,
                blur: widget.blur,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            widget.configs.i18n.filterEditor.filters.getFilterI18n(name),
            style: TextStyle(
              fontSize: 11,
              color:
                  widget.configs.imageEditorTheme.filterEditor.previewTextColor,
            ),
          ),
        ]),
      ),
    );
  }
}
