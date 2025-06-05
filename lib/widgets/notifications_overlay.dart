import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../controllers/user_controller.dart';
import '../core/services/user_service.dart';

class NotificationsOverlay extends StatefulWidget {
  final VoidCallback onClose;
  const NotificationsOverlay({super.key, required this.onClose});

  @override
  State<NotificationsOverlay> createState() => _NotificationsOverlayState();
}

class _NotificationsOverlayState extends State<NotificationsOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offsetAnimation;
  late Animation<double> opacityAnimation;
  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    ));
    opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    ));
    controller.forward();
  }

  Future<void> close() async {
    await controller.reverse();
    widget.onClose();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _notificationCard(n) {
    final isUnread = !n.read;
    return Card(
      color: isUnread
          ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
          : Theme.of(context).cardColor,
      elevation: isUnread ? 2 : 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Stack(
          children: [
            Icon(
              n.read ? Icons.notifications : Icons.notifications_active,
              color: n.read
                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                  : Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            if (isUnread)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 1.5),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          n.title,
          style: TextStyle(
            fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              n.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isUnread
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).hintColor,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              timeago.format(n.createdAt, locale: 'en_short'),
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
        trailing: isUnread
            ? IconButton(
                icon: const Icon(Icons.check_circle_outline, color: Colors.amber),
                tooltip: 'mark_as_read'.tr,
                onPressed: () {
                  userController.markNotificationAsRead(n.id);
                  UserService().markNotificationAsRead(
                    userController.user.value!.id,
                    n.id,
                  );
                },
              )
            : null,
        onTap: isUnread
            ? () {
                userController.markNotificationAsRead(n.id);
                UserService().markNotificationAsRead(
                  userController.user.value!.id,
                  n.id,
                );
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Transparent barrier to catch taps outside the overlay
        Positioned.fill(
          child: GestureDetector(
            onTap: close,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
        ),
        // The animated overlay panel
        Positioned(
          top: kToolbarHeight + MediaQuery.of(context).padding.top + 8,
          right: 16,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return AnimatedOpacity(
                opacity: opacityAnimation.value,
                duration: const Duration(milliseconds: 200),
                child: AnimatedSlide(
                  offset: offsetAnimation.value,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutBack,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      constraints: const BoxConstraints(maxHeight: 420),
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 16,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Row(
                              children: [
                                const Icon(Icons.notifications, size: 22),
                                const SizedBox(width: 8),
                                Text(
                                  'notifications'.tr,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: close,
                                  tooltip: 'close'.tr,
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          // Notifications list
                          Expanded(
                            child: Obx(() {
                              final notifs = userController.notifications;
                              if (notifs.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: Text(
                                      'no_notifications'.tr,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                );
                              }
                              return ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                itemCount: notifs.length,
                                itemBuilder: (context, idx) =>
                                    _notificationCard(notifs[idx]),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
            
              },
            
          ),
        ),
      ],
    );
  }
}