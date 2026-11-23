import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdaptiveDestination {
  final String label;
  final String selectedIcon;
  final String unselectedIcon;

  const AdaptiveDestination({
    required this.label,
    required this.selectedIcon,
    required this.unselectedIcon,
  });
}

/// The app's single place that picks navigation chrome by width:
/// bottom bar on compact windows (folded phone), navigation rail on medium
/// and wider windows (unfolded foldable, tablet, landscape).
class AdaptiveNavigationShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AdaptiveDestination> destinations;
  final Widget body;

  const AdaptiveNavigationShell({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = WindowSizeClass.of(context).isCompact;
    // One tree shape for both modes, with the body in a keyed slot: only the
    // rail/bar come and go, so folding or unfolding never rebuilds the tabs
    // (selected category, scroll positions and loaded data are kept).
    return Scaffold(
      body: Row(
        children: [
          if (!isCompact) _buildRail(),
          Expanded(key: const ValueKey('shell-body'), child: body),
        ],
      ),
      bottomNavigationBar: isCompact ? _buildBottomBar() : null,
    );
  }

  Widget _buildBottomBar() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: selectedIndex,
        onTap: onDestinationSelected,
        items: [
          for (var i = 0; i < destinations.length; i++)
            BottomNavigationBarItem(
              icon: _icon(destinations[i], isSelected: i == selectedIndex),
              label: destinations[i].label,
              tooltip: destinations[i].label,
            ),
        ],
      ),
    );
  }

  Widget _buildRail() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(16.r),
        bottomRight: Radius.circular(16.r),
      ),
      child: ColoredBox(
        color: AppColors.primaryColor,
        child: SafeArea(
          right: false,
          child: NavigationRail(
            backgroundColor: AppColors.primaryColor,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.none,
            groupAlignment: 0,
            indicatorColor: AppColors.transparentColor,
            destinations: [
              for (var i = 0; i < destinations.length; i++)
                NavigationRailDestination(
                  icon: Tooltip(
                    message: destinations[i].label,
                    child: _icon(
                      destinations[i],
                      isSelected: i == selectedIndex,
                    ),
                  ),
                  label: Text(destinations[i].label),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon(AdaptiveDestination destination, {required bool isSelected}) {
    return CircleAvatar(
      backgroundColor: isSelected
          ? AppColors.whiteColor
          : AppColors.primaryColor,
      radius: 25.r,
      child: Image.asset(
        isSelected ? destination.selectedIcon : destination.unselectedIcon,
      ),
    );
  }
}
