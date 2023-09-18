import 'package:conduit/main.dart';
import 'package:flutter/material.dart';
import '../utils/AppColors.dart';

class ConduitStepper extends StatefulWidget {
  final int currentInde;
  void Function(int index) onTap;

  ConduitStepper({Key? key, this.currentInde = 0, required this.onTap})
      : super(key: key);

  @override
  State<ConduitStepper> createState() => _ConduitStepperState();
}

class _ConduitStepperState extends State<ConduitStepper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.5,
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                widget.onTap(0);
              },
              child: CircleAvatar(
                backgroundColor: widget.currentInde == 0
                    ? AppColors.primaryColor
                    : AppColors.steeprDisableColor,
                child: Text("1",
                    style: TextStyle(
                        color: widget.currentInde == 0
                            ? Colors.white
                            : AppColors.steeprDisableTextColor,
                        fontFamily: ConduitFontFamily.robotoMedium)),
              ),
            ),
            SizedBox(width: 80,
              child: Align(
                alignment: Alignment.center,
                child: Divider(
                  color: AppColors.steeprDisableColor,
                  thickness: 3,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                widget.onTap(1);
              },
              child: CircleAvatar(
                backgroundColor: widget.currentInde == 1
                    ? AppColors.primaryColor
                    : AppColors.steeprDisableColor,
                child: Text(
                  "2",
                  style: TextStyle(
                    color: widget.currentInde == 1
                        ? Colors.white
                        : AppColors.steeprDisableTextColor,
                    fontFamily: ConduitFontFamily.robotoMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
