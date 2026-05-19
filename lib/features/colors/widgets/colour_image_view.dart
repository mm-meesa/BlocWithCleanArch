import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'flood_fill.dart';

class ColourImageView extends StatefulWidget {
  final String assetPath;
  final Color selectedColor;
  final int fillTolerance;
  final ValueChanged<bool>? onLoadingChanged;

  const ColourImageView({
    super.key,
    required this.assetPath,
    required this.selectedColor,
    this.fillTolerance = 20,
    this.onLoadingChanged,
  });

  @override
  State<ColourImageView> createState() => ColourImageViewState();
}

class ColourImageViewState extends State<ColourImageView> {
  // ───────────────── IMAGE STATE ─────────────────
  ui.Image? _sourceImage;
  ui.Image? _renderedImage;

  Uint8List? _pixels;

  int _imgWidth = 0;
  int _imgHeight = 0;

  bool _loading = true;

  // ───────────────── UNDO / REDO ─────────────────
  final List<Uint8List> _undoStack = [];
  final List<Uint8List> _redoStack = [];

  static const int _maxUndoSteps = 20;

  // ───────────────── PICK COLOR ─────────────────
  bool _pickColorMode = false;
  ValueChanged<Color>? _onColorPicked;

  // ───────────────── REPAINT ─────────────────
  final ValueNotifier<int> _repaintNotifier = ValueNotifier<int>(0);

  // ───────────────── LIFECYCLE ─────────────────

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAsset(widget.assetPath);
    });
  }

  @override
  void didUpdateWidget(covariant ColourImageView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.assetPath != widget.assetPath) {
      _loadAsset(widget.assetPath);
    }
  }

  @override
  void dispose() {
    _sourceImage?.dispose();
    _renderedImage?.dispose();
    _repaintNotifier.dispose();
    super.dispose();
  }

  // ───────────────── PUBLIC API ─────────────────

  bool get canUndo => _undoStack.isNotEmpty;

  bool get canRedo => _redoStack.isNotEmpty;

  bool undo() {
    if (_undoStack.isEmpty || _pixels == null) return false;

    _redoStack.add(Uint8List.fromList(_pixels!));
    _pixels = _undoStack.removeLast();

    _refreshRenderedImage();
    return true;
  }

  bool redo() {
    if (_redoStack.isEmpty || _pixels == null) return false;

    _undoStack.add(Uint8List.fromList(_pixels!));
    _pixels = _redoStack.removeLast();

    _refreshRenderedImage();
    return true;
  }

  void enablePickColor(ValueChanged<Color> onColorPicked) {
    _pickColorMode = true;
    _onColorPicked = onColorPicked;
  }

  void disablePickColor() {
    _pickColorMode = false;
    _onColorPicked = null;
  }

  Future<void> repaint() async {
    await _loadAsset(widget.assetPath);
  }

  Future<Uint8List?> exportImage() async {
    if (_pixels == null) return null;

    final completer = Completer<ui.Image>();

    ui.decodeImageFromPixels(
      _pixels!,
      _imgWidth,
      _imgHeight,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );

    final image = await completer.future;

    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    image.dispose();

    return byteData?.buffer.asUint8List();
  }

  // ───────────────── LOAD IMAGE ─────────────────

  Future<void> _loadAsset(String path) async {
    if (!mounted) return;

    widget.onLoadingChanged?.call(true);

    setState(() {
      _loading = true;
    });

    try {
      final data = await rootBundle.load(path);

      final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
      );

      final frame = await codec.getNextFrame();

      final image = frame.image;

      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );

      if (byteData == null) return;

      _sourceImage?.dispose();
      _sourceImage = image;

      _imgWidth = image.width;
      _imgHeight = image.height;

      _pixels = Uint8List.fromList(
        byteData.buffer.asUint8List(),
      );

      _undoStack.clear();
      _redoStack.clear();

      await _refreshRenderedImage();
    } catch (e) {
      debugPrint("Load asset error: $e");
    } finally {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      widget.onLoadingChanged?.call(false);
    }
  }

  // ───────────────── BUILD RENDER IMAGE ─────────────────

  Future<void> _refreshRenderedImage() async {
    if (_pixels == null) return;

    final completer = Completer<ui.Image>();

    ui.decodeImageFromPixels(
      _pixels!,
      _imgWidth,
      _imgHeight,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );

    final image = await completer.future;

    _renderedImage?.dispose();
    _renderedImage = image;

    if (mounted) {
      _repaintNotifier.value++;
      setState(() {});
    }
  }

  // ───────────────── TAP ACTION ─────────────────

  // Future<void> _onTapDown(
  //     TapDownDetails details,
  //     BoxConstraints constraints,
  //     ) async {
  //   if (_pixels == null || _renderedImage == null) return;
  //
  //   final renderW = constraints.maxWidth;
  //   final renderH = constraints.maxHeight;
  //
  //   final scaleX = _imgWidth / renderW;
  //   final scaleY = _imgHeight / renderH;
  //
  //   final tapX = (details.localPosition.dx * scaleX)
  //       .round()
  //       .clamp(0, _imgWidth - 1);
  //
  //   final tapY = (details.localPosition.dy * scaleY)
  //       .round()
  //       .clamp(0, _imgHeight - 1);
  //
  //   // PICK COLOR MODE
  //   if (_pickColorMode) {
  //     final i = (tapY * _imgWidth + tapX) * 4;
  //
  //     final picked = Color.fromARGB(
  //       _pixels![i + 3],
  //       _pixels![i],
  //       _pixels![i + 1],
  //       _pixels![i + 2],
  //     );
  //
  //     _onColorPicked?.call(picked);
  //
  //     _pickColorMode = false;
  //     _onColorPicked = null;
  //
  //     return;
  //   }
  //
  //   // NORMAL FILL MODE
  //
  //   final fillColor =
  //   (widget.selectedColor.alpha << 24) |
  //   (widget.selectedColor.red << 16) |
  //   (widget.selectedColor.green << 8) |
  //   widget.selectedColor.blue;
  //
  //   _undoStack.add(Uint8List.fromList(_pixels!));
  //
  //   if (_undoStack.length > _maxUndoSteps) {
  //     _undoStack.removeAt(0);
  //   }
  //
  //   _redoStack.clear();
  //
  //   final changed = floodFill(
  //     pixels: _pixels!,
  //     width: _imgWidth,
  //     height: _imgHeight,
  //     startX: tapX,
  //     startY: tapY,
  //     fillColor: fillColor,
  //     tolerance: widget.fillTolerance,
  //   );
  //
  //   if (changed) {
  //     await _refreshRenderedImage();
  //   } else {
  //     _undoStack.removeLast();
  //   }
  // }

  // ───────────────── UI ─────────────────

  Future<void> _onTapDown(TapDownDetails details) async {
    if (_pixels == null || _renderedImage == null) return;

    final RenderBox box =
    context.findRenderObject() as RenderBox;

    final Size widgetSize = box.size;

    final renderW = widgetSize.width;
    final renderH = widgetSize.height;

    final scaleX = _imgWidth / renderW;
    final scaleY = _imgHeight / renderH;

    final tapX = (details.localPosition.dx * scaleX)
        .floor()
        .clamp(0, _imgWidth - 1);

    final tapY = (details.localPosition.dy * scaleY)
        .floor()
        .clamp(0, _imgHeight - 1);

    if (_pickColorMode) {
      final i = (tapY * _imgWidth + tapX) * 4;

      final picked = Color.fromARGB(
        _pixels![i + 3],
        _pixels![i],
        _pixels![i + 1],
        _pixels![i + 2],
      );

      _onColorPicked?.call(picked);

      _pickColorMode = false;
      _onColorPicked = null;
      return;
    }

    final fillColor =
    (widget.selectedColor.alpha << 24) |
    (widget.selectedColor.red << 16) |
    (widget.selectedColor.green << 8) |
    widget.selectedColor.blue;

    _undoStack.add(Uint8List.fromList(_pixels!));

    if (_undoStack.length > _maxUndoSteps) {
      _undoStack.removeAt(0);
    }

    _redoStack.clear();

    final changed = floodFill(
      pixels: _pixels!,
      width: _imgWidth,
      height: _imgHeight,
      startX: tapX,
      startY: tapY,
      fillColor: fillColor,
      tolerance: widget.fillTolerance,
    );

    if (changed) {
      await _refreshRenderedImage();
    } else {
      _undoStack.removeLast();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("colour image view call==========");
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_renderedImage == null) {
      return const Center(
        child: Icon(Icons.broken_image, size: 60),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return InteractiveViewer(
          constrained: true,
          minScale: 0.5,
          maxScale: 8.0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) async {
              await _onTapDown(details);
            },
            child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: ValueListenableBuilder<int>(
                valueListenable: _repaintNotifier,
                builder: (_, __, ___) {
                  return CustomPaint(
                    painter: _PixelPainter(
                      image: _renderedImage!,
                    ),
                    size: Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// ───────────────── PAINTER ─────────────────

class _PixelPainter extends CustomPainter {
  final ui.Image image;

  _PixelPainter({
    required this.image,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final src = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );

    final dst = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );

    canvas.drawImageRect(
      image,
      src,
      dst,
      Paint(),
    );
  }

  @override
  bool shouldRepaint(covariant _PixelPainter oldDelegate) {
    return oldDelegate.image != image;
  }
}