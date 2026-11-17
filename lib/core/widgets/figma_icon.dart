import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders the exact SVG icon assets exported from the Figma design.
class FigmaIcon extends StatelessWidget {
  final String asset;
  final double size;
  final Color? color;

  const FigmaIcon(this.asset, {super.key, this.size = 20, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$asset.svg',
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter:
          color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
