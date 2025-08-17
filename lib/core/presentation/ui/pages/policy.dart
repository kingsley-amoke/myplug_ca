import 'package:flutter/material.dart';
import 'policy_page.dart'; // Import the reusable PolicyPage + helpers

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PolicyPage(
      title: "Privacy Policy",
      content: [
        policyBody(
          "MyPlug (\"we,\" \"us,\" or \"our\") provides a marketplace and service provider app (the \"App\") "
          "that connects customers with service providers. This Privacy Policy explains how we collect, "
          "use, share, and protect personal information through the App.",
        ),
        policyHeading("Information We Collect"),
        policyBody(
            "• Personal Information: name, email address, phone number, and physical address."),
        policyBody(
            "• Device Information: device type, operating system, and location data."),
        policyBody(
            "• Service Provider Information: business name, address, phone number, and services offered."),
        policyBody(
            "• Transaction Information: payment information, service details, and transaction history."),
        policyHeading("How We Collect Information"),
        policyBody(
            "• Directly from users through the App, website, or customer support."),
        policyBody(
            "• Automatically through the App, including device and location data."),
        policyBody(
            "• From third-party partners, such as payment processors and social media platforms."),
        policyHeading("How We Use Information"),
        policyBody("• Provide and improve the App's services."),
        policyBody("• Enhance user experience."),
        policyBody("• Offer customer support."),
        policyBody("• Conduct research and analytics."),
        policyBody("• Comply with legal obligations."),
        policyHeading("Sharing Information"),
        policyBody("• Authorized service providers."),
        policyBody("• Law enforcement agencies (with valid legal requests)."),
        policyBody("• Third-party partners (for research or analytics)."),
        policyBody("• Service Providers (to facilitate transactions)."),
        policyHeading("Security Measures"),
        policyBody("• Encryption."),
        policyBody("• Secure servers."),
        policyBody("• Firewalls."),
        policyBody("• Access controls."),
        policyHeading("Contact Us"),
        policyBody("MyPlug Mobile App"),
        policyBody("81 Agwangede Extension, Kuje, Abuja."),
        policyBody("Email: connect@myplugmobile.com"),
        policyBody("Phone: +2347017663503"),
        policyBody("Last Updated: 31 December 2024"),
      ],
    );
  }
}
