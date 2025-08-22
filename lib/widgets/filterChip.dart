import 'package:flutter/material.dart';
import 'package:bid4style/utils/Appcolor.dart';

class BidTabChips extends StatelessWidget {
  final List<String> tabTitles;
  final int selectedIndex;
  final Color indicatorColor;
  final Color unselectedLabelColor;
  final ValueChanged<int> onTabSelected;

  const BidTabChips({
    super.key,
    required this.tabTitles,
    required this.selectedIndex,
    required this.indicatorColor,
    required this.unselectedLabelColor,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabTitles.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(title),
              labelStyle: TextStyle(
                color: selectedIndex == index
                    ? AppColors.themecolor
                    : unselectedLabelColor,
                fontSize: 14,
              ),
              showCheckmark: false,
              backgroundColor: selectedIndex == index
                  ? indicatorColor
                  : Colors.grey[200],
              selected: selectedIndex == index,
              onSelected: (bool value) {
                onTabSelected(index);
              },
              checkmarkColor: AppColors.themecolor,
              disabledColor: AppColors.red,
              selectedColor: AppColors.green,
              selectedShadowColor: AppColors.white,
              surfaceTintColor: AppColors.green,
              color: WidgetStatePropertyAll(Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: selectedIndex == index
                      ? indicatorColor
                      : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
