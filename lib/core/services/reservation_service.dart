import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Rizervitoo/core/services/user_service.dart';
import 'package:Rizervitoo/models/reservation_model.dart';
import 'property_service.dart';

class ReservationService {
  final supabase = Supabase.instance.client;

  // get property name by property ID
  Future<String?> getPropertyNameById(String propertyId) async {
    final response = await supabase
        .from('properties')
        .select('title')
        .eq('id', propertyId)
        .maybeSingle();
    return response?['title'] as String?;
  }

  // Create a new reservation and return the created reservation
  Future<ReservationModel?> createReservation({
    required String propertyId,
    required String startDate,
    required String endDate,
    String? additionalInfo,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      return null;
    }

    final response = await supabase.from('reservations').insert({
      'property_id': propertyId,
      'user_id': user.id,
      'start_date': startDate,
      'end_date': endDate,
      'additional_info': additionalInfo,
      'created_at': DateTime.now().toIso8601String(),
      'is_aproved': false,
      'is_canceled': false,
    }).select().single();
    final reservation = ReservationModel.fromJson(response);

    // Fetch property owner
    final property = await PropertyService().fetchPropertyById(propertyId);
    if (property != null) {
      await UserService().createNotificationForUser(
        userId: property.ownerId,
        title: 'New Reservation Request',
        body: 'You have a new reservation request for "${property.title}".',
      );
    }

    return reservation;
  }

  // Fetch all reservations, optionally filter by userId or propertyId
  Future<List<ReservationModel>> fetchReservations({String? userId, String? propertyId}) async {
    var query = supabase.from('reservations').select('*');
    if (userId != null) {
      query = query.eq('user_id', userId);
    }
    if (propertyId != null) {
      query = query.eq('property_id', propertyId);
    }
    final response = await query;
    return (response as List)
        .map((res) => ReservationModel.fromJson(res))
        .toList();
  }

  // Get a reservation by its ID
  Future<ReservationModel?> getReservationById(String id) async {
    final response = await supabase
        .from('reservations')
        .select('*')
        .eq('id', id)
        .maybeSingle();
    if (response == null) return null;
    return ReservationModel.fromJson(response);
  }

  // update a reservation status and updatedAt
  Future<void> updateReservationStatus(
    String reservationId, {
    bool? isAproved,
    bool? isCanceled,
  }) async {
    final updates = <String, dynamic>{};
    if (isAproved != null) updates['is_aproved'] = isAproved;
    if (isCanceled != null) updates['is_canceled'] = isCanceled;
    updates['updated_at'] = DateTime.now().toIso8601String();

    final response = await supabase
        .from('reservations')
        .update(updates)
        .eq('id', reservationId)
        .select()
        .maybeSingle();

    // Fetch reservation and involved users
    final reservation = await getReservationById(reservationId);
    if (reservation == null) return;

    final guestId = reservation.userId;
    final property = await PropertyService().fetchPropertyById(reservation.propertyId);
    final ownerId = property?.ownerId;

    if (isAproved == true) {
      // Notify guest: reservation accepted
      await UserService().createNotificationForUser(
        userId: guestId,
        title: 'Reservation Accepted',
        body: 'Your reservation for "${property?.title ?? 'a property'}" was accepted!',
      );
    } else if (isCanceled == true) {
      // Notify guest: reservation canceled
      await UserService().createNotificationForUser(
        userId: guestId,
        title: 'Reservation Canceled',
        body: 'Your reservation for "${property?.title ?? 'a property'}" was canceled.',
      );
      // Optionally, notify owner as well
      if (ownerId != null) {
        await UserService().createNotificationForUser(
          userId: ownerId,
          title: 'Reservation Canceled',
          body: 'A reservation for "${property?.title ?? 'your property'}" was canceled.',
        );
      }
    }
  }

  // Update an existing reservation and return the updated reservation
  Future<ReservationModel?> updateReservation(
    String id, {
    String? startDate,
    String? endDate,
    String? additionalInfo,
  }) async {
    final updates = <String, dynamic>{};
    if (startDate != null) updates['start_date'] = startDate;
    if (endDate != null) updates['end_date'] = endDate;
    if (additionalInfo != null) updates['additional_info'] = additionalInfo;

    final response = await supabase
        .from('reservations')
        .update(updates)
        .eq('id', id)
        .select()
        .maybeSingle();

    if (response == null) return null;
    return ReservationModel.fromJson(response);
  }

  // Delete a reservation by its ID and return the deleted reservation
  Future<ReservationModel?> deleteReservation(String id) async {
    final response = await supabase
        .from('reservations')
        .delete()
        .eq('id', id)
        .select()
        .maybeSingle();

    if (response == null) return null;
    return ReservationModel.fromJson(response);
  }

  // Check if a property is available for a given date range
  Future<bool> isPropertyAvailable(String propertyId, String startDate, String endDate) async {
    final response = await supabase
        .from('reservations')
        .select('*')
        .eq('property_id', propertyId)
        .lte('start_date', endDate)
        .gte('end_date', startDate)
        .eq('is_canceled', false); // Only consider active reservations

    // If any reservation overlaps, property is not available
    return (response as List).isEmpty;
  }
}