import 'package:bid4style/Utils/Appcolor.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({Key? key, required this.isLoading, required this.child})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          AbsorbPointer(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(
                0.4,
              ), // 20% opacity for underlying widgets
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: AppColors.themecolor,
                  size: 50,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = false;

  void _toggleLoading() {
    setState(() {
      _isLoading = true;
      // Simulate a delay (e.g., API call)
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoadingOverlay(
        isLoading: _isLoading,
        child: Scaffold(
          appBar: AppBar(title: const Text('Loading Overlay Demo')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Tap the button to show loading'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _toggleLoading,
                  child: const Text('Show Loading'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
