import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/service_model.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= IMAGE =================

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              service.image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,

              // LOADING

              loadingBuilder: (
                context,
                child,
                loadingProgress,
              ) {
                if (loadingProgress == null) {
                  return child;
                }

                return Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.white10,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },

              // ERROR IMAGE

              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.white10,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.white54,
                      size: 50,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 15),

          // ================= NAME =================

          Text(
            service.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // ================= CATEGORY =================

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              service.category,
              style: GoogleFonts.poppins(
                color: Colors.purple.shade200,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ================= PHONE =================

          Row(
            children: [
              const Icon(
                Icons.phone,
                color: Colors.green,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  service.phone,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ================= DESCRIPTION =================

          Text(
            service.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.white60,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          // ================= BUTTONS =================

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // EDIT

              InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.orange,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // DELETE

              InkWell(
                onTap: onDelete,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
