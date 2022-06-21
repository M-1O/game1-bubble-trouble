import 'package:flutter/material.dart';
import 'colors.dart';

class MyButton extends StatelessWidget {
  final IconData icon;
  final dynamic function;
  const MyButton({required this.icon, this.function, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: AppColors.button,
          height: 50,
          width: 50,
          child: Center(
            child: Icon(icon),
          ),
        ),
      ),
    );
  }
}
