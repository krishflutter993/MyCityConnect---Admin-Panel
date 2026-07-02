import 'dart:io';

import 'package:addminsaid_mycity/models/service_model.dart';
import 'package:addminsaid_mycity/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddServiceScreen extends StatefulWidget {
  final ServiceModel? service;

  const AddServiceScreen({
    super.key,
    this.service,
  });

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final phoneController = TextEditingController();
  final imageController = TextEditingController();
  final descriptionController = TextEditingController();

  bool loading = false;

  File? selectedImage;

  final ImagePicker picker = ImagePicker();

  // ================= INIT =================

  @override
  void initState() {
    super.initState();

    // EDIT DATA SET

    if (widget.service != null) {
      nameController.text = widget.service!.name;

      categoryController.text = widget.service!.category;

      phoneController.text = widget.service!.phone;

      imageController.text = widget.service!.image;

      descriptionController.text = widget.service!.description;
    }
  }

  // ================= PICK IMAGE =================

  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                title: Text(
                  'Camera',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);

                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 70,
                  );

                  if (image != null) {
                    setState(() {
                      selectedImage = File(image.path);
                      imageController.text = image.path;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo,
                  color: Colors.white,
                ),
                title: Text(
                  'Gallery',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);

                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 70,
                  );

                  if (image != null) {
                    setState(() {
                      selectedImage = File(image.path);
                      imageController.text = image.path;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= SAVE SERVICE =================

  Future<void> saveService() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      // ================= UPDATE =================

      if (widget.service != null) {
        await ApiService.updateService(
          id: widget.service!.id,
          name: nameController.text.trim(),
          category: categoryController.text.trim(),
          phone: phoneController.text.trim(),
          description: descriptionController.text.trim(),
          image: imageController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '✅ Service Updated Successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // ================= ADD =================

        await ApiService.addService(
          name: nameController.text.trim(),
          category: categoryController.text.trim(),
          phone: phoneController.text.trim(),
          description: descriptionController.text.trim(),
          image: imageController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '✅ Service Added Successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  // ================= DISPOSE =================

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    phoneController.dispose();
    imageController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.service == null ? 'Add Service' : 'Edit Service',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= TOP CARD =================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.shade700,
                        Colors.deepPurple.shade400,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.service == null
                            ? 'Create New Service'
                            : 'Update Service',
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fill all details carefully',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ================= NAME =================

                buildField(
                  title: 'Service Name',
                  hint: 'Enter service name',
                  controller: nameController,
                  icon: Icons.business,
                ),

                const SizedBox(height: 18),

                // ================= CATEGORY =================

                buildField(
                  title: 'Category',
                  hint: 'Enter category',
                  controller: categoryController,
                  icon: Icons.category,
                ),

                const SizedBox(height: 18),

                // ================= PHONE =================

                buildField(
                  title: 'Phone Number',
                  hint: 'Enter phone number',
                  controller: phoneController,
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 18),

                // ================= IMAGE =================

                buildField(
                  title: 'Image',
                  hint: 'Select image',
                  controller: imageController,
                  icon: Icons.image,
                  suffixIcon: Icons.camera_alt,
                  onSuffixTap: pickImage,
                ),

                const SizedBox(height: 18),

                // ================= IMAGE PREVIEW =================

                if (selectedImage != null)
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: FileImage(selectedImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                const SizedBox(height: 18),

                // ================= DESCRIPTION =================

                buildField(
                  title: 'Description',
                  hint: 'Write service description',
                  controller: descriptionController,
                  icon: Icons.description,
                  maxLines: 4,
                ),

                const SizedBox(height: 35),

                // ================= BUTTON =================

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: loading ? null : saveService,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            widget.service == null
                                ? 'Add Service'
                                : 'Update Service',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= TEXT FIELD =================

  Widget buildField({
    required String title,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.white38,
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.purple,
            ),
            suffixIcon: suffixIcon != null
                ? IconButton(
                    onPressed: onSuffixTap,
                    icon: Icon(
                      suffixIcon,
                      color: const Color.fromARGB(255, 59, 58, 58),
                    ),
                  )
                : null,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.08),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $title';
            }

            return null;
          },
        ),
      ],
    );
  }
}
