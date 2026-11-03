
import 'package:dsain/utils/constants.dart';
import 'package:flutter/material.dart';

class Customelevatedbutton extends StatelessWidget {
final VoidCallback? onpressed;
final String text;
final double? width; 
  const Customelevatedbutton({super.key, this.onpressed, required this.text,  this.width});

  @override
  Widget build(BuildContext context) {
    return   SizedBox(
              width:width ,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: onpressed,
                child:  Text(
                  text,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            );
  }
}