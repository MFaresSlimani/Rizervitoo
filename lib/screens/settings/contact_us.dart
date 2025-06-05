import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'Rezervitoo639@gmail.com',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '+213540328064',
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('contact_us'.tr),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // About Us Section
          Text(
            'about_us'.tr,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'about_us_description'.tr,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          // Contact Us Section
          Text(
            'contact_us'.tr,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.blue),
            title: Text('Rezervitoo639@gmail.com'),
            subtitle: Text('contact_email'.tr),
            onTap: _launchEmail,
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.green),
            title: Text('+213540328064'),
            subtitle: Text('contact_phone'.tr),
            onTap: _launchPhone,
          ),
        ],
      ),
    );
  }
}