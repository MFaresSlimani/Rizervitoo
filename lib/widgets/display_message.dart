import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes/app_theme.dart';

class DisplayMessage extends StatelessWidget {
  DisplayMessage({
    super.key,
    required this.isVisible,
    required this.message,
  });

  final RxBool isVisible;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return isVisible.value
          ? Card(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.isDarkMode.isTrue
                      ? Colors.grey[800]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(message),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        isVisible.value = false;
                      },
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink();
    });
  }
}
