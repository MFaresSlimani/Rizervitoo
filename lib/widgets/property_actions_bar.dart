import 'package:Rizervitoo/core/services/property_service.dart';
import 'package:Rizervitoo/core/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Rizervitoo/controllers/user_controller.dart';
import 'package:Rizervitoo/screens/properties/make_reservation.dart';
import 'package:Rizervitoo/screens/properties/property_details.dart';
import 'package:overflow_text_animated/src.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/properties/add_property_screen.dart';
import '../../models/user_model.dart';

class PropertyActionsBar extends StatelessWidget {
  final PropertyDetailScreen widget;
  final VoidCallback? onDeleteSuccess;

  PropertyActionsBar({
    super.key,
    required this.widget,
    this.onDeleteSuccess,
  });

  final UserController userController = Get.find<UserController>();

  Future<UserModel?> fetchOwner() async {
    try {
      return await UserService().getUserById(widget.property.ownerId);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: fetchOwner(),
      builder: (context, snapshot) {
        final owner = snapshot.data;
        final isOwner =
            owner != null && userController.user.value?.id == owner.id;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (owner == null) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Text('owner_not_found'.tr,
                style: const TextStyle(color: Colors.red)),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, -2),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: isOwner
              ? SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit, size: 20, color: Colors.white),
                          label: Text(
                            'edit_property'.tr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            fixedSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24)),
                              ),
                              builder: (context) => SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.edit,
                                          color: Colors.orange),
                                      title: Text('edit_property'.tr),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Get.to(() => AddPropertyScreen(
                                              property: widget.property,
                                            ));
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.delete,
                                          color: Colors.red),
                                      title: Text('delete_property'.tr),
                                      onTap: () async {
                                        final success =
                                            await PropertyService()
                                                .deleteProperty(
                                                    widget.property.id);
                                        Get.back();
                                        if (success && onDeleteSuccess != null) {
                                          onDeleteSuccess!();
                                        } else if (!success) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'failed_to_delete_property'
                                                      .tr),
                                              backgroundColor: Colors.redAccent,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.phone, size: 20, color: Colors.white),
                          label: OverflowTextAnimated(text: 'call_owner'.tr, style: TextStyle()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            fixedSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('do_you_want_to_call'.tr),
                                content: Text(
                                  '${'you_are_about_to_call'.tr} ${owner.name}: \n${owner.phoneNumber}',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text('cancel'.tr),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final Uri phoneUri = Uri(
                                          scheme: 'tel',
                                          path: owner.phoneNumber);
                                      if (await canLaunchUrl(phoneUri)) {
                                        await launchUrl(phoneUri);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Could not launch dialer'),
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                      }
                                      Get.back();
                                    },
                                    child: Text('call'.tr),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.calendar_today, size: 20, color: Colors.white),
                          label: OverflowTextAnimated(text: 'make_reservation'.tr,style: TextStyle(),),
                          
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            fixedSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Get.to(MakeReservationScreen(
                                propertyId: widget.property.id));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
