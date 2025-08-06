import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/images.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/custom_button.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/job/domain/models/job.dart';
import 'package:change_case/change_case.dart';
import 'package:myplug_ca/features/job/presentation/ui/pages/apply_job.dart';

class JobDetailsPage extends StatelessWidget {
  final Job job;
  const JobDetailsPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'Job Details'),
      bottomSheet: CustomButton(
          text: 'Apply Now',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ApplyJob(),
              ),
            );
          }),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: getScreenHeight(context) / 2.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40,
                      child: CircleAvatar(
                        radius: 30,
                        child: Image.asset(
                          noUserImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      job.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${formatPrice(amount: job.salary)}/month',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.location_city,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(job.location),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.work,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(job.type.name.toSentenceCase()),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Job Description',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                job.description,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Job Requirements',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                itemCount: job.requirements.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final String requirement = job.requirements[index];
                  return Text(
                    requirement,
                    style: const TextStyle(color: Colors.black),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
