import 'package:flutter/material.dart';
import 'policy_page.dart';

class DisclaimerPage extends StatelessWidget {
  const DisclaimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PolicyPage(
      title: "Disclaimer",
      content: [
        policyHeading("Disclaimer"),
        policyBody(
          "MyPlug is a platform that connects customers with independent service providers. "
          "By using our app, you acknowledge that you have read, understood, and agree to be bound by this disclaimer.",
        ),
        policyHeading("Limitation of Liability"),
        policyBody(
          "MyPlug is not responsible for any damages, losses, or injuries that may arise from the use of our platform "
          "or the services provided by our service providers. We do not guarantee the quality, safety, or suitability "
          "of the services provided by our service providers.",
        ),
        policyHeading("No Warranty"),
        policyBody(
          "Our platform and the services provided by our service providers are provided on an \"as is\" and \"as available\" basis. "
          "We disclaim all warranties, express or implied, including but not limited to the implied warranties of merchantability, "
          "fitness for a particular purpose, and non-infringement.",
        ),
        policyHeading("Assumption of Risk"),
        policyBody(
          "By using our platform, you assume all risks associated with the use of our platform and the services provided "
          "by our service providers. You acknowledge that you are responsible for your own actions and decisions, and that "
          "MyPlug is not responsible for any consequences that may arise from your use of our platform.",
        ),
        policyHeading("Release of Liability"),
        policyBody(
          "You release MyPlug, its officers, directors, employees, agents, and affiliates from any and all claims, demands, "
          "or causes of action that you may have arising from your use of our platform or the services provided by our service providers.",
        ),
        policyHeading("Indemnification"),
        policyBody(
          "You agree to indemnify and hold harmless MyPlug, its officers, directors, employees, agents, and affiliates from any "
          "and all claims, demands, or causes of action that may arise from your use of our platform or the services provided by our service providers.",
        ),
        policyHeading("Governing Law"),
        policyBody(
          "This disclaimer shall be governed by and construed in accordance with the laws of Federal Republic of Nigeria and that of other "
          "States, Countries and Regions where MyPlug is being used. Any disputes arising from this disclaimer shall be resolved through binding "
          "arbitration in accordance with the rules of the International Chamber of Commerce (ICC) Court of Arbitration and International Centre for Dispute Resolution (ICDR).",
        ),
        policyHeading("Changes to Disclaimer"),
        policyBody(
          "We reserve the right to modify or update this disclaimer at any time without notice. Your continued use of our platform after any changes "
          "to this disclaimer shall constitute your acceptance of the revised disclaimer.",
        ),
        policyHeading("Contact Us"),
        policyBody(
          "If you have any questions or concerns about this disclaimer, please contact us at connect@myplug.com or call 07017663503.",
        ),
        policyBody(
          "By using our platform, you acknowledge that you have read, understood, and agree to be bound by this disclaimer. "
          "If you do not agree to this disclaimer, please do not use our platform.",
        ),
        policyBody("Last Updated: 30th December, 2024"),
      ],
    );
  }
}
