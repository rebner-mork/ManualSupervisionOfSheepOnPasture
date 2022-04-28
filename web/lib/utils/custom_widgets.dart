import 'package:flutter/material.dart';

class InputFieldSpacer extends StatelessWidget {
  const InputFieldSpacer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 18);
  }
}

class LoadingData extends StatefulWidget {
  const LoadingData(
      {this.text = 'Laster inn...', this.smallCircleOnly = false, Key? key})
      : super(key: key);

  final String text;
  final bool smallCircleOnly;

  @override
  State<LoadingData> createState() => _LoadingDataState();
}

class _LoadingDataState extends State<LoadingData>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    _animationController.reset();

    _colorTween = _animationController.drive(
        ColorTween(begin: Colors.green.shade700, end: Colors.green.shade300));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: widget.smallCircleOnly
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: _colorTween,
                  strokeWidth: 2.5,
                ))
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                    height: 48,
                    width: 48,
                    child: CircularProgressIndicator(
                      valueColor: _colorTween,
                      strokeWidth: 6,
                    )),
                const SizedBox(height: 10),
                Text(
                  widget.text,
                  style: const TextStyle(fontSize: 16),
                )
              ]));
  }
}
