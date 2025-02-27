import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/utils/responsive/responsive_sizes.dart';

class CustomBottomNavBar extends StatefulWidget {
  final List<BottomNavItem> items;
  final ValueChanged<int> onItemSelected;
  final int initialIndex;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double height;
  final double iconSize;

  const CustomBottomNavBar({
    super.key,
    required this.items,
    required this.onItemSelected,
    this.initialIndex = 0,
    this.selectedItemColor, //= const Color(0xFFFF9800),
    this.unselectedItemColor, //= const Color(0xffffffff),
    this.height = 60.0,
    this.iconSize = 24.0,
  })  : assert(items.length >= 2 && items.length <= 6),
        assert(initialIndex >= 0 && initialIndex < items.length);

  @override
  _CustomBottomNavBarx createState() => _CustomBottomNavBarx();
}

class _CustomBottomNavBarx extends State<CustomBottomNavBar>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _positionAnimation;
  late Animation<double> _scaleAnimation;
  final bool _isAnimating = false;
  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );


    _positionAnimation = Tween<double>(
            begin: widget.initialIndex.toDouble(),
            end: widget.initialIndex.toDouble())
        .animate(_animation);
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.5), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1), weight: 1),
    ]).animate(_animation);
    super.initState();
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _positionAnimation = Tween<double>(
          begin: _selectedIndex.toDouble(),
          end: index.toDouble(),
        ).animate(_animation);
        _selectedIndex = index;
      });
      widget.onItemSelected(index);
      _animationController.forward(from: 0.0);
    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SizeConfig().init(context);  // Manually initializing SizeConfig
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: EdgeInsets.symmetric(horizontal: 28.w, vertical: 8.h),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(30), boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        )
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                borderRadius: BorderRadius.circular(1),
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                final containerWith = constraints.maxWidth;
                final itemWith = containerWith / widget.items.length;
                final circleSize = widget.height * 0.8;
                final horizontalPadding = (itemWith - circleSize) / 2;

                return Stack(
                  children: [
                    AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          final verticalPadding = (widget.height - circleSize) / 2;
                          return Positioned(
                              left: _positionAnimation.value * itemWith + horizontalPadding,
                              top: verticalPadding,  // Dynamic top position
                              child: Transform.scale(
                                scale: _scaleAnimation.value,
                                child: Container(
                                  width: circleSize,
                                  height: circleSize,
                                  decoration: BoxDecoration(
                                    color: widget.selectedItemColor??Theme.of(context).colorScheme.secondary
                                        .withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                          );
                        }
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(widget.items.length, (index){
                        return _buildNavItem(index);
                      }),
                    )
                  ],
                );
              })),
        ),
      ),
    );
  }
  Widget _buildNavItem(int index){
    final bool isSelected = index == _selectedIndex;
    final Color itemColor = isSelected ? widget.selectedItemColor??Theme.of(context).colorScheme.secondary:widget.unselectedItemColor??Theme.of(context).colorScheme.surface;

    return Expanded(child: GestureDetector(
      onTap: () => _onItemTapped(index),
      child: SizedBox(
    height: widget.height,
    child: Icon(widget.items[index].icon,
    color: itemColor,
    size: widget.iconSize,
    )
    )
    ));
  }
}


class BottomNavItem {
  final IconData icon;

  BottomNavItem({required this.icon});
}
