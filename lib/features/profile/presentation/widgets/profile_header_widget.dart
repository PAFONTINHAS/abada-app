import 'package:flutter/material.dart';


const Color _primaryPurple = Color(0xFF7C5CBF);
const Color _lightPurple = Color(0xFFF1EDFB);

/// Avatar + name + role

class ProfileHeaderWidget extends StatelessWidget {
  final String userName;
  final String roleLabel;

  const ProfileHeaderWidget({
    super.key,
    required this.userName,
    required this.roleLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 42,
                backgroundColor: _lightPurple,
                child: Icon(
                  Icons.person,
                  size: 42,
                  color: _primaryPurple,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: _primaryPurple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            userName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _lightPurple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              roleLabel,
              style: const TextStyle(
                color: _primaryPurple,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}