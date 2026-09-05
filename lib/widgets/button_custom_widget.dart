import 'package:flutter/material.dart';

class ButtonCustomWidget extends StatelessWidget {
  final Color? backgroundColor;
  final String? title;
  final VoidCallback? onClick;
  final bool? loading;

  const ButtonCustomWidget({
    super.key,
    this.backgroundColor,
    this.title,
    this.onClick,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = loading == true;
    final isDisabled = isLoading || onClick == null;
    final color = backgroundColor ?? Colors.cyan;

    return Material(
      color: isDisabled ? color.withOpacity(0.6) : color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isDisabled ? null : onClick,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 17),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.4,
                    ),
                  )
                : Text(
                    title ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
