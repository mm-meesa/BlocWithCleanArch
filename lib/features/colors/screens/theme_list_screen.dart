import 'package:flutter/material.dart';
import '../models/theme_item.dart';
import 'grid_view_screen.dart';

/// Mirrors the "Theme List" fragment (fragment_theme_list.xml).
/// Shows a scrollable list of available coloring-book themes; tapping one
/// opens GridViewScreen for that theme.
class ThemeListScreen extends StatefulWidget {
  const ThemeListScreen({super.key});

  @override
  State<ThemeListScreen> createState() => _ThemeListScreenState();
}

class _ThemeListScreenState extends State<ThemeListScreen> {
  bool _isRefreshing = false;

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final themes = kBuiltInThemes;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: themes.length,
        itemBuilder: (context, index) {
          final theme = themes[index];
          return _ThemeCard(
            theme: theme,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => GridViewScreen(theme: theme),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final ThemeItem theme;
  final VoidCallback onTap;

  const _ThemeCard({required this.theme, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Preview thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  theme.previewAsset,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theme.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${theme.imageCount} pages',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
