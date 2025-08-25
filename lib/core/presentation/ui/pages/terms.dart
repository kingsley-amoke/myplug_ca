import 'package:flutter/material.dart';
import 'policy_page.dart'; // Import the reusable PolicyPage + helpers

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PolicyPage(
      title: "Terms & Conditions",
      content: [
        policyHeading("Introduction"),
        policyBody(
          "FixNBuy (\"we,\" \"us,\" or \"our\") provides a marketplace and service providers app "
          "(the \"App\") that connects customers with service providers. These Terms and Conditions (\"Terms\") govern your use of the App.",
        ),
        policyHeading("Definitions"),
        policyBody("• App: The FixNBuy marketplace and service providers app."),
        policyBody("• User: Any individual using the App."),
        policyBody("• Customer: A User who requests services through the App."),
        policyBody(
            "• Service Provider: A User who offers services through the App."),
        policyHeading("User Agreement"),
        policyBody("• By using the App, you agree to these Terms."),
        policyBody("• You must be at least 18 years old to use the App."),
        policyBody(
            "• You warrant that you have the authority to enter into these Terms."),
        policyHeading("Payment Terms"),
        policyBody(
            "• Customers must pay for services through the App's payment system."),
        policyBody(
            "• Service Providers will receive payment for their services through the App's payment system."),
        policyBody(
            "• FixNBuy may charge a commission fee for each transaction."),
        policyHeading("Cancellation and Refund Policy"),
        policyBody(
            "• Customers may cancel a service request at any time before the service is completed."),
        policyBody(
            "• Service Providers may cancel a service request at any time before the service is completed."),
        policyBody(
            "• Refunds will be processed in accordance with FixNBuy's refund policy."),
        policyHeading("Governing Law"),
        policyBody(
          "These Terms shall be governed by and construed in accordance with the laws of the Federal Republic of Nigeria.",
        ),
        policyHeading("Contact Us"),
        policyBody("If you have any questions, please contact us at:"),
        policyBody("Email: connect@FixNBuymobile.com"),
        policyBody("Phone: +2347017663503"),
        policyBody("Address: 81 Agwangede Extension, Kuje, Abuja."),
        policyBody("Last Updated: December 31, 2024"),
      ],
    );
  }
}
