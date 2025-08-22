import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// USAGE:
/// FlipCountdown(
///   endTime: DateTime.now().add(const Duration(days: 1, hours: 1)),
/// )
class FlipCountdown extends StatefulWidget {
  const FlipCountdown({
    super.key,
    required this.endTime,
    this.height = 64,
    this.width = 48,
    this.digitColor = Colors.white,
    this.backgroundColor = const Color(0xFF1E1E1E),
    this.separatorWidth = 10,
    this.borderRadius = 12,
    this.onDone,
    this.showDays = true,
  });

  final DateTime endTime;
  final double height;
  final double width;
  final double separatorWidth;
  final double borderRadius;
  final Color digitColor;
  final Color backgroundColor;
  final VoidCallback? onDone;
  final bool showDays;

  @override
  State<FlipCountdown> createState() => _FlipCountdownState();
}

class _FlipCountdownState extends State<FlipCountdown> {
  late Timer _timer;
  late Duration _remain;

  @override
  void initState() {
    super.initState();
    _remain = _calcRemain();
    _startTicker();
  }

  Duration _calcRemain() {
    final now = DateTime.now();
    return widget.endTime.isAfter(now)
        ? widget.endTime.difference(now)
        : Duration.zero;
  }

  void _startTicker() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final d = _calcRemain();
      if (!mounted) return;
      setState(() => _remain = d);
      if (d == Duration.zero) {
        _timer.cancel();
        widget.onDone?.call();
      }
    });
  }

  @override
  void didUpdateWidget(covariant FlipCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endTime != widget.endTime) {
      _timer.cancel();
      _remain = _calcRemain();
      _startTicker();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  int get _days => _remain.inDays;
  int get _hours => _remain.inHours.remainder(24);
  int get _minutes => _remain.inMinutes.remainder(60);
  int get _seconds => _remain.inSeconds.remainder(60);

  @override
  Widget build(BuildContext context) {
    final units = <_Unit>[
      if (widget.showDays) _Unit(_days, 'Days', minDigits: 2),
      _Unit(_hours, 'Hrs', minDigits: 2),
      _Unit(_minutes, 'Min', minDigits: 2),
      _Unit(_seconds, 'Sec', minDigits: 2),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < units.length; i++) ...[
          _FlipGroup(
            value: units[i].value,
            label: units[i].label,
            minDigits: units[i].minDigits,
            width: widget.width,
            height: widget.height,
            digitColor: widget.digitColor,
            backgroundColor: widget.backgroundColor,
            borderRadius: widget.borderRadius,
          ),
          if (i != units.length - 1) SizedBox(width: widget.separatorWidth),
        ],
      ],
    );
  }
}

class _Unit {
  final int value;
  final String label;
  final int minDigits;
  _Unit(this.value, this.label, {this.minDigits = 2});
}

class _FlipGroup extends StatefulWidget {
  const _FlipGroup({
    required this.value,
    required this.label,
    required this.minDigits,
    required this.width,
    required this.height,
    required this.digitColor,
    required this.backgroundColor,
    required this.borderRadius,
  });

  final int value;
  final String label;
  final int minDigits;
  final double width;
  final double height;
  final double borderRadius;
  final Color digitColor;
  final Color backgroundColor;

  @override
  State<_FlipGroup> createState() => _FlipGroupState();
}

class _FlipGroupState extends State<_FlipGroup> {
  late List<int> _digits;
  late List<int> _nextDigits;

  @override
  void initState() {
    super.initState();
    _digits = _split(widget.value, widget.minDigits);
    _nextDigits = _digits;
  }

  @override
  void didUpdateWidget(covariant _FlipGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _digits = _split(oldWidget.value, widget.minDigits);
      _nextDigits = _split(widget.value, widget.minDigits);
      setState(() {});
    }
  }

  List<int> _split(int v, int minDigits) {
    final s = v.toString().padLeft(minDigits, '0');
    return s.split('').map(int.parse).toList();
  }

  @override
  Widget build(BuildContext context) {
    final digitCount = _nextDigits.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(digitCount, (i) {
            final from = _digits[i];
            final to = _nextDigits[i];
            final changed = from != to;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _FlipTile(
                from: from,
                to: to,
                animate: changed,
                width: widget.width,
                height: widget.height,
                digitColor: widget.digitColor,
                backgroundColor: widget.backgroundColor,
                borderRadius: widget.borderRadius,
                onEnd: () {
                  if (i == digitCount - 1) {
                    // ensure digits settle after animation
                    _digits = _nextDigits;
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black.withOpacity(0.55),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _FlipTile extends StatefulWidget {
  const _FlipTile({
    required this.from,
    required this.to,
    required this.animate,
    required this.width,
    required this.height,
    required this.digitColor,
    required this.backgroundColor,
    required this.borderRadius,
    this.onEnd,
  });

  final int from;
  final int to;
  final bool animate;
  final double width;
  final double height;
  final double borderRadius;
  final Color digitColor;
  final Color backgroundColor;
  final VoidCallback? onEnd;

  @override
  State<_FlipTile> createState() => _FlipTileState();
}

class _FlipTileState extends State<_FlipTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _topFlip; // 0 -> 90°
  late Animation<double> _bottomFlip; // -90° -> 0°

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _topFlip = Tween(begin: 0.0, end: math.pi / 2).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _bottomFlip = Tween(begin: -math.pi / 2, end: 0.0).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
    if (widget.animate) _c.forward(from: 0);
    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onEnd?.call();
    });
  }

  @override
  void didUpdateWidget(covariant _FlipTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !_c.isAnimating) _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.width;
    final h = widget.height;
    final r = widget.borderRadius;

    Widget _card(int digit) => Container(
      width: w,
      height: h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(r),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.12),
          ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '$digit',
          style: TextStyle(
            color: widget.digitColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    // Split into top/bottom halves for flipping illusion
    Widget _halfCard({
      required int digit,
      required bool topHalf,
      required double angle,
      required Alignment alignment,
      bool clipEdge = true,
    }) {
      return ClipPath(
        clipper: _HalfClipper(topHalf: topHalf),
        child: Transform(
          alignment: alignment,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002) // perspective
            ..rotateX(angle),
          child: _card(digit),
        ),
      );
    }

    return SizedBox(
      width: w,
      height: h,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final showFromTop = _c.value < 0.5;
          return Stack(
            children: [
              // Static bottom half of next digit (visible during first half)
              Positioned.fill(
                child: _halfCard(
                  digit: widget.to,
                  topHalf: false,
                  angle: 0,
                  alignment: Alignment.topCenter,
                ),
              ),
              // Flipping top half: from current -> 90°
              Positioned.fill(
                child: _halfCard(
                  digit: widget.from,
                  topHalf: true,
                  angle: _topFlip.value,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              // Flipping bottom half: -90° -> to
              if (!showFromTop)
                Positioned.fill(
                  child: _halfCard(
                    digit: widget.to,
                    topHalf: false,
                    angle: _bottomFlip.value,
                    alignment: Alignment.topCenter,
                  ),
                ),
              // Static top half of current digit (visible during second half backdrop)
              if (showFromTop)
                Positioned.fill(
                  child: _halfCard(
                    digit: widget.to,
                    topHalf: true,
                    angle: 0,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _HalfClipper extends CustomClipper<Path> {
  _HalfClipper({required this.topHalf});
  final bool topHalf;

  @override
  Path getClip(Size size) {
    final path = Path();
    if (topHalf) {
      path.addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0, 0, size.width, size.height / 2),
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      );
    } else {
      path.addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      );
    }
    return path;
  }

  @override
  bool shouldReclip(covariant _HalfClipper oldClipper) =>
      oldClipper.topHalf != topHalf;
}

class AuctionTimer extends StatefulWidget {
  final DateTime endTime;
  const AuctionTimer({super.key, required this.endTime});

  @override
  State<AuctionTimer> createState() => _AuctionTimerState();
}

class _AuctionTimerState extends State<AuctionTimer> {
  late Timer _timer;
  Duration _remain = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calcRemain();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _calcRemain());
  }

  void _calcRemain() {
    final now = DateTime.now();
    setState(() {
      _remain = widget.endTime.isAfter(now)
          ? widget.endTime.difference(now)
          : Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _remain.inDays;
    final hours = _remain.inHours.remainder(24);
    final minutes = _remain.inMinutes.remainder(60);
    final seconds = _remain.inSeconds.remainder(60);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _timeBox(value: days, label: "Days"),
        const SizedBox(width: 6),
        _timeBox(value: hours, label: "Hrs"),
        const SizedBox(width: 6),
        _timeBox(value: minutes, label: "Min"),
        const SizedBox(width: 6),
        _timeBox(value: seconds, label: "Sec"),
      ],
    );
  }

  Widget _timeBox({required int value, required String label}) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class AuctionBanner extends StatefulWidget {
  final DateTime endTime;
  final String imageUrl; // asset or network

  const AuctionBanner({
    super.key,
    required this.endTime,
    required this.imageUrl,
  });

  @override
  State<AuctionBanner> createState() => _AuctionBannerState();
}

class _AuctionBannerState extends State<AuctionBanner> {
  late Timer _timer;
  Duration _remain = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calcRemain();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _calcRemain());
  }

  void _calcRemain() {
    final now = DateTime.now();
    setState(() {
      _remain = widget.endTime.isAfter(now)
          ? widget.endTime.difference(now)
          : Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _remain.inDays;
    final hours = _remain.inHours.remainder(24);
    final minutes = _remain.inMinutes.remainder(60);
    final seconds = _remain.inSeconds.remainder(60);

    return SizedBox(
      height: 160, // enough to hold image + overflow clock
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: widget.imageUrl.startsWith("http")
                    ? NetworkImage(widget.imageUrl)
                    : AssetImage(widget.imageUrl) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withOpacity(0.3),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Auction Ends In",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Countdown Row
          Positioned(
            bottom: -25,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _timeBox(value: days, label: "Days"),
                const SizedBox(width: 8),
                _timeBox(value: hours, label: "Hrs"),
                const SizedBox(width: 8),
                _timeBox(value: minutes, label: "Min"),
                const SizedBox(width: 8),
                _timeBox(value: seconds, label: "Sec"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeBox({required int value, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
