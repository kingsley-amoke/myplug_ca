import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/nigerian_states.dart';
import 'package:myplug_ca/core/domain/models/toast.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/custom_dropdown.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_input.dart';
import 'package:myplug_ca/features/job/domain/models/job.dart';
import 'package:myplug_ca/features/job/domain/models/job_type.dart';
import 'package:myplug_ca/features/job/presentation/viewmodels/job_provider.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class EditJobPage extends StatefulWidget {
  final Job job;
  const EditJobPage({super.key, required this.job});

  @override
  State<EditJobPage> createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _salaryController;
  late TextEditingController _companyController;
  late TextEditingController _requirementsController;
  late String _location;

  JobType? _selectedType;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final job = widget.job;
    _titleController = TextEditingController(text: job.title);
    _descriptionController = TextEditingController(text: job.description);
    _salaryController = TextEditingController(text: job.salary.toString());
    _companyController = TextEditingController(text: job.company);
    _requirementsController =
        TextEditingController(text: job.requirements.join(", "));
    _selectedType = job.type;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _salaryController.dispose();
    _companyController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  Future<void> _updateJob() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final userProvider = context.read<UserProvider>();
      final jobProvider = context.read<JobProvider>();

      await jobProvider.updateJob(
        user: userProvider.myplugUser!,
        job: widget.job,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        salary: double.tryParse(_salaryController.text) ?? 0,
        company: _companyController.text.trim(),
        location: _location,
        type: _selectedType!,
        requirements: _requirementsController.text
            .split(",")
            .map((e) => e.trim())
            .toList(),
      );

      if (mounted) {
        Navigator.pop(context);
        showToast(context,
            message: "Job updated successfully", type: ToastType.success);
      }
    } catch (e) {
      if (mounted) {
        showToast(context,
            message: "Job updated successfully", type: ToastType.success);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(
        context,
        title: "Edit Job",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              MyInput(
                controller: _titleController,
                labelText: "Job Title",
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              MyInput(
                controller: _descriptionController,
                labelText: "Description",
                maxLines: 3,
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              CustomDropdown<JobType>(
                items: JobType.values,
                value: widget.job.type,
                itemLabelBuilder: (type) => type.name.toSentenceCase(),
                labelText: "Job Type",
                hintText: "Select job type",
                prefixIcon: Icons.category_outlined,
                validator: (v) => v == null ? "Select job type" : null,
                onChanged: (val) => setState(() => _selectedType = val),
              ),
              const SizedBox(height: 12),
              MyInput(
                controller: _salaryController,
                labelText: "Salary",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              MyInput(
                controller: _companyController,
                labelText: "Company Name",
              ),

              const SizedBox(height: 12),
              CustomDropdown<String>(
                items: nigerianStates,
                itemLabelBuilder: (state) => state,
                value: widget.job.location,
                labelText: "Job Location",
                hintText: "Select job location",
                prefixIcon: Icons.category_outlined,
                validator: (v) => v == null ? "Select job type" : null,
                onChanged: (val) => setState(
                  () => _location = val ?? _location,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _requirementsController,
                decoration: const InputDecoration(
                    labelText: "Requirements (comma separated)"),
              ),
              const SizedBox(height: 20),

              // Save button with loading state
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _updateJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDAA579),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          "Update Job",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
