import 'package:flutter/material.dart';

class PremiumGiftButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color themeColor;
  final bool isLoading;

  const PremiumGiftButton({
    super.key,
    required this.text,
    this.onTap,
    required this.themeColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null || isLoading;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          gradient: isDisabled
              ? LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.1),
                  ],
                )
              : LinearGradient(
                  colors: [
                    themeColor,
                    themeColor.withBlue(200).withRed(100), // Dynamic tint
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: themeColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: isDisabled ? Colors.white24 : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}





























