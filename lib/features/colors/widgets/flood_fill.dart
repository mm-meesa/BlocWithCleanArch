import 'dart:typed_data';

/// Pure-Dart scanline (span-fill) flood-fill.
///
/// Equivalent to the Android `ColourImageView` fill logic:
///   • Converts the image pixel buffer to ARGB_8888 format.
///   • Replaces all contiguous pixels of [targetColor] reachable from
///     ([startX], [startY]) with [fillColor].
///   • Uses an iterative scanline approach to avoid stack-overflow on
///     large images.
///
/// [pixels]  – mutable RGBA byte buffer from `image.toByteData(format: ui.ImageByteFormat.rawRgba)`.
/// [width]   – image width in pixels.
/// [height]  – image height in pixels.
/// [startX]  – tap X position (integer pixel coordinate).
/// [startY]  – tap Y position (integer pixel coordinate).
/// [fillColor] – 0xAARRGGBB color to fill with.
/// [tolerance] – colour-channel tolerance (0 = exact match, 20 is a good default).
///
/// Returns `true` if any pixels were changed.
bool floodFill({
  required Uint8List pixels,
  required int width,
  required int height,
  required int startX,
  required int startY,
  required int fillColor,
  int tolerance = 20,
}) {
  if (startX < 0 || startX >= width || startY < 0 || startY >= height) {
    return false;
  }

  // Helper: byte index of pixel (x, y)
  int idx(int x, int y) => (y * width + x) * 4;

  // Read the target colour at the tap point.
  final si = idx(startX, startY);
  final targetR = pixels[si];
  final targetG = pixels[si + 1];
  final targetB = pixels[si + 2];
  final targetA = pixels[si + 3];

  // Fill colour channels (ARGB → RGBA storage)
  final fillA = (fillColor >> 24) & 0xFF;
  final fillR = (fillColor >> 16) & 0xFF;
  final fillG = (fillColor >> 8) & 0xFF;
  final fillB = fillColor & 0xFF;

  // Abort if target == fill (already the same colour).
  if (targetR == fillR &&
      targetG == fillG &&
      targetB == fillB &&
      targetA == fillA) {
    return false;
  }

  bool _matches(int x, int y) {
    final i = idx(x, y);
    return (pixels[i] - targetR).abs() <= tolerance &&
        (pixels[i + 1] - targetG).abs() <= tolerance &&
        (pixels[i + 2] - targetB).abs() <= tolerance &&
        (pixels[i + 3] - targetA).abs() <= tolerance;
  }

  void _paint(int x, int y) {
    final i = idx(x, y);
    pixels[i] = fillR;
    pixels[i + 1] = fillG;
    pixels[i + 2] = fillB;
    pixels[i + 3] = fillA;
  }

  // Scanline stack — each entry is [x, y, leftBound, rightBound, direction].
  // We push spans and process them iteratively.
  final stack = <_Span>[];
  stack.add(_Span(startX, startX, startY, 1));
  stack.add(_Span(startX, startX, startY - 1, -1));

  bool changed = false;

  while (stack.isNotEmpty) {
    final span = stack.removeLast();
    int left = span.left;
    final right = span.right;
    final y = span.y;
    final dy = span.dy;

    if (y < 0 || y >= height) continue;

    // Expand left
    int x = left;
    while (x >= 0 && _matches(x, y)) {
      _paint(x, y);
      changed = true;
      x--;
    }
    final newLeft = x + 1;

    // If we went further left than the span, scan that extension upward/downward.
    if (newLeft < left) {
      stack.add(_Span(newLeft, left - 1, y - dy, -dy));
    }

    x = left;
    while (x <= right) {
      // Expand right from current x.
      while (x <= width - 1 && _matches(x, y)) {
        _paint(x, y);
        changed = true;
        x++;
      }
      if (x > newLeft) {
        stack.add(_Span(newLeft < left ? newLeft : left, x - 1, y + dy, dy));
      }
      // Skip non-matching gap.
      final gapStart = x;
      while (x <= right && !_matches(x, y)) {
        x++;
      }
      if (x > gapStart) {
        stack.add(_Span(gapStart, x - 1, y - dy, -dy));
      }
      x++;
    }
  }

  return changed;
}

class _Span {
  final int left;
  final int right;
  final int y;
  final int dy;
  const _Span(this.left, this.right, this.y, this.dy);
}
