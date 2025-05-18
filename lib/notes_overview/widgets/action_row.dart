import 'package:flutter/material.dart';
import 'package:octimemo/l10n/l10n.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';
import 'package:octimemo/service_locator/service_locator.dart';

class ActionRowOrFilter extends StatefulWidget {
  const ActionRowOrFilter({super.key});

  @override
  State<ActionRowOrFilter> createState() => _ActionRowOrFilterState();
}

class _ActionRowOrFilterState extends State<ActionRowOrFilter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _searchWidthAnimation;
  late Animation<double> _searchOpacityAnimation;
  late Animation<double> _actionsOpacityAnimation;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  final viewModel = getIt<NotesOverviewViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.isActiveSearch.addListener(_toggleSearch);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _searchWidthAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuint),
    );

    _searchOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1, curve: Curves.easeInOut),
      ),
    );

    _actionsOpacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.7, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    viewModel.isActiveSearch.removeListener(_toggleSearch);
    _animationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    final activated = viewModel.isActiveSearch.value;

    if (activated) {
      _animationController.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _searchFocusNode.requestFocus();
      });
    } else {
      _animationController.reverse();
      _searchFocusNode.unfocus();
      _searchController.clear();
      viewModel.clearQuery();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Action buttons row (options and date picker)
              ValueListenableBuilder(
                valueListenable: viewModel.isActiveSearch,
                builder: (context, activated, child) {
                  return IgnorePointer(
                    ignoring: activated,
                    child: child,
                  );
                },
                child: Opacity(
                  opacity: _actionsOpacityAnimation.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side: Options menu with material icon
                      _ActionButton(
                        icon: Icons.menu,
                        label: l10n.overviewOptionsMenuLabel,
                        onTap: viewModel.openMenu,
                      ),

                      // Right side: Date picker with nice animation
                      Row(
                        children: [
                          _ActionButton(
                            icon: Icons.date_range,
                            label: l10n.overviewDatePickerLabel,
                            child: const DatePickerButton(),
                          ),
                          const SizedBox(width: 8),
                          _SearchToggleButton(
                            onTap: viewModel.toggleSearch,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Search field with width animation
              if (_searchWidthAnimation.value > 0)
                Positioned.fill(
                  child: Row(
                    children: [
                      // Back button when search is active
                      Opacity(
                        opacity: _searchOpacityAnimation.value,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: viewModel.toggleSearch,
                          tooltip: l10n.close,
                        ),
                      ),

                      // Expanding search field
                      Expanded(
                        child: Opacity(
                          opacity: _searchOpacityAnimation.value,
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            onChanged: viewModel.changeQuery,
                            decoration: InputDecoration(
                              hintText: l10n.overviewInputSearchHint,
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        viewModel.clearQuery();
                                      },
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchToggleButton extends StatelessWidget {
  const _SearchToggleButton({
    required this.onTap,
  });
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: onTap,
      tooltip: context.l10n.search,
      style: IconButton.styleFrom(
        backgroundColor: ColorScheme.of(context).surfaceContainerLow,
        foregroundColor: ColorScheme.of(context).onSurface,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.child,
  });
  final IconData icon;
  final String label;
  final Widget? child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: label,
      child: child ??
          IconButton(
            icon: Icon(icon),
            onPressed: onTap,
            style: IconButton.styleFrom(
              backgroundColor: ColorScheme.of(context).surfaceContainerLow,
              foregroundColor: theme.colorScheme.onSurface,
            ),
          ),
    );
  }
}
