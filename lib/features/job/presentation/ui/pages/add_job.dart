import 'dart:io';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/nigerian_states.dart';
import 'package:myplug_ca/core/domain/models/toast.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/custom_dropdown.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_input.dart';
import 'package:myplug_ca/features/job/domain/models/job_type.dart';
import 'package:myplug_ca/features/job/presentation/viewmodels/job_provider.dart';
import 'package:provider/provider.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  final List<String> _requirements = [];
  final TextEditingController _requirementController = TextEditingController();

  JobType? _selectedType;
  String? _location;
  File? _logoFile;
  bool submitting = false;

  // 📌 Pick Logo from Gallery
  Future<void> _pickLogo() async {
    final picked = await pickImage();
    if (picked != null) {
      setState(() {
        _logoFile = picked;
      });
    }
  }

  void _addRequirement() {
    if (_requirementController.text.trim().isNotEmpty) {
      setState(() {
        _requirements.add(_requirementController.text.trim());
        _requirementController.clear();
      });
    }
  }

  void _removeRequirement(int index) {
    setState(() {
      _requirements.removeAt(index);
    });
  }

  void _saveJob() async {
    if (_formKey.currentState!.validate() &&
        _selectedType != null &&
        _location != null &&
        _logoFile != null) {
      setState(() {
        submitting = true;
      });
      try {
        context
            .read<JobProvider>()
            .addJob(
              compantLogo: _logoFile!,
              title: _titleController.text.trim(),
              description: _descController.text.trim(),
              companyName: _companyController.text.trim(),
              salary: double.tryParse(_salaryController.text.trim()) ?? 0,
              location: _location!,
              requirements: _requirements,
              type: _selectedType!,
            )
            .then((_) {
          showToast(context, message: 'Success', type: ToastType.success);
          Navigator.pop(context);
          setState(() {
            submitting = false;
          });
        });
      } catch (e) {
        print(e.toString());
        showToast(context,
            message: 'Something went wrong', type: ToastType.error);
        setState(() {
          submitting = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'Add Job'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Job Title
              MyInput(
                controller: _titleController,
                labelText: "Job Title",
                prefixIcon: const Icon(Icons.work_outline),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter job title" : null,
              ),
              const SizedBox(height: 16),

              // Company
              MyInput(
                controller: _companyController,
                labelText: "Company Name",
                prefixIcon: const Icon(Icons.business),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter company name" : null,
              ),
              const SizedBox(height: 16),

              // Company Logo Upload
              Row(children: [
                _logoFile != null
                    ? CircleAvatar(
                        radius: 30,
                        backgroundImage: FileImage(_logoFile!),
                      )
                    : const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.image, size: 30),
                      ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _pickLogo,
                  icon: const Icon(Icons.upload),
                  label: const Text("Pick Logo"),
                ),
              ]),
              const SizedBox(height: 16),

              // Location
              CustomDropdown<String>(
                value: _location,
                items: nigerianStates,
                itemLabelBuilder: (type) =>
                    type.toString().split('.').last.toSentenceCase(),
                labelText: "Job Location",
                hintText: "Select job location",
                prefixIcon: Icons.category_outlined,
                validator: (v) => v == null ? "Select job type" : null,
                onChanged: (val) => setState(() => _location = val),
              ),
              const SizedBox(height: 16),

              // Salary
              MyInput(
                controller: _salaryController,
                keyboardType: TextInputType.number,
                labelText: "Salary",
              ),
              const SizedBox(height: 16),
              CustomDropdown<JobType>(
                value: _selectedType,
                items: JobType.values,
                itemLabelBuilder: (type) =>
                    type.toString().split('.').last.toSentenceCase(),
                labelText: "Job Type",
                hintText: "Select job type",
                prefixIcon: Icons.category_outlined,
                validator: (v) => v == null ? "Select job type" : null,
                onChanged: (val) => setState(() => _selectedType = val),
              ),

              const SizedBox(height: 16),

              // Description
              MyInput(
                controller: _descController,
                maxLines: 3,
                hintText: "Job Description",
              ),
              const SizedBox(height: 16),

              // Requirements
              Row(
                children: [
                  Expanded(
                    child: MyInput(
                      controller: _requirementController,
                      labelText: "Add Requirement",
                    ),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.add_circle, color: Color(0xFFDAA579)),
                    onPressed: _addRequirement,
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: _requirements
                    .asMap()
                    .entries
                    .map(
                      (entry) => Chip(
                        label: Text(entry.value),
                        onDeleted: () => _removeRequirement(entry.key),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),

              // Save Button

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitting ? null : _saveJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDAA579),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: submitting
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
                          "Save Job",
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
