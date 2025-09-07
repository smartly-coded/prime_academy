import 'package:flutter/material.dart';

/// ThreeTabsWidget
/// A self-contained Flutter widget that renders a header which looks like
/// a simple table header with 3 tappable "tabs". Tapping each tab shows
/// its corresponding content below. The header is styled to resemble a
/// table row (borders, equal columns) but the implementation uses a Row
/// of InkWell widgets so it's easy to customize.

class ThreeTabsWidget extends StatefulWidget {
  const ThreeTabsWidget({super.key});

  @override
  State<ThreeTabsWidget> createState() => _ThreeTabsWidgetState();
}

class _ThreeTabsWidgetState extends State<ThreeTabsWidget> {
  int _selectedIndex = 0;

  final List<String> _titles = ["Overview", "Details", "Stats"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header that looks like a table header with 3 equal columns
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedIndex = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 12.0,
                    ),
                    color: i == _selectedIndex
                        ? theme.colorScheme.primary.withOpacity(0.12)
                        : Colors.transparent,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _titles[i],
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 6),
                          // little indicator under the active tab
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            height: 3,
                            width: i == _selectedIndex ? 36 : 0,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Content area: switch content based on _selectedIndex
        // AnimatedSwitcher gives a smooth transition when changing tabs
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              axisAlignment: -1.0,
              child: child,
            ),
          ),
          child: _buildContent(_selectedIndex),
        ),
      ],
    );
  }

  // Build distinct content for each tab. Replace with real widgets.
  Widget _buildContent(int index) {
    switch (index) {
      case 0:
        return Container(
          key: const ValueKey(0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Overview content goes here. This area can contain cards, rows, or any widgets that represent a summary.',
            style: TextStyle(fontSize: 16),
          ),
        );
      case 1:
        return Container(
          key: const ValueKey(1),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Details:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Item A\n• Item B\n• Item C'),
            ],
          ),
        );
      case 2:
      default:
        return Container(
          key: const ValueKey(2),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Stats', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                'Here you can show charts, numbers, or a small grid of statistics.',
              ),
            ],
          ),
        );
    }
  }
}
