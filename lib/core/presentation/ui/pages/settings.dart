import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/images.dart';
import 'package:myplug_ca/core/constants/urls.dart';
import 'package:myplug_ca/core/presentation/ui/pages/about.dart';
import 'package:myplug_ca/core/presentation/ui/pages/discaimer_page.dart';
import 'package:myplug_ca/core/presentation/ui/pages/policy.dart';
import 'package:myplug_ca/core/presentation/ui/pages/terms.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:babstrap_settings_screen_updated/babstrap_settings_screen_updated.dart';
import 'package:myplug_ca/features/admin/presentation/ui/pages/dashboard.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/change_password.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/edit_profile.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/signin.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_media_buttons/social_media_buttons.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: myAppbar(
        context,
        title: 'Settings',
        implyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider provider, Widget? child) {
          final user = provider.myplugUser;

          return ListView(
            children: [
              // User card
              BigUserCard(
                backgroundColor: Colors.red,
                userName: user?.fullname ?? "Smoq Dev",
                userProfilePic: user?.image != null
                    ? NetworkImage(user!.image!)
                    : const AssetImage(noUserImage),
                cardActionWidget: SettingsItem(
                  icons: Icons.edit,
                  iconStyle: IconStyle(
                    withBackground: true,
                    borderRadius: 50,
                    backgroundColor: Colors.yellow[600],
                  ),
                  title: "Edit Profile",
                  subtitle: "Tap to edit your profile",
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const EditProfilePage()));
                  },
                ),
              ),

              SettingsGroup(
                backgroundColor: Colors.grey[300],
                settingsGroupTitle: "Account",
                items: [
                  SettingsItem(
                    onTap: () {
                      provider.myplugUser != null
                          ? provider.logout().then((v) {
                              navigator.popAndPushNamed('login');
                            })
                          : navigator.push(
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                    },
                    icons: Icons.exit_to_app_rounded,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.grey[200],
                      iconsColor: Colors.black,
                    ),
                    title: provider.myplugUser == null ? 'Sign In' : "Sign Out",
                  ),
                  SettingsItem(
                    onTap: () {
                      navigator.push(
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordPage(),
                        ),
                      );
                    },
                    icons: Icons.password,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.grey[200],
                      iconsColor: Colors.black,
                    ),
                    title: "Change Password",
                  ),
                  SettingsItem(
                    onTap: () {
                      navigator.push(
                        MaterialPageRoute(
                          builder: (_) => const AdminDashboardPage(),
                        ),
                      );
                    },
                    icons: Icons.dashboard,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.grey[200],
                      iconsColor: Colors.black,
                    ),
                    title: "Admin Dashboard",
                  ),
                ],
              ),

              SettingsGroup(
                settingsGroupTitle: "Terms and Policies",
                backgroundColor: Colors.grey[300],
                items: [
                  SettingsItem(
                    onTap: () {
                      navigator.push(
                        MaterialPageRoute(
                          builder: (_) => const AboutPage(),
                        ),
                      );
                    },
                    icons: Icons.info,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.grey[500],
                      iconsColor: Colors.white,
                    ),
                    title: "About",
                  ),
                  SettingsItem(
                    onTap: () {
                      navigator.push(
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyPage(),
                        ),
                      );
                    },
                    icons: Icons.privacy_tip,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.blue,
                      iconsColor: Colors.white,
                    ),
                    title: "Privacy Policy",
                  ),
                  SettingsItem(
                    onTap: () {
                      navigator.push(
                        MaterialPageRoute(
                          builder: (_) => const TermsAndConditionsPage(),
                        ),
                      );
                    },
                    icons: Icons.edit_document,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.white,
                      iconsColor: Colors.green,
                    ),
                    title: "Terms & Conditions",
                  ),
                  SettingsItem(
                    onTap: () {
                      navigator.push(
                        MaterialPageRoute(
                          builder: (_) => const DisclaimerPage(),
                        ),
                      );
                    },
                    icons: Icons.warning,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.black,
                      iconsColor: Colors.yellow,
                    ),
                    title: "Disclaimer",
                  ),
                ],
              ),

              SettingsGroup(
                backgroundColor: Colors.grey[300],
                settingsGroupTitle: "Follow Us",
                items: [
                  SettingsItem(
                    onTap: () {
                      openLink(MyplugLinks.facebook);
                    },
                    icons: SocialMediaIcons.facebook,
                    iconStyle: IconStyle(backgroundColor: Colors.blue),
                    title: "Facebook",
                  ),
                  SettingsItem(
                    onTap: () {
                      openLink(MyplugLinks.whatsapp);
                    },
                    icons: SocialMediaIcons.whatsapp,
                    iconStyle: IconStyle(backgroundColor: Colors.green),
                    title: "Whatsapp",
                  ),
                  SettingsItem(
                    onTap: () {
                      openLink(MyplugLinks.instagram);
                    },
                    icons: SocialMediaIcons.instagram,
                    iconStyle: IconStyle(backgroundColor: Colors.purple),
                    title: "Instagram",
                  ),
                  SettingsItem(
                    onTap: () {
                      openLink(MyplugLinks.twitter);
                    },
                    icons: SocialMediaIcons.twitter,
                    iconStyle: IconStyle(backgroundColor: Colors.black),
                    title: "X",
                  ),
                  SettingsItem(
                    onTap: () {
                      openLink(MyplugLinks.youtube);
                    },
                    icons: SocialMediaIcons.youtube,
                    iconStyle: IconStyle(backgroundColor: Colors.red),
                    title: "YouTube",
                  ),
                ],
              ),

              SettingsGroup(
                backgroundColor: Colors.grey[300],
                settingsGroupTitle: "Developer's Info",
                items: [
                  SettingsItem(
                    onTap: () {
                      openLink(DeveloperLinks.whatsapp);
                    },
                    icons: SocialMediaIcons.whatsapp,
                    iconStyle: IconStyle(backgroundColor: Colors.green),
                    title: "Whatsapp",
                  ),
                  SettingsItem(
                    onTap: () {
                      openLink(DeveloperLinks.portfolio);
                    },
                    icons: Icons.link,
                    iconStyle: IconStyle(backgroundColor: Colors.blue),
                    title: "Portfolio",
                  ),
                  SettingsItem(
                    onTap: () {
                      openLink(DeveloperLinks.facebook);
                    },
                    icons: SocialMediaIcons.facebook,
                    iconStyle: IconStyle(backgroundColor: Colors.blue),
                    title: "Facebook",
                  ),
                  SettingsItem(
                    onTap: () {
                      openLink(DeveloperLinks.github);
                    },
                    icons: SocialMediaIcons.github_circled,
                    iconStyle: IconStyle(backgroundColor: Colors.black),
                    title: "Github",
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
