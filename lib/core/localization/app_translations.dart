// ignore_for_file: equal_keys_in_map

import 'dart:ui';

import 'package:get/get.dart';

class AppTranslations extends Translations {
  static const Locale locale = Locale('en', 'US');
  static const Locale fallbackLocale = Locale('en', 'US');
  static void setLocale(Locale newLocale) {
    Get.updateLocale(newLocale);
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          // General
          'add': 'Add',
          'edit': 'Edit',
          'delete': 'Delete',
          'cancel': 'Cancel',
          'confirm': 'Confirm',
          'yes': 'Yes',
          'no': 'No',
          'close': 'Close',
          'success': 'Success',
          'error': 'Error',
          'loading': 'Loading...',
          'ok': 'OK',
          'filter': 'Filter',
          'apply': 'Apply',
          'reset': 'Reset',
          'save': 'Save',

          // Auth
          'login': 'Login',
          'signup': 'Sign Up',
          'email': 'Email',
          'password': 'Password',
          'name': 'Name',
          'already_have_account': 'Already have an account? Login',
          'dont_have_account': "Don't have an account? Sign Up",

          // Offers
          'offers': 'Offers',
          'add_offer': 'Add Offer',
          'offer_title': 'Offer Title',
          'offer_price': 'Offer Price',
          'no_offers': 'No offers yet.',
          'required': 'Required',
          // Home
          'properties': 'Properties',
          'agencies': 'Agencies',
          'favorites': 'Favorites',
          'reservations': 'Reservations',
          'profile': 'Profile',

          // Property
          'add_property': 'Add Property',
          'property_images': 'Property Images',
          'property_type': 'Property Type',
          'price': 'Price (DA)',
          'wilaya': 'Wilaya',
          'description': 'Description',
          'landmark': 'Landmark',
          'distance': 'Distance',
          'no_properties': 'No properties found.',
          'your_properties': 'Your Properties:',
          'cozy_apartment': 'e.g. Cozy Apartment in Downtown',

          // Agency
          'add_agency': 'Add Agency',
          'agency_details': 'Agency Details',
          'about_agency': 'About Agency',
          'call_agency': 'Call Agency',
          'no_agency': 'No agency found.',
          'your_agency': 'Your Agency:',
          'location': 'Location',
          'phone_number': 'Phone Number',
          'legal': 'Legal',
          'legal_text':
              'This agency is registered in accordance with local laws. All activities are subject to terms and conditions. For more information, contact the agency directly.',

          // Reservation
          'make_reservation': 'Make Reservation',
          'unavailable': 'Unavailable',
          'reservation_accepted': 'Reservation Accepted',
          'reservation_canceled': 'Reservation Canceled',
          'reservation_request_sent': 'Your reservation request has been sent!',
          'no_reservations': 'No reservations found.',
          'no_received_reservations': 'No received reservations.',
          'accept': 'Accept',
          'cancel_reservation': 'Cancel',

          // Notifications
          'notifications': 'Notifications',
          'no_notifications': 'No notifications yet.',
          'mark_as_read': 'Mark as read',

          // Profile
          'edit_profile': 'Edit Profile',
          'logout': 'Logout',
          'become_business_owner': 'Become a Business Owner',
          'you_are_business_owner': 'You are a Business Owner',

          // Settings
          'settings': 'Settings',
          'change_theme': 'Change Theme',
          'languages': 'Languages',

          // Misc
          'search_by_name': 'Search by name',
          'max_price_per_day': 'Max Price Per Day',
          'show_saved_only': 'Show Saved Only',
          'apply_filters': 'Apply Filters',
          'clear': 'Clear',
          'missing_info': 'Please fill all fields and select images.',
          'failed_to_create_property': 'Failed to create property.',
          'property_added': 'Property added successfully',
          'property_updated': 'Property updated successfully',
          'agency_added': 'Agency added successfully!',
          'failed_to_add_agency': 'Failed to add agency.',
          'user_not_found': 'User not found.',
          'failed_to_upload_image': 'Failed to upload image.',
          'failed_to_refresh_property': 'Failed to refresh property',
          'could_not_launch_dialer': 'Could not launch dialer',
          'no_properties_yet': 'No properties yet.',
          'no_agencies_yet': 'No agencies yet.',
          'preferences': 'Preferences',
          'account': 'Account',
          'support': 'Support',

          // Drawer
          'home': 'Home',
          'travel_guide': 'Travel Guide',
          'profile': 'Profile',
          'settings': 'Settings',
          'logout': 'Logout',

          // Property Card
          'km_from': 'km from',
          'da_per_night': 'DA / night',

          // Property Actions Bar
          'edit_property': 'Edit Property',
          'do_you_want_to_call': 'Do you want to call?',
          'you_are_about_to_call': 'You are about to call ',
          'call': 'Call',
          'call_owner': 'Call Owner ',

          // Notifications Overlay
          'notifications': 'Notifications',
          'no_notifications': 'No notifications yet.',
          'mark_as_read': 'Mark as read',

          // reservations
          'make_reservation': 'Make Reservation ',
          'choose_stay_dates': 'Choose your stay dates',
          'select_date_range': 'Select date range',
          'additional_info_optional': 'Additional Info (optional)',
          'send_reservation_request': 'Send Reservation Request',
          'missing_info': 'Missing Info',
          'fill_all_fields_and_select_dates':
              'Please fill all fields and select dates.',
          'unavailable': 'Unavailable',
          'property_not_available':
              'This property is not available for the selected dates.',
          'success': 'Success',
          'reservation_request_sent': 'Your reservation request has been sent!',
          'error': 'Error',
          'failed_to_make_reservation':
              'Failed to make reservation. Please try again.',

          // Agency Card
          'location': 'Location',

          // Reservation Screen
          'my_reservations': 'My Reservations',
          'received_reservations': 'Received Reservations',
          'accepted': 'Accepted',
          'canceled': 'Canceled',
          'pending': 'Pending',
          'days_left': ' days left',
          'ongoing': 'Ongoing',
          'ended': 'Ended',
          'no_reservations_found': 'No reservations found.',
          'reservation_for': 'Reservation for',

          // Additional English Translations
          'agency_name': 'Agency Name',
          'fill_all_fields_and_select_image':
              'Please fill all fields and select an image.',
          'agency_added_successfully': 'Agency added successfully!',
          'no_phone': 'No phone',
          'you_are_not_a_business_owner_yet':
              'You are not a business owner yet.',
          'become_a_business_owner_to_add_properties':
              'Become a business owner to add properties.',
          'your_agencies': 'Your Agencies:',
          'delete_agency': 'Delete Agency',
          'confirm_delete': 'Confirm Delete',
          'are_you_sure_you_want_to_delete_this_agency':
              'Are you sure you want to delete this agency?',
          'agency_deleted_successfully': 'Agency deleted successfully.',
          'failed_to_delete_agency': 'Failed to delete agency.',
          'add_high_quality_images_to_attract_more_guests_you_can_select_multiple_images':
              'Add high quality images to attract more guests. You can select multiple images.',
          'at_least_one_image_required': 'At least one image is required.',
          'basic_information': 'Basic Information',
          'title': 'Title',
          'enter_a_title': 'Enter a title',
          'select_a_type': 'Select a type',
          'enter_a_price': 'Enter a price',
          'describe_your_property': 'Describe your property',
          'landmark_distance': 'Landmark & Distance',
          'here_you_can_add_a_landmark_near_your_property_to_help_guests_find_it_more_easily':
              'Here you can add a landmark near your property to help guests find it more easily.',
          'distance_to_landmark': 'Distance to Landmark',
          'creating_property': 'Creating property...',
          'updating_property': 'Updating property...',
          'uploading_images': 'Uploading images...',
          'property_created_successfully': 'Property created successfully!',
          'property_updated_successfully': 'Property updated successfully!',
          'english': 'English',
          'french': 'French',
          'arabic': 'Arabic',
          'become_a_business_owner': 'Become a Business Owner',
          'you_are_now_a_business_owner': 'You are now a business owner.',
          'are_you_sure_you_want_to_become_a_business_owner':
              'Are you sure you want to become a business owner?',
          'profile_updated': 'Profile updated',
          'remove_host': 'Remove Host',
          'remove_host_description':
              'As a host, you can manage your properties and cancel listings. This feature is available for business owners only.',

          // Property Details Screen
          'dzd_night': 'DA / night',
          'km_to': 'km to',
          'owner': 'Owner',
          'description': 'Description',
          'delete_property': 'Delete Property',
          'property_deleted_successfully': 'Property deleted successfully.',

          // About & Contact Us
          'contact_us': 'Contact Us',
          'about_us': 'About Us',
          'about_us_description':
              'Rizervitoo is an app dedicated to helping tourism in Algeria. Discover, book, and explore properties and agencies with ease. Our mission is to make travel and tourism in Algeria simple and accessible for everyone.',
          'contact_email': 'Contact Email',
          'contact_phone': 'Contact Phone',
          'delete_offer_confirmation':
              'Are you sure you want to delete this offer?',
              'change_theme': 'Change Theme',
          'become_host': 'Become a Host',
          'you_are_host': 'You are a Host',
          'become_host_description':
              'As a host, you can add properties and manage your listings. This feature is available for business owners only.',
        },
        'fr': {
          // French translations
          'change_theme': 'Changer le thème',
          'add': 'Ajouter',
          'edit': 'Modifier',
          'delete': 'Supprimer',
          'cancel': 'Annuler',
          'confirm': 'Confirmer',
          'yes': 'Oui',
          'no': 'Non',
          'close': 'Fermer',
          'success': 'Succès',
          'error': 'Erreur',
          'loading': 'Chargement...',
          'ok': 'OK',
          'filter': 'Filtrer',
          'apply': 'Appliquer',
          'reset': 'Réinitialiser',
          // offers
          'offers': 'Offres',
          'add_offer': 'Ajouter une offre',
          'offer_title': 'Titre de l\'offre',
          'offer_price': 'Prix de l\'offre',
          'no_offers': 'Aucune offre pour le moment.',
          'required': 'Requis',

          'login': 'Connexion',
          'signup': "S'inscrire",
          'email': 'E-mail',
          'password': 'Mot de passe',
          'name': 'Nom',
          'already_have_account': 'Vous avez déjà un compte ? Connexion',
          'dont_have_account': "Vous n'avez pas de compte ? S'inscrire",

          'properties': 'Propriétés',
          'agencies': 'Agences',
          'favorites': 'Favoris',
          'reservations': 'Réservations',
          'profile': 'Profil',

          'add_property': 'Ajouter une propriété',
          'property_images': 'Images de la propriété',
          'property_type': 'Type de propriété',
          'price': 'Prix (DA)',
          'wilaya': 'Wilaya',
          'description': 'Description',
          'landmark': 'Point de repère',
          'distance': 'Distance',
          'no_properties': 'Aucune propriété trouvée.',
          'your_properties': 'Vos propriétés :',
          'cozy_apartment': 'ex : Appartement confortable au centre-ville',

          'add_agency': 'Ajouter une agence',
          'agency_details': "Détails de l'agence",
          'about_agency': "À propos de l'agence",
          'call_agency': "Appeler l'agence",
          'no_agency': "Aucune agence trouvée.",
          'your_agency': 'Votre agence :',
          'location': 'Emplacement',
          'phone_number': 'Numéro de téléphone',
          'legal': 'Mentions légales',
          'legal_text':
              "Cette agence est enregistrée conformément à la législation locale. Toutes les activités sont soumises aux conditions générales. Pour plus d'informations, contactez directement l'agence.",

          'make_reservation': 'Faire une réservation',
          'unavailable': 'Indisponible',
          'reservation_accepted': 'Réservation acceptée',
          'reservation_canceled': 'Réservation annulée',
          'reservation_request_sent':
              'Votre demande de réservation a été envoyée !',
          'no_reservations': 'Aucune réservation trouvée.',
          'no_received_reservations': 'Aucune réservation reçue.',
          'accept': 'Accepter',
          'cancel_reservation': 'Annuler',

          'notifications': 'Notifications',
          'no_notifications': 'Aucune notification.',
          'mark_as_read': 'Marquer comme lu',

          'edit_profile': 'Modifier le profil',
          'logout': 'Déconnexion',
          'become_business_owner': 'Devenir propriétaire professionnel',
          'you_are_business_owner': 'Vous êtes un propriétaire professionnel',

          'settings': 'Paramètres',
          'change_theme': 'Changer le thème',
          'languages': 'Langues',

          'search_by_name': 'Rechercher par nom',
          'max_price_per_day': 'Prix max par jour',
          'show_saved_only': 'Afficher seulement les favoris',
          'apply_filters': 'Appliquer les filtres',
          'clear': 'Effacer',
          'missing_info':
              'Veuillez remplir tous les champs et sélectionner des images.',
          'failed_to_create_property': 'Échec de la création de la propriété.',
          'property_added': 'Propriété ajoutée avec succès',
          'property_updated': 'Propriété mise à jour avec succès',
          'agency_added': 'Agence ajoutée avec succès !',
          'failed_to_add_agency': "Échec de l'ajout de l'agence.",
          'user_not_found': "Utilisateur non trouvé.",
          'failed_to_upload_image': "Échec du téléchargement de l'image.",
          'failed_to_refresh_property':
              'Échec de la mise à jour de la propriété',
          'could_not_launch_dialer': "Impossible d'ouvrir le composeur.",
          'no_properties_yet': 'Aucune propriété pour le moment.',
          'no_agencies_yet': 'Aucune agence pour le moment.',
          'preferences': 'Préférences',
          'account': 'Compte',
          'support': 'Support',

          // Drawer
          'home': 'Accueil',
          'travel_guide': 'Guide de voyage',
          'profile': 'Profile',
          'logout': 'Déconnexion',

          // Property Card
          'km_from': 'km de',
          'da_per_night': 'DA / nuit',

          // Property Actions Bar
          'edit_property': 'Modifier la propriété',
          'call_owner': 'Appeler le propriétaire ',
          'do_you_want_to_call_owner': 'Voulez-vous appeler le propriétaire ?',
          'about_to_call': 'Vous êtes sur le point d\'appeler ',
          'cancel': 'Annuler',
          'call': 'Appeler',
          'reserve': 'Reserver',
          'landmark_distance': 'Point de repère & Distance',
          'remove_host': 'Supprimer l\'hôte',
          'remove_host_description':
              'En tant qu\'hôte, vous pouvez gérer vos propriétés et annuler les annonces. Cette fonctionnalité est disponible uniquement pour les propriétaires professionnels.',

          // reservations
          'make_reservation': 'Faire une réservation ',
          'choose_stay_dates': 'Choisissez vos dates de séjour',
          'select_date_range': 'Sélectionnez la plage de dates',
          'additional_info_optional':
              'Informations supplémentaires (optionnel)',
          'send_reservation_request': 'Envoyer la demande de réservation',
          'missing_info': 'Informations manquantes',
          'fill_all_fields_and_select_dates':
              'Veuillez remplir tous les champs et sélectionner les dates.',
          'unavailable': 'Indisponible',
          'property_not_available':
              "Cette propriété n'est pas disponible pour les dates sélectionnées.",
          'success': 'Succès',
          'reservation_request_sent':
              'Votre demande de réservation a été envoyée !',
          'error': 'Erreur',
          'failed_to_make_reservation':
              'Échec de la réservation. Veuillez réessayer.',

          // Notifications Overlay
          'notifications': 'Notifications',
          'no_notifications': 'No notifications yet.',
          'mark_as_read': 'Mark as read',

          // Agency Card
          'location': 'Location',

          // Reservation Screen
          'my_reservations': 'mes réservations',
          'received_reservations': 'Réservations reçues',
          'accepted': 'accepté',
          'canceled': 'Annulé',
          'pending': 'En attente',
          'days_left': ' jours restants',
          'ongoing': 'En cours',
          'ended': 'Terminé',
          'no_reservations_found': 'Aucune réservation trouvée.',
          'reservation_for': 'Réservation pour',

          // Additional French Translations
          'agency_name': "Nom de l'agence",
          'fill_all_fields_and_select_image':
              'Veuillez remplir tous les champs et sélectionner une image.',
          'agency_added_successfully': 'Agence ajoutée avec succès !',
          'no_phone': 'Pas de téléphone',
          'you_are_not_a_business_owner_yet':
              "Vous n'êtes pas encore un propriétaire professionnel.",
          'become_a_business_owner_to_add_properties':
              'Devenez un propriétaire professionnel pour ajouter des propriétés.',
          'your_agencies': 'Vos agences :',
          'delete_agency': "Supprimer l'agence",
          'confirm_delete': 'Confirmer la suppression',
          'are_you_sure_you_want_to_delete_this_agency':
              'Êtes-vous sûr de vouloir supprimer cette agence ?',
          'agency_deleted_successfully': 'Agence supprimée avec succès.',
          'failed_to_delete_agency': "Échec de la suppression de l'agence.",
          'add_high_quality_images_to_attract_more_guests_you_can_select_multiple_images':
              'Ajoutez des images de haute qualité pour attirer plus de clients. Vous pouvez sélectionner plusieurs images.',
          'at_least_one_image_required': 'Au moins une image est requise.',
          'basic_information': 'Informations de base',
          'title': 'Titre',
          'enter_a_title': 'Entrez un titre',
          'select_a_type': 'Sélectionnez un type',
          'enter_a_price': 'Entrez un prix',
          'describe_your_property': 'Décrivez votre propriété',
          'here_you_can_add_a_landmark_near_your_property_to_help_guests_find_it_more_easily':
              'Vous pouvez ajouter un point de repère près de votre propriété pour aider les clients à la trouver plus facilement.',
          'distance_to_landmark': 'Distance au point de repère',
          'creating_property': 'Création de la propriété...',
          'updating_property': 'Mise à jour de la propriété...',
          'uploading_images': 'Téléchargement des images...',
          'property_created_successfully': 'Propriété créée avec succès !',
          'property_updated_successfully':
              'Propriété mise à jour avec succès !',
          'english': 'Anglais',
          'french': 'Français',
          'arabic': 'Arabe',
          'become_a_business_owner': 'Devenir propriétaire professionnel',
          'you_are_now_a_business_owner':
              'Vous êtes maintenant un propriétaire professionnel.',
          'are_you_sure_you_want_to_become_a_business_owner':
              'Êtes-vous sûr de vouloir devenir propriétaire professionnel ?',
          'profile_updated': 'Profil mis à jour',

          // Property Details Screen
          'dzd_night': 'DA / nuit',
          'km_to': 'km de',
          'owner': 'Propriétaire',
          'description': 'Description',
          'settings': 'Paramètres',
          'delete_property': 'Supprimer la propriété',
          'property_deleted_successfully': 'Propriété supprimée avec succès.',

          // About & Contact Us
          'contact_us': 'Contactez-nous',
          'about_us': 'À propos de nous',
          'about_us_description':
              "Rizervitoo est une application dédiée à l'aide au tourisme en Algérie. Découvrez, réservez et explorez des propriétés et des agences facilement. Notre mission est de rendre le voyage et le tourisme en Algérie simples et accessibles à tous.",
          'contact_email': 'E-mail de contact',
          'contact_phone': 'Téléphone de contact',
          'delete_offer_confirmation':
              'Êtes-vous sûr de vouloir supprimer cette offre ?',
              'become_host': 'Devenir hôte',
              'you_are_host': 'Vous êtes hôte',
              'become_host_description': 'En tant qu\'hôte, vous pouvez ajouter des propriétés et gérer vos annonces. Cette fonctionnalité est disponible uniquement pour les propriétaires professionnels.',
        },
        'ar': {
          // Arabic translations
          'add': 'إضافة',
          'edit': 'تعديل',
          'delete': 'حذف',
          'cancel': 'إلغاء',
          'confirm': 'تأكيد',
          'yes': 'نعم',
          'no': 'لا',
          'close': 'إغلاق',
          'success': 'نجاح',
          'error': 'خطأ',
          'loading': 'جار التحميل...',
          'ok': 'حسناً',
          'filter': 'تصفية',
          'apply': 'تطبيق',
          'reset': 'إعادة تعيين',

          // offers
          'offers': 'العروض',
          'add_offer': 'إضافة عرض',
          'offer_title': 'عنوان العرض',
          'offer_price': 'سعر العرض',
          'no_offers': 'لا توجد عروض حتى الآن.',
          'required': 'مطلوب',

          'login': 'تسجيل الدخول',
          'signup': 'إنشاء حساب',
          'email': 'البريد الإلكتروني',
          'password': 'كلمة المرور',
          'name': 'الاسم',
          'already_have_account': 'لديك حساب بالفعل؟ تسجيل الدخول',
          'dont_have_account': 'ليس لديك حساب؟ إنشاء حساب',

          'properties': 'العقارات',
            'agencies': 'الوكالات',
            'favorites': 'مفضلتي',
          'reservations': 'الحجوزات',
          'profile': 'الملف الشخصي',

          'add_property': 'إضافة عقار',
          'property_images': 'صور العقار',
          'property_type': 'نوع العقار',
          'price': 'السعر (دج)',
          'wilaya': 'الولاية',
          'description': 'الوصف',
          'landmark': 'معلم',
          'distance': 'المسافة',
          'no_properties': 'لا توجد عقارات.',
          'your_properties': 'عقاراتك:',
          'cozy_apartment': 'مثال: شقة مريحة في وسط المدينة',

          'add_agency': 'إضافة وكالة',
          'agency_details': 'تفاصيل الوكالة',
          'about_agency': 'عن الوكالة',
          'call_agency': 'اتصل بالوكالة',
          'no_agency': 'لا توجد وكالة.',
          'your_agency': 'وكالتك:',
          'location': 'الموقع',
          'phone_number': 'رقم الهاتف',
          'legal': 'قانوني',
          'legal_text':
              'هذه الوكالة مسجلة وفقًا للقوانين المحلية. جميع الأنشطة تخضع للشروط والأحكام. لمزيد من المعلومات، يرجى التواصل مع الوكالة مباشرة.',

          'make_reservation': 'إجراء حجز ',
          'unavailable': 'غير متوفر',
          'reservation_accepted': 'تم قبول الحجز',
          'reservation_canceled': 'تم إلغاء الحجز',
          'reservation_request_sent': 'تم إرسال طلب الحجز!',
          'no_reservations': 'لا توجد حجوزات.',
          'no_received_reservations': 'لا توجد حجوزات مستلمة.',
          'accept': 'قبول',
          'cancel_reservation': 'إلغاء',

          'notifications': 'الإشعارات',
          'no_notifications': 'لا توجد إشعارات.',
          'mark_as_read': 'وضع كمقروء',

          'edit_profile': 'تعديل الملف الشخصي',
          'logout': 'تسجيل الخروج',
          'become_business_owner': 'كن صاحب عمل',
          'you_are_business_owner': 'أنت صاحب عمل',

          'settings': 'الإعدادات',
          'change_theme': 'تغيير النمط',
          'languages': 'اللغات',

          'search_by_name': 'البحث بالاسم',
          'max_price_per_day': 'أقصى سعر لليوم',
          'show_saved_only': 'عرض المفضلة فقط',
          'apply_filters': 'تطبيق الفلاتر',
          'clear': 'مسح',
          'missing_info': 'يرجى ملء جميع الحقول واختيار الصور.',
          'failed_to_create_property': 'فشل في إنشاء العقار.',
          'property_added': 'تمت إضافة العقار بنجاح',
          'property_updated': 'تم تحديث العقار بنجاح',
          'agency_added': 'تمت إضافة الوكالة بنجاح!',
          'failed_to_add_agency': 'فشل في إضافة الوكالة.',
          'user_not_found': 'المستخدم غير موجود.',
          'failed_to_upload_image': 'فشل في رفع الصورة.',
          'failed_to_refresh_property': 'فشل في تحديث العقار',
          'could_not_launch_dialer': 'تعذر فتح تطبيق الاتصال.',
          'no_properties_yet': 'لا توجد عقارات حتى الآن.',
          'no_agencies_yet': 'لا توجد وكالات حتى الآن.',
          'preferences': 'التفضيلات',
          'account': 'الحساب',
          'support': 'الدعم',

          // Drawer
          'home': 'الصفحة الرئيسية',
          'travel_guide': 'الدليل السياحي',
          'profile': 'الملف الشخصي',
          'settings': 'الإعدادات',
          'logout': 'تسجيل الخروج',

          // reservations
          'make_reservation': 'إجراء حجز',
          'choose_stay_dates': 'اختر تواريخ الإقامة',
          'select_date_range': 'حدد نطاق التواريخ',
          'additional_info_optional': 'معلومات إضافية (اختياري)',
          'send_reservation_request': 'إرسال طلب الحجز',
          'missing_info': 'معلومات مفقودة',
          'fill_all_fields_and_select_dates':
              'يرجى ملء جميع الحقول واختيار التواريخ.',
          'unavailable': 'غير متوفر',
          'property_not_available': 'هذا العقار غير متوفر في التواريخ المحددة.',
          'success': 'نجاح',
          'reservation_request_sent': 'تم إرسال طلب الحجز!',
          'error': 'خطأ',
          'failed_to_make_reservation':
              'فشل في إجراء الحجز. يرجى المحاولة مرة أخرى.',

          // Property Card
          'km_from': 'كم من',
          'da_per_night': 'دج / الليلة',

          // Property Actions Bar
          'edit_property': 'تعديل العقار',
          'call_owner': 'اتصل بالمالك ',
          'do_you_want_to_call_owner': 'هل تريد الاتصال بالمالك؟',
          'about_to_call': ' أنت على وشك الاتصال بـ',
          'cancel': 'إلغاء',
          'call': 'اتصل',
          'reserve': 'احجز',
          'do_you_want_to_call': 'هل تريد الاتصال؟',
          'you_are_about_to_call': 'أنت على وشك الاتصال بـ ',

          // Notifications Overlay
          'notifications': 'إشعارات',
          'no_notifications': 'لا توجد إشعارات حتى الآن.',
          'mark_as_read': 'مقروء',

          // Agency Card
          'location': 'الموقع',

          // Reservation Screen
          'my_reservations': 'حجوزاتي',
          'received_reservations': 'الحجوزات المستلمة',
          'accepted': 'مقبول',
          'canceled': 'ملغى',
          'pending': 'قيد الانتظار',
          'days_left': ' أيام متبقية',
          'ongoing': 'جاري',
          'ended': 'انتهت',
          'no_reservations_found': 'لا توجد حجوزات.',
          'reservation_for': 'حجز لـ',
          'accept': 'قبول',
          'cancel': 'إلغاء',
          'save': 'حفظ',

          // Property Details Screen
          'dzd_night': 'دج / الليلة',
          'km_to': 'كم إلى',
          'owner': 'المالك',
          'description': 'الوصف',

          // Additional Arabic Translations
          'agency_name': 'اسم الوكالة',
          'fill_all_fields_and_select_image':
              'يرجى ملء جميع الحقول واختيار صورة.',
          'agency_added_successfully': 'تمت إضافة الوكالة بنجاح!',
          'no_phone': 'لا يوجد هاتف',
          'you_are_not_a_business_owner_yet': 'أنت لست صاحب عمل بعد.',
          'become_a_business_owner_to_add_properties':
              'كن صاحب عمل لإضافة العقارات.',
          'your_agencies': 'وكالاتك:',
          'delete_agency': 'حذف الوكالة',
          'confirm_delete': 'تأكيد الحذف',
          'are_you_sure_you_want_to_delete_this_agency':
              'هل أنت متأكد أنك تريد حذف هذه الوكالة؟',
          'agency_deleted_successfully': 'تم حذف الوكالة بنجاح.',
          'failed_to_delete_agency': 'فشل في حذف الوكالة.',
          'add_high_quality_images_to_attract_more_guests_you_can_select_multiple_images':
              'أضف صورًا عالية الجودة لجذب المزيد من الضيوف. يمكنك اختيار عدة صور.',
          'at_least_one_image_required': 'مطلوب صورة واحدة على الأقل.',
          'basic_information': 'معلومات أساسية',
          'title': 'العنوان',
          'enter_a_title': 'أدخل عنوانًا',
          'select_a_type': 'اختر نوعًا',
          'enter_a_price': 'أدخل السعر',
          'describe_your_property': 'وصف العقار',
          'here_you_can_add_a_landmark_near_your_property_to_help_guests_find_it_more_easily':
              'يمكنك إضافة معلم بالقرب من العقار لمساعدة الضيوف في العثور عليه بسهولة أكبر.',
          'distance_to_landmark': 'المسافة إلى المعلم',
          'creating_property': 'جاري إنشاء العقار...',
          'updating_property': 'جاري تحديث العقار...',
          'uploading_images': 'جاري رفع الصور...',
          'property_created_successfully': 'تم إنشاء العقار بنجاح!',
          'property_updated_successfully': 'تم تحديث العقار بنجاح!',
          'english': 'الإنجليزية',
          'french': 'الفرنسية',
          'arabic': 'العربية',
          'become_a_business_owner': 'كن صاحب عمل',
          'you_are_now_a_business_owner': 'أنت الآن صاحب عمل.',
          'are_you_sure_you_want_to_become_a_business_owner':
              'هل أنت متأكد أنك تريد أن تصبح صاحب عمل؟',
          'profile_updated': 'تم تحديث الملف الشخصي',
          'landmark_distance': 'المعلم والمسافة',
          'remove_host': 'إزالة المضيف',
          'remove_host_description':
              'بصفتك مضيفًا، يمكنك إدارة عقاراتك وإلغاء القوائم. هذه الميزة متاحة فقط لأصحاب الأعمال.',

          // About & Contact Us
          'about_us': 'معلومات عنا',
          'about_us_description':
              'Rizervitoo هو تطبيق مخصص لمساعدة السياحة في الجزائر. اكتشف، احجز، واستكشف العقارات والوكالات بسهولة. مهمتنا هي جعل السفر والسياحة في الجزائر بسيطة ومتاحة للجميع.',
          'contact_email': 'البريد الإلكتروني للتواصل',
          'contact_phone': 'هاتف التواصل',
          'delete_offer_confirmation': 'هل أنت متأكد أنك تريد حذف هذا العرض؟',
          'change_theme': 'تغيير النمط',
          'become_host': 'كن مضيفًا',
          'you_are_host': 'أنت مضيف',
          'become_host_description':
              'بصفتك مضيفًا، يمكنك إضافة عقارات وإدارة قوائمك. هذه الميزة متاحة فقط لأصحاب الأعمال.',
              'contact_us': 'اتصل بنا',
              'delete_property' : 'حذف العقار',
              'property_deleted_successfully': 'تم حذف العقار بنجاح.',
        },
      };
}
