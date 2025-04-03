import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;
  final double height;
  final double width;
  final TextStyle textStyle;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFFE84A69), 
    this.height = 50.0,       // Altura padrão
    this.width = double.infinity, // Largura padrão: preenche toda a tela
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 18),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFE84A69), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () => onPressed(), 
        child: Text(
          text,
          style: textStyle, 
        ),
      ),
    );
  }
}
