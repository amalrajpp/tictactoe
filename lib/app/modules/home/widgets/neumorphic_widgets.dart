// lib/app/modules/home/widgets/neumorphic_widgets.dart
import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/constants.dart';

class NeumorphicContainer extends StatelessWidget {
  const NeumorphicContainer({
    Key? key,
    this.child,
    this.pressed,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.color,
    this.borderRadius,
    this.border,
  }) : super(key: key);
  final bool? pressed;
  final double? width;
  final double? height;
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final dynamic padding;

  @override
  Widget build(BuildContext context) {
    BorderRadius deafultRadius = BorderRadius.circular(neumorphicDefaultRadius);
    return AnimatedContainer(
      width: width,
      height: height,
      margin: margin,
      duration: const Duration(milliseconds: 150),
      padding: padding ?? const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? deafultRadius,
        border: border,
        color: pressed == true
            ? CustomColors.containerPressed.withOpacity(0.2)
            : color ?? CustomColors.container.withOpacity(0.2),
        boxShadow: pressed == true
            ? null
            : [
                BoxShadow(
                  blurRadius: 10,
                  offset: const Offset(-4, -4),
                  color: CustomColors.containerShadowTop.withOpacity(0.5),
                ),
                BoxShadow(
                  blurRadius: 10,
                  offset: const Offset(4, 4),
                  color: CustomColors.containerShadowBottom.withOpacity(0.5),
                ),
              ],
      ),
      child: child,
    );
  }
}

class NeumorphicIconButton extends StatefulWidget {
  const NeumorphicIconButton({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);
  final VoidCallback onTap;
  final Icon icon;
  @override
  _NeumorphicIconButtonState createState() => _NeumorphicIconButtonState();
}

class _NeumorphicIconButtonState extends State<NeumorphicIconButton> {
  bool _isPressed = false;
  void _onPointerDown(PointerDownEvent event) =>
      setState(() => _isPressed = true);
  void _onPointerUp(PointerUpEvent event) {
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _onPointerCancel(PointerCancelEvent event) =>
      setState(() => _isPressed = false);
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: NeumorphicContainer(
        width: 64,
        height: 64,
        pressed: _isPressed,
        borderRadius: BorderRadius.circular(32),
        child: Center(child: widget.icon),
      ),
    );
  }
}
