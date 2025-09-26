import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double elevation;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 50,
    this.borderRadius = 12,
    this.padding,
    this.textStyle,
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    final Widget buttonChild = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutlined ? AppColors.primary : AppColors.white,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: _getTextColor(context)),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style:
                    textStyle ??
                    TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _getTextColor(context),
                    ),
              ),
            ],
          );

    final Widget button = isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: textColor ?? AppColors.primary,
              side: BorderSide(
                color: backgroundColor ?? AppColors.primary,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding:
                  padding ??
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              minimumSize: Size(width ?? 0, height),
              elevation: elevation,
            ),
            child: buttonChild,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? AppColors.primary,
              foregroundColor: textColor ?? AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding:
                  padding ??
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              minimumSize: Size(width ?? 0, height),
              elevation: elevation,
            ),
            child: buttonChild,
          );

    return width != null ? SizedBox(width: width, child: button) : button;
  }

  Color _getTextColor(BuildContext context) {
    if (textColor != null) return textColor!;
    if (isOutlined) return backgroundColor ?? AppColors.primary;
    return AppColors.white;
  }
}

// Predefined button variations
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      backgroundColor: AppColors.primary,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      backgroundColor: AppColors.secondary,
    );
  }
}

class OutlinedCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final Color? borderColor;

  const OutlinedCustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      isOutlined: true,
      backgroundColor: borderColor ?? AppColors.primary,
    );
  }
}

class SuccessButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const SuccessButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      backgroundColor: AppColors.success,
    );
  }
}

class ErrorButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const ErrorButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      backgroundColor: AppColors.error,
    );
  }
}

class WarningButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const WarningButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      backgroundColor: AppColors.warning,
    );
  }
}

class FloatingActionCustomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const FloatingActionCustomButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.white,
      child: Icon(icon),
    );
  }
}
