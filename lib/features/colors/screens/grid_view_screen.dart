import 'package:flutter/material.dart';
import '../models/theme_item.dart';
import 'paint_screen.dart';

/// Mirrors GridViewActivity (activity_gridview.xml + view_gridview_item.xml).
/// Shows all images for a given theme in a 2-column grid.
/// Tapping an image opens PaintScreen.
class GridViewScreen extends StatefulWidget {
  final ThemeItem theme;

  const GridViewScreen({super.key, required this.theme});

  @override
  State<GridViewScreen> createState() => _GridViewScreenState();
}

class _GridViewScreenState extends State<GridViewScreen> {
  bool _isRefreshing = false;

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final count = theme.imageCount;

    return Scaffold(
      appBar: AppBar(
        title: Text(theme.name),
        backgroundColor: const Color(0xFF6C3C73),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: GridView.builder(
          padding: const EdgeInsets.all(4),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: count,
          itemBuilder: (context, index) {
            final imageIndex = index + 1; // 1-based
            final assetPath = assetPathForImage(theme, imageIndex);
            return _GridItem(
              assetPath: assetPath,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PaintScreen(
                      theme: theme,
                      imageIndex: imageIndex,
                      assetPath: assetPath,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Single grid cell — mirrors view_gridview_item.xml.
/// Shows the coloring image and a lock overlay (gridenableImage, hidden by default).
class _GridItem extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;

  const _GridItem({required this.assetPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(2),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // gridImage
            Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
            // gridenableImage (lock icon) — hidden unless locked
            // Visibility(
            //   visible: false, // set true to show lock
            //   child: Image.asset('assets/images/lock.png', fit: BoxFit.cover),
            // ),
          ],
        ),
      ),
    );
  }
}
