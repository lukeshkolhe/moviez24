import 'package:flutter/cupertino.dart';

class CustomLoadingIndicator extends StatelessWidget{
  final double size;
  const CustomLoadingIndicator({super.key, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: const CupertinoActivityIndicator(),
    );
  }

}