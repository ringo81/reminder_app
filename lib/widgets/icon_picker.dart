import 'package:flutter/material.dart';
import '../utils/constants.dart';

class IconPickerWidget extends StatelessWidget {
  final IconData selected;
  final ValueChanged<IconData> onSelected;

  const IconPickerWidget({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: kIconOptions.map((icon) {
        final isSelected = icon == selected;
        return GestureDetector(
          onTap: () => onSelected(icon),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isSelected ? mainLightBlue : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[500],
              size: 22,
            ),
          ),
        );
      }).toList(),
    );
  }
}
