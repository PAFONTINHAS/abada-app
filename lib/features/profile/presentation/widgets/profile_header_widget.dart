import 'package:flutter/material.dart';
import 'editable_profile_header_widget.dart';

const Color _primaryPurple = Color(0xFF7C5CBF);
const Color _lightPurple = Color(0xFFF1EDFB);

/// Avatar + name + role
class ProfileHeaderWidget extends StatelessWidget {
  final String userName;
  final String roleLabel;
  final String cityLabel;
  final String photoUrl;
  final bool isEditable;
  final bool isUploadingPhoto;
  final VoidCallback? onChangePhoto;
  final double avatarRadius;

  const ProfileHeaderWidget({
    super.key,
    required this.userName,
    required this.roleLabel,
    this.cityLabel = '',
    required this.photoUrl,
    this.isEditable = false,
    this.isUploadingPhoto = false,
    this.onChangePhoto,
    this.avatarRadius = 42,
  });

  @override
  Widget build(BuildContext context) {
    if (isEditable) {
      return EditableProfileHeaderWidget(
        userName: userName,
        roleLabel: roleLabel,
        cityLabel: cityLabel,
        photoUrl: photoUrl,
        isUploadingPhoto: isUploadingPhoto,
        onChangePhoto: onChangePhoto,
      );
    }

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundColor: _lightPurple,
                backgroundImage: photoUrl.isNotEmpty
                    ? NetworkImage(photoUrl)
                    : null,
                child: photoUrl.isEmpty
                    ? Icon(
                        Icons.person,
                        size: avatarRadius,
                        color: _primaryPurple,
                      )
                    : null,
              ),
              if (isEditable)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: isUploadingPhoto ? null : onChangePhoto,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: _primaryPurple,
                        shape: BoxShape.circle,
                      ),
                      child: isUploadingPhoto
                          ? const SizedBox(
                              height: 14,
                              width: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
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
