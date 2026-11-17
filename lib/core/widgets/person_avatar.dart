import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Initials medallion used wherever the web falls back to a generated avatar.
/// Colour is stable per name so a person reads the same everywhere.
class PersonAvatar extends StatelessWidget {
  final String name;
  final double size;
  final String? imageUrl;
  final bool ring;

  const PersonAvatar({
    super.key,
    required this.name,
    this.size = 34,
    this.imageUrl,
    this.ring = true,
  });

  static const _tints = [
    Color(0xFFDCE7DA),
    Color(0xFFE3E0F5),
    Color(0xFFDDEEF4),
    Color(0xFFFAEED2),
    Color(0xFFE0F0E6),
  ];

  Color get _tint {
    var hash = 0;
    for (final c in name.codeUnits) {
      hash = (hash * 31 + c) & 0x7fffffff;
    }
    return _tints[hash % _tints.length];
  }

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final photo = imageUrl;
    Widget base;
    if (photo != null && photo.startsWith('assets/')) {
      base = Image.asset(
        photo,
        width: size,
        height: size,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        errorBuilder: (_, _, _) => _initialsTile(),
      );
    } else {
      base = _initialsTile();
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: ring
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      padding: ring ? EdgeInsets.all(size * 0.06) : null,
      child: ClipOval(child: base),
    );
  }

  Widget _initialsTile() => DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, color: _tint),
        child: Center(
          child: Text(
            _initials,
            style: TextStyle(
              fontSize: size * 0.36,
              fontWeight: FontWeight.w700,
              color: AppColors.sageInk,
              height: 1,
            ),
          ),
        ),
      );
}
