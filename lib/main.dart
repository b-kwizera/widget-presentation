import 'package:flutter/material.dart';

void main() => runApp(const MapViewerApp());

class MapViewerApp extends StatelessWidget {
  const MapViewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InteractiveViewer Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const MapViewerPage(),
    );
  }
}

class MapViewerPage extends StatefulWidget {
  const MapViewerPage({super.key});

  @override
  State<MapViewerPage> createState() => _MapViewerPageState();
}

class _MapViewerPageState extends State<MapViewerPage> {
  double _maxScale = 2.5;
  bool _panEnabled = true;
  bool _bigMargin = false;

  final TransformationController _controller = TransformationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Map Viewer')),
      body: Column(
        children: [
          Expanded(
            child: ClipRect(
              child: ColoredBox(
                color: Colors.blueGrey.shade100,
                child: InteractiveViewer(
                  transformationController: _controller,
                  maxScale: _maxScale,
                  panEnabled: _panEnabled,
                  boundaryMargin: _bigMargin
                      ? const EdgeInsets.all(200)
                      : EdgeInsets.zero,
                  child: const SizedBox(
                    width: 800,
                    height: 600,
                    child: CustomPaint(painter: _CampusMapPainter()),
                  ),
                ),
              ),
            ),
          ),
          _ControlPanel(
            maxScale: _maxScale,
            panEnabled: _panEnabled,
            bigMargin: _bigMargin,
            onMaxScale: (v) => setState(() => _maxScale = v),
            onPan: (v) => setState(() => _panEnabled = v),
            onMargin: (v) => setState(() => _bigMargin = v),
            onReset: () => _controller.value = Matrix4.identity(),
          ),
        ],
      ),
    );
  }
}

class _ControlPanel extends StatelessWidget {
  const _ControlPanel({
    required this.maxScale,
    required this.panEnabled,
    required this.bigMargin,
    required this.onMaxScale,
    required this.onPan,
    required this.onMargin,
    required this.onReset,
  });

  final double maxScale;
  final bool panEnabled;
  final bool bigMargin;
  final ValueChanged<double> onMaxScale;
  final ValueChanged<bool> onPan;
  final ValueChanged<bool> onMargin;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 150,
                  child: Text('maxScale: ${maxScale.toStringAsFixed(1)}x'),
                ),
                Expanded(
                  child: Slider(
                    value: maxScale,
                    min: 1,
                    max: 6,
                    divisions: 10,
                    onChanged: onMaxScale,
                  ),
                ),
              ],
            ),
            SwitchListTile(
              dense: true,
              title: Text('panEnabled: $panEnabled'),
              value: panEnabled,
              onChanged: onPan,
            ),
            SwitchListTile(
              dense: true,
              title: Text(
                'boundaryMargin: ${bigMargin ? 'all(200)' : 'zero'}',
              ),
              value: bigMargin,
              onChanged: onMargin,
            ),
            TextButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset view'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampusMapPainter extends CustomPainter {
  const _CampusMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint();

    fill.color = const Color(0xFFCDE8B5);
    canvas.drawRect(Offset.zero & size, fill);

    fill.color = const Color(0xFF9E9E9E);
    canvas.drawRect(Rect.fromLTWH(0, 280, size.width, 40), fill);
    canvas.drawRect(Rect.fromLTWH(380, 0, 40, size.height), fill);

    fill.color = const Color(0xFF8CCBF2);
    canvas.drawOval(const Rect.fromLTWH(560, 380, 200, 150), fill);

    _building(canvas, const Rect.fromLTWH(60, 60, 220, 150), 'Library',
        const Color(0xFFE57373));
    _building(canvas, const Rect.fromLTWH(480, 60, 240, 150), 'Lecture Hall',
        const Color(0xFFFFB74D));
    _building(canvas, const Rect.fromLTWH(60, 380, 220, 150), 'Cafeteria',
        const Color(0xFFBA68C8));
    _building(canvas, const Rect.fromLTWH(440, 400, 90, 110), 'Gym',
        const Color(0xFF4DB6AC));
  }

  void _building(Canvas canvas, Rect rect, String label, Color color) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      Paint()..color = color,
    );
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: rect.width);
    tp.paint(canvas, rect.center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
