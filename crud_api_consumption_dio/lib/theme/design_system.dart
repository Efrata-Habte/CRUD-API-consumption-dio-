import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0F172A); 
  static const Color secondary = Color(0xFF2563EB); 
  static const Color warning = Color(0xFFE11D48);
  static const Color accent = Color(0xFF0D9488); 
  
  static const Color background = Color(0xFFF8FAFC); 
  static const Color surface = Colors.white;
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B); 
  static const Color borderLight = Color(0xFFE2E8F0); 
}

class AppStyles {
  static final boxDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.borderLight, width: 1.2),
    boxShadow: const [
      BoxShadow(
        color: Color(0x040F172A),
        blurRadius: 16,
        offset: Offset(0, 4),
      ),
    ],
  );

  static final glassDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.borderLight, width: 1.2),
  );
}

class AvatarStyle {
  final LinearGradient gradient;
  final Color textColor;
  AvatarStyle(this.gradient, this.textColor);
}

class DesignSystem {
  static AvatarStyle getAvatarStyle(String name) {
    if (name.isEmpty) {
      return AvatarStyle(
        const LinearGradient(colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)]),
        const Color(0xFF475569),
      );
    }
    final char = name[0].toUpperCase();
    final code = char.codeUnitAt(0);

    if (code >= 65 && code <= 69) {
      return AvatarStyle(
        const LinearGradient(colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)]),
        const Color(0xFF1E40AF),
      );
    } else if (code >= 70 && code <= 74) {
      return AvatarStyle(
        const LinearGradient(colors: [Color(0xFFECFDF5), Color(0xFFD1FAE5)]),
        const Color(0xFF065F46),
      );
    } else if (code >= 75 && code <= 79) {
      return AvatarStyle(
        const LinearGradient(colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)]),
        const Color(0xFF92400E),
      );
    } else if (code >= 80 && code <= 84) {
      return AvatarStyle(
        const LinearGradient(colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF)]),
        const Color(0xFF3730A3),
      );
    } else {
      return AvatarStyle(
        const LinearGradient(colors: [Color(0xFFFFF1F2), Color(0xFFFFE4E6)]),
        const Color(0xFF9F1239),
      );
    }
  }

  static Widget buildTag({
    required IconData icon,
    required String label,
    required Color baseColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: baseColor.withOpacity(0.12), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: baseColor),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: baseColor.withOpacity(0.95),
                letterSpacing: 0.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
