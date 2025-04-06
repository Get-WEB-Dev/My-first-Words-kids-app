import 'package:flutter/material.dart';

class CartoonButton extends StatefulWidget {
  final String? text;
  final IconData? icon;
  final Color color;
  final Color shadowColor;
  final Color iconColor;
  final double size;
  final VoidCallback? onTap;
  final bool isCircular;

  const CartoonButton({
    super.key,
    this.text,
    this.icon,
    this.color = const Color(0xFF42A5F5),
    this.shadowColor = const Color(0xFFD6891D),
    this.iconColor = const Color.fromARGB(255, 255, 255, 255),
    this.size = 60.0,
    this.onTap,
    this.isCircular = true,
  }) : assert(text != null || icon != null,
            'Either text or icon must be provided');

  @override
  State<CartoonButton> createState() => _CartoonButtonState();
}

class _CartoonButtonState extends State<CartoonButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: _isPressed ? 0.95 : 1.0,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              center: Alignment(-0.2, -0.2),
              radius: 0.9,
              colors: [
                Color(0xFFF06292),
                Color(0xFFF06292),
              ],
              stops: [0.1, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: const Color(0xFFEC407A),
              width: 8,
            ),
          ),
          child: Stack(
            children: [
              // Stronger glossy highlight
              Positioned(
                top: widget.size * 0.05,
                left: widget.size * 0.05,
                child: Container(
                  width: widget.size * 0.7,
                  height: widget.size * 0.7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: const Alignment(-0.4, -0.4),
                      radius: 0.6,
                      colors: [
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              // Subtle inner shadows
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(-2, -2),
                      ),
                      BoxShadow(
                        color: const Color.fromARGB(255, 255, 255, 255)
                            .withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(1, 1),
                        spreadRadius: -8,
                        blurStyle: BlurStyle.inner,
                      ),
                    ],
                  ),
                ),
              ),
              // Icon or Text
              Center(
                child: widget.icon != null
                    ? Icon(
                        widget.icon,
                        size: widget.size * 0.6,
                        color: const Color.fromARGB(255, 250, 250, 249),
                      )
                    : Text(
                        widget.text!,
                        style: TextStyle(
                          fontSize: widget.size * 0.3,
                          fontWeight: FontWeight.bold,
                          color: widget.iconColor,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
