import 'package:flutter/material.dart';

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
      return _buildEditableHeader();
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

  Widget _buildEditableHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9FC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: _lightPurple,
                backgroundImage: photoUrl.isNotEmpty
                    ? NetworkImage(photoUrl)
                    : null,
                child: photoUrl.isEmpty
                    ? const Icon(Icons.person, size: 34, color: _primaryPurple)
                    : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: isUploadingPhoto ? null : onChangePhoto,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: _primaryPurple,
                      shape: BoxShape.circle,
                    ),
                    child: isUploadingPhoto
                        ? const SizedBox(
                            height: 12,
                            width: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt,
                            size: 13,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  roleLabel,
                  style: const TextStyle(
                    color: _primaryPurple,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (cityLabel.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    cityLabel,
                    style: const TextStyle(color: _primaryPurple, fontSize: 10),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
