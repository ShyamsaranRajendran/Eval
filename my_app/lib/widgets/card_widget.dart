import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? child;
  final VoidCallback? onTap;
  final Color? color;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double elevation;
  final double borderRadius;
  final Border? border;

  const CustomCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.child,
    this.onTap,
    this.color,
    this.backgroundColor,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.elevation = 2,
    this.borderRadius = 12,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final cardChild = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      child: child ?? _buildDefaultContent(context),
    );

    return Container(
      margin: margin,
      child: Card(
        elevation: elevation,
        color: backgroundColor ?? AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: border?.top ?? BorderSide.none,
        ),
        child: onTap != null
            ? InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(borderRadius),
                child: cardChild,
              )
            : cardChild,
      ),
    );
  }

  Widget _buildDefaultContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (color ?? AppColors.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color ?? AppColors.primary, size: 24),
          ),
          const SizedBox(height: 12),
        ],
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: title,
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (color ?? AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color ?? AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color ?? AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool isPositiveTrend;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    this.isPositiveTrend = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: title,
      backgroundColor: color.withOpacity(0.1),
      border: Border.all(color: color.withOpacity(0.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isPositiveTrend
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositiveTrend
                            ? Icons.trending_up
                            : Icons.trending_down,
                        size: 12,
                        color: isPositiveTrend
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        trend!,
                        style: TextStyle(
                          fontSize: 10,
                          color: isPositiveTrend
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;
  final Widget? trailing;

  const ActionCard({
    super.key,
    required this.title,
    this.description,
    required this.icon,
    this.color,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: title,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (color ?? AppColors.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color ?? AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          trailing ??
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
        ],
      ),
    );
  }
}

class LoadingCard extends StatelessWidget {
  final String? message;
  final double? height;

  const LoadingCard({super.key, this.message, this.height});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: message ?? 'Loading...',
      height: height ?? 100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyCard extends StatelessWidget {
  final String message;
  final IconData? icon;
  final VoidCallback? onRetry;

  const EmptyCard({super.key, required this.message, this.icon, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: message,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 48, color: AppColors.textSecondary),
              const SizedBox(height: 16),
            ],
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              TextButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
