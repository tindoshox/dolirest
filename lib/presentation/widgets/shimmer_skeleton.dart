import 'package:flutter/material.dart';

/// A shimmering skeleton widget that can be used to indicate loading states in
/// the user interface.
///
/// This widget displays a grid of shimmering lines that animate to reveal
/// the underlying content. The size of the lines can be customized using the
/// [height] and [width] properties.
class ShimmerSkeleton extends StatelessWidget {
  /// Creates a shimmering skeleton.
  const ShimmerSkeleton({
    super.key,
    this.height,
    this.width,
  });

  /// The height of the skeleton.
  ///
  /// Defaults to 16.0.
  final double? height;

  /// The width of the skeleton.
  ///
  /// Defaults to 16.0.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
        ),
      ),
    );
  }
}
