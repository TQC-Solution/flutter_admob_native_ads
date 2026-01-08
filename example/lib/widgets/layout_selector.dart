import 'package:flutter/material.dart';
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

/// Widget for selecting ad layout type
class LayoutSelector extends StatelessWidget {
  final List<NativeAdLayoutType> layouts;
  final NativeAdLayoutType selectedLayout;
  final ValueChanged<NativeAdLayoutType> onLayoutSelected;

  const LayoutSelector({
    super.key,
    required this.layouts,
    required this.selectedLayout,
    required this.onLayoutSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Layout Type:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: layouts.length,
              itemBuilder: (context, index) {
                final layout = layouts[index];
                final isSelected = layout == selectedLayout;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('Form${index + 1}'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) onLayoutSelected(layout);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
