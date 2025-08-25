import 'package:flutter/material.dart';
import 'policy_page.dart'; // Import the reusable PolicyPage + helpers

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PolicyPage(
      title: "About FixNBuy",
      content: [
        policyHeading("Welcome to FixNBuy"),
        policyBody(
          "FixNBuy is a revolutionary service provider and marketplace app that connects customers with trusted professionals.",
        ),
        policyHeading("Our Story"),
        policyBody(
          "We founded FixNBuy to bridge the gap between customers and service providers, "
          "creating a platform for seamless interaction and business growth.",
        ),
        policyHeading("How It Works"),
        policyBody(
          "• Customers can browse and book services in various categories.\n"
          "• Service providers can showcase their skills and manage bookings effortlessly.",
        ),
        policyHeading("Our Values"),
        policyBody(
            "• Quality: We're committed to providing high-quality services that meet our customers' needs."),
        policyBody(
            "• Reliability: We're dedicated to building a platform that's reliable and trustworthy."),
        policyBody(
            "• Convenience: We're passionate about making it easy and convenient for customers to find and book services."),
        policyBody(
            "• Community: We believe in building a community of customers and service providers who support and trust each other."),
        policyHeading("Join Our Community"),
        policyBody(
          "Download our app today and experience the convenience of booking quality services at your fingertips.",
        ),
        policyHeading("Contact Us"),
        policyBody("Email: connect@FixNBuymobile.com"),
        policyBody("Phone: +2347017663503"),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            "© 2025 FixNBuy. All rights reserved.",
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
