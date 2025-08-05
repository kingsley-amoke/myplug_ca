
import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/images.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

class Profile extends StatelessWidget {

  final MyplugUser user;

  const Profile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'Profile'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: getScreenHeight(context) / 4,
              width: getScreenWidth(context),

              child: Image.asset(user.image ?? noUserImage),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullname,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user.skills.isNotEmpty ? user.skills[0].name : '',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user.bio ?? "",
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                const  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          unselectedLabelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          tabs: [
                            Tab(child: Text('Portfolio')),
                            Tab(child: Text('Testimonials')),
                          ],
                        ),

                        SizedBox(
                          height: 500,
                          child: TabBarView(
                            children: [Text('portfolio'), Text('testimonials')],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
