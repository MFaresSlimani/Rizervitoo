import 'package:Rizervitoo/controllers/property_controller.dart';
import 'package:Rizervitoo/core/services/property_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Rizervitoo/core/services/reservation_service.dart';
import 'package:Rizervitoo/controllers/user_controller.dart';
import 'package:Rizervitoo/models/reservation_model.dart';
import 'package:path/path.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen>
    with SingleTickerProviderStateMixin {
  final ReservationService _reservationService = ReservationService();
  final userController = Get.find<UserController>();

  final RxList<ReservationModel> myReservations = <ReservationModel>[].obs;
  final RxList<ReservationModel> receivedReservations =
      <ReservationModel>[].obs;
  final RxBool isLoading = false.obs;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    final isOwner = userController.user.value?.isBusinessOwner ?? false;
    _tabController = TabController(length: isOwner ? 2 : 1, vsync: this);
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    final user = userController.user.value;
    if (user == null) return;
    // Fetch reservations made by the user
    final myRes = await _reservationService.fetchReservations(userId: user.id);
    myReservations.assignAll(myRes);
    // fetch current user properties ids
    final currentUserPropertiesIds =
        await PropertyService().fetchUserProperties(user.id);

    // If owner, fetch reservations for their property
    if (user.isBusinessOwner && currentUserPropertiesIds.isNotEmpty) {
      List<ReservationModel> allReceived = [];
      for (final propertyId in currentUserPropertiesIds) {
        // Fetch reservations for each property
        final receivedRes =
            await _reservationService.fetchReservations(propertyId: propertyId);
        allReceived.addAll(receivedRes);
      }
      receivedReservations.assignAll(allReceived);
    }
    isLoading.value = false;
  }

  Future<void> acceptReservation(String id) async {
    await _reservationService.updateReservationStatus(id,
        isAproved: true, isCanceled: false);
    fetchAll();
  }

  Future<void> cancelReservation(String id) async {
    await _reservationService.updateReservationStatus(id, isCanceled: true);
    fetchAll();
  }

  Widget _buildMyReservationCard(ReservationModel res) {
    return FutureBuilder<String?>(
      future: _reservationService.getPropertyNameById(res.propertyId),
      builder: (context, snapshot) {
        final propertyName = snapshot.data ?? 'Unknown';
        final isAccepted = res.isAproved == true && res.isCanceled != true;
        final isCanceled = res.isCanceled == true;
        final now = DateTime.now();
        final start = DateTime.tryParse(res.startDate) ?? now;
        final end = DateTime.tryParse(res.endDate) ?? now;
        final daysLeft = start.difference(now).inDays;
        final isActive = isAccepted && now.isBefore(end);

        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: isAccepted
              ? Colors.green.shade50
              : isCanceled
                  ? Colors.red.shade50
                  : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.home, color: Colors.blue[900], size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        propertyName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                    if (isAccepted)
                      Chip(
                        label: Text('accepted'.tr,
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                        backgroundColor: Colors.green.shade100,
                      )
                    else if (isCanceled)
                      Chip(
                        label: Text('canceled'.tr,
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                        backgroundColor: Colors.red.shade100,
                      )
                    else
                      Chip(
                        label: Text('pending'.tr,
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold)),
                        backgroundColor: Colors.orange.shade100,
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: Colors.grey[600], size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '${DateFormat('dd MMM yyyy').format(start)} - ${DateFormat('dd MMM yyyy').format(end)}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                if (res.additionalInfo != null &&
                    res.additionalInfo!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.note, color: Colors.blueGrey[400], size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            res.additionalInfo!,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isAccepted)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer, color: Colors.green[700], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            isActive
                                ? (daysLeft > 0
                                    ? daysLeft.toString() + 'days_left'.tr
                                    : 'ongoing'.tr)
                                : 'ended'.tr,
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceivedReservationCard(ReservationModel res) {
    return FutureBuilder<String?>(
      future: _reservationService.getPropertyNameById(res.propertyId),
      builder: (context, snapshot) {
        final propertyName = snapshot.data ?? 'Unknown';
        final isAccepted = res.isAproved == true && res.isCanceled != true;
        final isCanceled = res.isCanceled == true;
        final now = DateTime.now();
        final start = DateTime.tryParse(res.startDate) ?? now;
        final end = DateTime.tryParse(res.endDate) ?? now;

        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: isAccepted
              ? Colors.green.shade50
              : isCanceled
                  ? Colors.red.shade50
                  : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.deepPurple, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Reservation for $propertyName',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                    if (isAccepted)
                      Chip(
                        label: Text('accepted'.tr,
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                        backgroundColor: Colors.green.shade100,
                      )
                    else if (isCanceled)
                      Chip(
                        label: Text('canceled'.tr,
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                        backgroundColor: Colors.red.shade100,
                      )
                    else
                      Chip(
                        label: Text('pending'.tr,
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold)),
                        backgroundColor: Colors.orange.shade100,
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: Colors.grey[600], size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '${DateFormat('dd MMM yyyy').format(start)} - ${DateFormat('dd MMM yyyy').format(end)}',
                      style:
                          const TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  ],
                ),
                if (res.additionalInfo != null &&
                    res.additionalInfo!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.note, color: Colors.blueGrey[400], size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            res.additionalInfo!,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!isAccepted && !isCanceled)
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: Text('accept'.tr),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () async {
                              await acceptReservation(res.id);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.cancel, color: Colors.white),
                            label: Text('cancel'.tr),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () async {
                              await cancelReservation(res.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = userController.user.value?.isBusinessOwner ?? false;
    final theme = Theme.of(context);

    return DefaultTabController(
      length: isOwner ? 2 : 1,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: theme.primaryColor,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.send), text: 'my_reservations'.tr),
              if (isOwner)
                Tab(icon: Icon(Icons.inbox), text: 'received_reservations'.tr),
            ],
          ),
        ),
        body: Obx(() {
          if (isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return TabBarView(
            controller: _tabController,
            children: [
              RefreshIndicator(
                onRefresh: fetchAll,
                child: myReservations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.hourglass_empty,
                                size: 60, color: Colors.grey[400]),
                            const SizedBox(height: 12),
                            Text('no_reseservations_found'.tr,
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: myReservations.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, idx) =>
                            _buildMyReservationCard(myReservations[idx]),
                      ),
              ),
              if (isOwner)
                RefreshIndicator(
                  onRefresh: fetchAll,
                  child: receivedReservations.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox,
                                  size: 60, color: Colors.grey[400]),
                              const SizedBox(height: 12),
                              Text('no_received_reservations'.tr,
                                  style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: receivedReservations.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, idx) =>
                              _buildReceivedReservationCard(
                                  receivedReservations[idx]),
                        ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
