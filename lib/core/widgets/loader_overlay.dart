import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoaderOverlay extends StatelessWidget {
  final String assets;
  final double size;
  final bool repeats;

  const LoaderOverlay({
    super.key,
    this.assets = 'assets/animations/lottie/loading_hand.json',
    this.size = 200,
    this.repeats = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
          height: size,
          width: size,
          child: Lottie.asset(assets, fit: BoxFit.contain, repeat: repeats),
        ),
      ),
    );
  }
}
