import 'package:Rizervitoo/controllers/agency_offer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/agency_offer.dart';

class AgencyOfferList extends StatelessWidget {
  final RxList<AgencyOffer> offers;
  final bool isOwner;
  const AgencyOfferList(
      {super.key, required this.offers, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (offers.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Text('no_offers'.tr,
              style: Theme.of(context).textTheme.bodyLarge),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: offers.length,
        itemBuilder: (context, idx) {
          final offer = offers[idx];
          return _AgencyOfferTile(offer: offer, index: idx, isOwner: isOwner);
        },
      );
    });
  }
}

class _AgencyOfferTile extends StatefulWidget {
  final AgencyOffer offer;
  final int index;
  final bool isOwner;
  const _AgencyOfferTile(
      {required this.offer, required this.index, required this.isOwner});

  @override
  State<_AgencyOfferTile> createState() => _AgencyOfferTileState();
}

class _AgencyOfferTileState extends State<_AgencyOfferTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      elevation: isExpanded ? 8 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => isExpanded = !isExpanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      offer.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Text(
                    '${offer.price.toStringAsFixed(0)} DA',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                offer.wilaya,
                style: TextStyle(color: Colors.blueGrey[400]),
              ),
              if (isExpanded) ...[
                const Divider(height: 24),
                Text(
                  offer.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: widget.isOwner
                      ? TextButton.icon(
                          onPressed: () {
                            // Handle delete action
                            Get.defaultDialog(
                              title: 'confirm_delete'.tr,
                              middleText: 'delete_offer_confirmation'.tr,
                              onConfirm: () {
                                AgencyOfferController().deleteOffer(
                                  offer.id,
                                );
                                Get.back();
                              },
                              onCancel: () => Get.back(),
                            );
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: Text('delete'.tr,
                              style: const TextStyle(color: Colors.red)),
                        )
                      : const SizedBox.shrink(),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}
