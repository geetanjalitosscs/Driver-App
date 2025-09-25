import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Professional button component with multiple variants
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final textStyle = _getTextStyle();
    final padding = _getPadding();
    final borderRadius = _getBorderRadius();

    Widget buttonChild = _buildButtonChild(textStyle);

    if (isFullWidth) {
      buttonChild = SizedBox(
        width: double.infinity,
        child: buttonChild,
      );
    }

    return AnimatedContainer(
      duration: AppAnimations.shortDuration,
      curve: AppAnimations.defaultCurve,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: Padding(
          padding: padding,
          child: buttonChild,
        ),
      ),
    );
  }

  Widget _buildButtonChild(TextStyle textStyle) {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.outline ? AppTheme.primaryBlue : Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('Loading...', style: textStyle),
        ],
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize(), color: _getIconColor()),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text, 
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Center(
      child: Text(text, style: textStyle),
    );
  }

  ButtonStyle _getButtonStyle() {
    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: _getBorderRadius(),
          ),
          shadowColor: AppTheme.primaryBlue.withOpacity(0.3),
        );
      case AppButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: _getBorderRadius(),
          ),
          shadowColor: AppTheme.accentGreen.withOpacity(0.3),
        );
      case AppButtonVariant.danger:
        return ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentRed,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: _getBorderRadius(),
          ),
          shadowColor: AppTheme.accentRed.withOpacity(0.3),
        );
      case AppButtonVariant.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppTheme.primaryBlue,
          elevation: 0,
          side: const BorderSide(color: AppTheme.primaryBlue, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: _getBorderRadius(),
          ),
        );
      case AppButtonVariant.ghost:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppTheme.primaryBlue,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: _getBorderRadius(),
          ),
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return AppTheme.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
          color: _getTextColor(),
        );
      case AppButtonSize.medium:
        return AppTheme.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: _getTextColor(),
        );
      case AppButtonSize.large:
        return AppTheme.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: _getTextColor(),
        );
    }
  }

  Color _getTextColor() {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
      case AppButtonVariant.danger:
        return Colors.white;
      case AppButtonVariant.outline:
      case AppButtonVariant.ghost:
        return AppTheme.primaryBlue;
    }
  }

  Color _getIconColor() {
    return _getTextColor();
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  BorderRadius _getBorderRadius() {
    switch (size) {
      case AppButtonSize.small:
        return BorderRadius.circular(8);
      case AppButtonSize.medium:
        return BorderRadius.circular(12);
      case AppButtonSize.large:
        return BorderRadius.circular(16);
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }
}

enum AppButtonVariant {
  primary,
  secondary,
  danger,
  outline,
  ghost,
}

enum AppButtonSize {
  small,
  medium,
  large,
}
