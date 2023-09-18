import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/responsive.dart';
import 'package:flutter/material.dart';

class ThemeContainer extends StatelessWidget {
  ThemeContainer({
    Key? key,
    required this.child,
    this.screenSize,
  }) : super(key: key);
  Widget child;
  var screenSize;

  @override
  Widget build(BuildContext context) {
    return Responsive.isSmallScreen(context)
        ? Container(
            height: 760,
            width: 700,
            decoration: BoxDecoration(
              color: AppColors.white2,
              // gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: [
              //     Color.fromARGB(255, 255, 255, 255),
              //     Color.fromARGB(255, 255, 255, 255),
              //   ],
              // ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 227, 239, 228),
                  Color.fromARGB(255, 232, 241, 234),
                  Color.fromARGB(255, 234, 239, 236),
                  Color.fromARGB(255, 232, 241, 234),
                  Color.fromARGB(255, 227, 239, 228),
                ],
              ),
            ),
            child: child,
          )
        : SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.black,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 30,
                  left: screenSize.width / 3,
                  right: screenSize.width / 3,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 760,
                      width: 700,
                      decoration: BoxDecoration(
                        color: AppColors.white2,
                        borderRadius: BorderRadius.circular(10),
                        // gradient: LinearGradient(
                        //   begin: Alignment.topCenter,
                        //   end: Alignment.bottomCenter,
                        //   colors: [
                        //     AppColors.white2,
                        //     AppColors.white2,
                        //     AppColors.white2,
                        //     Colors.black,
                        //   ],
                        // ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 204, 224, 207),
                            Color.fromARGB(255, 223, 233, 225),
                            Color.fromARGB(255, 234, 239, 236),
                            Color.fromARGB(255, 223, 233, 225),
                            Color.fromARGB(255, 204, 224, 207),
                          ],
                        ),
                      ),
                      child: child,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
