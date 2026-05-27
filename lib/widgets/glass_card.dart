import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final EdgeInsets padding;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),

      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15,
          sigmaY: 15,
        ),

        child: Container(
          width: width,
          padding: padding,

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),

            borderRadius: BorderRadius.circular(22),

            border: Border.all(
              color: Colors.white24,
            ),
          ),

          child: child,
        ),
      ),
    );
  }
}