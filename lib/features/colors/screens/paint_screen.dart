import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/theme_item.dart';
import '../widgets/colour_image_view.dart';

// ── Palette colours (matches the TableLayout colours in activity_paint.xml) ──
const List<Color> _kRow1 = [
  Color(0xFFBE0472), Color(0xFFED008C), Color(0xFFF94CB2),
  Color(0xFF0154A4), Color(0xFF0083CB), Color(0xFF19C1F2),
  Color(0xFF4CB848), Color(0xFFA3F345), Color(0xFFC4D72D),
  Color(0xFFFF7E00),
];
const List<Color> _kRow2 = [
  Color(0xFFFFAE00), Color(0xFFFFCC00), Color(0xFFCDC527),
  Color(0xFFF8DE2C), Color(0xFFFDF87C), Color(0xFFCC0000),
  Color(0xFFFF2A2A), Color(0xFFFC637C), Color(0xFFF7AEC2),
  Color(0xFFFAC9C4),
];
const List<Color> _kAllColors = [..._kRow1, ..._kRow2];

/// Full-screen paint activity.
/// Mirrors activity_paint.xml, PaintActivity.kt, dialog_coloradvance.xml,
/// view_dialog_secondlay.xml (undo/redo/save/share row).
///
/// Layout (top → bottom):
///   ┌──────────────────────────────────────────────────┐
///   │  Top action bar: DELETE | SAVE  (dialog_coloradvance) │
///   ├──────────────────────────────────────────────────┤
///   │  Secondary bar: UNDO | REDO | PICK | MENU        │
///   ├──────────────────────────────────────────────────┤
///   │                                                  │
///   │           ColourImageView  (main canvas)         │
///   │                                                  │
///   ├──────────────────────────────────────────────────┤
///   │  Bottom: favourite-color slots + full palette    │
///   └──────────────────────────────────────────────────┘
class PaintScreen extends StatefulWidget {
  final ThemeItem theme;
  final int imageIndex;
  final String assetPath;

  const PaintScreen({
    super.key,
    required this.theme,
    required this.imageIndex,
    required this.assetPath,
  });

  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  final GlobalKey<ColourImageViewState> _canvasKey = GlobalKey();

  Color _selectedColor = const Color(0xFFED008C);

  // Four favourite-colour slots (mirrors current_pen1..4)
  final List<Color?> _favSlots = [null, null, null, null];
  int _activeFavSlot = 0;

  bool _isLoading = false;
  bool _isSaving = false;

  // ── Favourite-slot helpers ───────────────────────────────────────────────

  void _selectColor(Color c) {
    setState(() {
      _selectedColor = c;
      _favSlots[_activeFavSlot] = c;
    });
  }

  void _tapFavSlot(int slot) {
    setState(() {
      _activeFavSlot = slot;
      if (_favSlots[slot] != null) {
        _selectedColor = _favSlots[slot]!;
      }
    });
  }

  // ── Toolbar actions ──────────────────────────────────────────────────────

  Future<void> _save() async {
    final state = _canvasKey.currentState;
    if (state == null) return;

    setState(() => _isSaving = true);
    try {
      final bytes = await state.exportImage();
      if (bytes == null) {
        _toast('Save failed');
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      final folder = Directory('${dir.path}/PaintSaved');
      await folder.create(recursive: true);
      final file = File(
        '${folder.path}/${widget.theme.folderName}_${widget.imageIndex}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(bytes);
      _toast('Saved to: ${file.path}');
    } catch (e) {
      _toast('Save failed: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _share() async {
    final state = _canvasKey.currentState;
    if (state == null) return;

    final bytes = await state.exportImage();
    if (bytes == null) return;

    final tmp = await getTemporaryDirectory();
    final file = File('${tmp.path}/share_paint.png');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'I am playing 【Mujju Coloring】, Come and Play with me!',
    );
  }

  void _undo() {
    final ok = _canvasKey.currentState?.undo() ?? false;
    if (!ok) _toast('Nothing to undo');
  }

  void _redo() {
    final ok = _canvasKey.currentState?.redo() ?? false;
    if (!ok) _toast('Nothing to redo');
  }

  void _repaint() {
    _showConfirmDialog(
      title: 'REPAINT',
      message: 'Redrawing will delete the saved works, determined to redraw it?',
      onConfirm: () => _canvasKey.currentState?.repaint(),
    );
  }

  void _pickColor() {
    _canvasKey.currentState?.enablePickColor((picked) {
      setState(() {
        _selectedColor = picked;
        _favSlots[_activeFavSlot] = picked;
      });
      _toast('Color picked!');
    });
    _toast('Touch the color area you like, to take the color.');
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _showConfirmDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes')),
        ],
      ),
    );
    if (ok == true) onConfirm();
  }

  // ── Back-press guard (mirrors "Before leaving, need to save?") ───────────
  Future<bool> _onWillPop() async {
    final save = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        content: const Text('Before leaving, need to save your current work?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true);
            },
            child: const Text('Save & Exit'),
          ),
        ],
      ),
    );
    if (save == true) await _save();
    return true;
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFD3D3D3),
        body: SafeArea(
          child: Column(
            children: [
              _buildTopActionBar(),   // dialog_coloradvance equivalent
              _buildSecondaryBar(),   // view_dialog_secondlay equivalent
              // ── Canvas ──
              Expanded(
                child: ColourImageView(
                  key: _canvasKey,
                  assetPath: widget.assetPath,
                  selectedColor: _selectedColor,
                  onLoadingChanged: (v) {
                    if (mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() => _isLoading = v);
                        }
                      });
                    }
                  },
                ),
              ),
              // ── Bottom palette ──
              _buildBottomPalette(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Top bar: DELETE | SAVE  (mirrors dialog_coloradvance.xml) ────────────
  Widget _buildTopActionBar() {
    return Container(
      color: const Color(0xFF6C3C73),
      height: 50.h,
      child: Row(
        children: [
          _ActionBtn(
            icon: Icons.delete_outline,
            label: 'DELETE',
            onTap: _repaint,
          ),
          _ActionBtn(
            icon: Icons.share,
            label: 'SHARE',
            onTap: _share,
          ),
          _ActionBtn(
            icon: _isSaving
                ? null
                : Icons.save_alt,
            label: _isSaving ? '...' : 'SAVE',
            onTap: _isSaving ? null : _save,
          ),
        ],
      ),
    );
  }

  // ── Secondary bar: UNDO | REDO | PICK  (mirrors view_dialog_secondlay) ──
  Widget _buildSecondaryBar() {
    return Container(
      color: const Color(0xFF4A2857),
      height: 40.h,
      child: Row(
        children: [
          _ActionBtn(icon: Icons.undo, label: 'UNDO', onTap: _undo),
          _ActionBtn(icon: Icons.redo, label: 'REDO', onTap: _redo),
          _ActionBtn(icon: Icons.colorize, label: 'PICK', onTap: _pickColor),
          const Spacer(),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white)),
            ),
        ],
      ),
    );
  }

  // ── Bottom palette (mirrors the TableLayout + favourite slots) ───────────
  Widget _buildBottomPalette() {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: const Color(0xFF6C3C73), width: 2)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          // ── Four favourite slots (current_pen1..4) ──
          SizedBox(
            width: 60,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemCount: 4,
              itemBuilder: (_, i) {
                final slotColor = _favSlots[i] ?? Colors.white;
                return GestureDetector(
                  onTap: () => _tapFavSlot(i),
                  child: Container(
                    decoration: BoxDecoration(
                      color: slotColor,
                      border: Border.all(
                        color: _activeFavSlot == i
                            ? const Color(0xFF6C3C73)
                            : Colors.grey.shade400,
                        width: _activeFavSlot == i ? 2 : 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // ── Full colour palette (2 rows × 10 cols) ──
          Expanded(
            child: Column(
              children: [
                _buildColorRow(_kRow1),
                _buildColorRow(_kRow2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorRow(List<Color> colors) {
    return Expanded(
      child: Row(
        children: colors
            .map(
              (c) => Expanded(
                child: GestureDetector(
                  onTap: () => _selectColor(c),
                  child: Container(
                    color: c,
                    foregroundDecoration: _selectedColor == c
                        ? BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2))
                        : null,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ── Shared action-button widget ───────────────────────────────────────────────

class _ActionBtn extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionBtn({
    required this.label,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: Colors.white, size: 18),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
