import 'package:myplug_ca/core/constants/images.dart';
import 'package:myplug_ca/core/constants/location.dart';
import 'package:myplug_ca/core/constants/portfolios.dart';
import 'package:myplug_ca/core/constants/skills.dart';
import 'package:myplug_ca/core/constants/transactions.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

final List<MyplugUser> demoUsers = [
  MyplugUser(
    id: "1",
    email: "smoq@gmail.com",
    image: noUserImage,
    location: demoLocation,
    firstName: 'Smoq',
    lastName: 'Jerry',
    phone: '08948683749',
    bio: 'I am a professional web and mobile developer. Contact me on .....',
    skills: [...services.sublist(0, 3)],
    portfolios: demoPortfolios,
    testimonials: [],
    transactions: demoTransactions,
  ),
  MyplugUser(
    id: "1",
    email: "smoq@gmail.com",
    image: noUserImage,
    location: demoLocation,
    firstName: 'Smoq',
    lastName: 'Jerry',
    phone: '08948683749',
    bio: 'I am a professional web and mobile developer. Contact me on .....',
    skills: [...services.sublist(0, 3)],
    portfolios: demoPortfolios,
    testimonials: [],
    transactions: demoTransactions,
  ),
  MyplugUser(
    id: "1",
    email: "smoq@gmail.com",
    image: noUserImage,
    location: demoLocation,
    firstName: 'Smoq',
    lastName: 'Jerry',
    phone: '08948683749',
    bio: 'I am a professional web and mobile developer. Contact me on .....',
    skills: [...services.sublist(0, 3)],
    portfolios: demoPortfolios,
    testimonials: [],
    transactions: demoTransactions,
  ),
];
