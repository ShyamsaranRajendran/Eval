import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget> children;
  final bool initiallyExpanded;
  final Color? backgroundColor;
  final Color? collapsedBackgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Widget? trailing;
  final EdgeInsetsGeometry? tilePadding;
  final EdgeInsetsGeometry? childrenPadding;
  final void Function(bool)? onExpansionChanged;

  const CustomExpansionTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.children,
    this.initiallyExpanded = false,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.textColor,
    this.iconColor,
    this.trailing,
    this.tilePadding,
    this.childrenPadding,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: collapsedBackgroundColor ?? AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor ?? AppColors.textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              )
            : null,
        leading: icon != null
            ? Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.primary,
                  size: 20,
                ),
              )
            : null,
        trailing:
            trailing ??
            Icon(
              Icons.expand_more,
              color: iconColor ?? AppColors.textSecondary,
            ),
        initiallyExpanded: initiallyExpanded,
        backgroundColor: backgroundColor ?? AppColors.background,
        collapsedBackgroundColor: collapsedBackgroundColor ?? AppColors.surface,
        tilePadding:
            tilePadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding:
            childrenPadding ?? const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        onExpansionChanged: onExpansionChanged,
        children: children,
      ),
    );
  }
}

class SettingsExpansionTile extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final List<Widget> settings;
  final bool initiallyExpanded;

  const SettingsExpansionTile({
    super.key,
    required this.title,
    this.description,
    required this.icon,
    required this.settings,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: title,
      subtitle: description,
      icon: icon,
      initiallyExpanded: initiallyExpanded,
      children: settings,
    );
  }
}

class InfoExpansionTile extends StatelessWidget {
  final String title;
  final Map<String, String> infoItems;
  final IconData? icon;
  final bool initiallyExpanded;

  const InfoExpansionTile({
    super.key,
    required this.title,
    required this.infoItems,
    this.icon,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: title,
      subtitle: '${infoItems.length} items',
      icon: icon ?? Icons.info_outline,
      initiallyExpanded: initiallyExpanded,
      children: infoItems.entries
          .map((entry) => _buildInfoItem(context, entry.key, entry.value))
          .toList(),
    );
  }

  Widget _buildInfoItem(BuildContext context, String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$key:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class TaskExpansionTile extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> tasks;
  final void Function(Map<String, dynamic>)? onTaskTap;
  final void Function(Map<String, dynamic>)? onTaskToggle;

  const TaskExpansionTile({
    super.key,
    required this.title,
    required this.tasks,
    this.onTaskTap,
    this.onTaskToggle,
  });

  @override
  Widget build(BuildContext context) {
    final completedTasks = tasks
        .where((task) => task['completed'] == true)
        .length;

    return CustomExpansionTile(
      title: title,
      subtitle: '$completedTasks of ${tasks.length} completed',
      icon: Icons.task_alt,
      children: tasks.map((task) => _buildTaskItem(context, task)).toList(),
    );
  }

  Widget _buildTaskItem(BuildContext context, Map<String, dynamic> task) {
    final isCompleted = task['completed'] == true;

    return ListTile(
      leading: IconButton(
        icon: Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? AppColors.success : AppColors.grey,
        ),
        onPressed: () => onTaskToggle?.call(task),
      ),
      title: Text(
        task['title'] ?? 'Untitled Task',
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
          color: isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
        ),
      ),
      subtitle: task['description'] != null
          ? Text(
              task['description'],
              style: TextStyle(
                color: AppColors.textSecondary,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            )
          : null,
      trailing: task['priority'] != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getPriorityColor(task['priority']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                task['priority'].toString().toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: _getPriorityColor(task['priority']),
                ),
              ),
            )
          : null,
      onTap: () => onTaskTap?.call(task),
    );
  }

  Color _getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      case 'low':
        return AppColors.success;
      default:
        return AppColors.info;
    }
  }
}

class FilterExpansionTile extends StatelessWidget {
  final String title;
  final Map<String, bool> filters;
  final void Function(String, bool)? onFilterChanged;
  final VoidCallback? onClearAll;
  final VoidCallback? onSelectAll;

  const FilterExpansionTile({
    super.key,
    required this.title,
    required this.filters,
    this.onFilterChanged,
    this.onClearAll,
    this.onSelectAll,
  });

  @override
  Widget build(BuildContext context) {
    final selectedCount = filters.values.where((selected) => selected).length;

    return CustomExpansionTile(
      title: title,
      subtitle: '$selectedCount of ${filters.length} selected',
      icon: Icons.filter_list,
      trailing: PopupMenuButton<String>(
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'select_all', child: Text('Select All')),
          const PopupMenuItem(value: 'clear_all', child: Text('Clear All')),
        ],
        onSelected: (value) {
          switch (value) {
            case 'select_all':
              onSelectAll?.call();
              break;
            case 'clear_all':
              onClearAll?.call();
              break;
          }
        },
      ),
      children: filters.entries
          .map(
            (entry) => CheckboxListTile(
              title: Text(entry.key),
              value: entry.value,
              onChanged: (value) =>
                  onFilterChanged?.call(entry.key, value ?? false),
              activeColor: AppColors.primary,
            ),
          )
          .toList(),
    );
  }
}

class ActionExpansionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<ExpansionAction> actions;

  const ActionExpansionTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: title,
      subtitle: subtitle ?? '${actions.length} actions available',
      icon: icon ?? Icons.settings,
      children: actions
          .map(
            (action) => ListTile(
              leading: Icon(
                action.icon,
                color: action.color ?? AppColors.primary,
              ),
              title: Text(action.title),
              subtitle: action.description != null
                  ? Text(action.description!)
                  : null,
              onTap: action.onTap,
              trailing: const Icon(Icons.chevron_right),
            ),
          )
          .toList(),
    );
  }
}

class ExpansionAction {
  final String title;
  final String? description;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const ExpansionAction({
    required this.title,
    this.description,
    required this.icon,
    this.color,
    required this.onTap,
  });
}
