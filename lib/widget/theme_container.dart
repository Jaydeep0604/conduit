import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';

class ThemeContainer extends StatelessWidget {
  ThemeContainer({
    Key? key,
    required this.child,
  }) : super(key: key);
  Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.white2
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     Color.fromARGB(255, 255, 255, 255),
        //     Color.fromARGB(255, 255, 255, 255),
        
        //   ],
        // ),
      ),
      child: child,
    );
  }
}
