import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sistema_abada_capoeira/core/constants/app_colors.dart';
import 'package:sistema_abada_capoeira/core/constants/app_spacing.dart';
import 'package:sistema_abada_capoeira/core/constants/app_text_styles.dart';
import 'package:sistema_abada_capoeira/core/services/image_service.dart';

class FilePickerWidget extends StatefulWidget {
  final String? label;
  final String? hintText;
  final Function(File? file)? onFileSelected;
  final File? currentFile;
  final String? currentFileUrl;
  final FileType fileType;
  final bool imageOnly;
  final bool showPreview;

  const FilePickerWidget({
    super.key,
    this.label,
    this.hintText,
    this.onFileSelected,
    this.currentFile,
    this.currentFileUrl,
    this.fileType = FileType.any,
    this.imageOnly = false,
    this.showPreview = true,
  });

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  File? _selectedFile;
  String? _errorMessage;

  final ImageService _imageService = ImageService();

  @override
  void initState() {
    super.initState();
    _selectedFile = widget.currentFile;
  }

  Future<void> _pickFile() async {
    try {
      setState(() {
        _errorMessage = null;
      });

      File? pickedFile;

      if (widget.imageOnly) {

        final image = await _imageService.pickImage();
        
        // final ImagePicker picker = ImagePicker();
        // final XFile? image = await picker.pickImage(
        //   source: ImageSource.gallery,
        //   imageQuality: 85,
        // );
        
        if (image != null) {
          pickedFile = File(image.path);
        }
      } else {

        PlatformFile? result = await FilePicker.pickFile(
          type: widget.fileType,
          allowedExtensions: widget.fileType == FileType.custom ? ['pdf'] : null,
        );

        if (result != null && result.path != null) {
          pickedFile = File(result.path!);
        }
      }

      if (pickedFile != null) {
        setState(() {
          _selectedFile = pickedFile;
        });
        
        widget.onFileSelected?.call(pickedFile);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao selecionar arquivo: ${e.toString()}';
      });
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedFile = null;
      _errorMessage = null;
    });
    widget.onFileSelected?.call(null);
  }

  bool get _hasFile => _selectedFile != null;
  bool get _hasExistingUrl => widget.currentFileUrl != null && widget.currentFileUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.medium14,
          ),
          AppSpacing.gapV10,
        ],
        
        InkWell(
          onTap: _pickFile,
          child: Container(
            padding: AppSpacing.symmetricH16V12,
            decoration: BoxDecoration(
              border: Border.all(
                color: (_hasFile || _hasExistingUrl) ? AppColors.primary : AppColors.borderGrey,
                width: (_hasFile || _hasExistingUrl) ? AppSpacing.borderThick : AppSpacing.borderThin,
              ),
              borderRadius: AppSpacing.rounded8,
              color: AppColors.surface,
            ),
            child: Row(
              children: [
                Icon(
                  widget.imageOnly ? Icons.image : Icons.insert_drive_file,
                  color: (_hasFile || _hasExistingUrl) ? AppColors.primary : AppColors.textSecondary,
                ),
                AppSpacing.gapH12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_hasFile) ...[
                        Text(
                          _selectedFile!.path.split('/').last,
                          style: AppTextStyles.medium12.copyWith(
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Arquivo selecionado',
                          style: AppTextStyles.regular12.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ] else if (_hasExistingUrl) ...[
                        Text(
                          'Arquivo existente',
                          style: AppTextStyles.medium12.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'Toque para substituir',
                          style: AppTextStyles.regular12.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ] else ...[
                        Text(
                          widget.hintText ?? 'Toque para selecionar arquivo',
                          style: AppTextStyles.regular14.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (_hasFile || _hasExistingUrl)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: _clearSelection,
                    color: AppColors.textSecondary,
                  ),
              ],
            ),
          ),
        ),

        if (widget.showPreview && _hasFile && _isImageFile(_selectedFile!.path)) ...[
          AppSpacing.gapV10,
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderGrey),
              borderRadius: AppSpacing.rounded8,
            ),
            child: ClipRRect(
              borderRadius: AppSpacing.rounded8,
              child: Image.file(
                _selectedFile!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ] else if (widget.showPreview && _hasExistingUrl && _isImageUrl(widget.currentFileUrl!)) ...[
          AppSpacing.gapV10,
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderGrey),
              borderRadius: AppSpacing.rounded8,
            ),
            child: ClipRRect(
              borderRadius: AppSpacing.rounded8,
              child: CachedNetworkImage(
                imageUrl: widget.currentFileUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ],

        if (_errorMessage != null) ...[
          AppSpacing.gapV10,
          Container(
            padding: AppSpacing.all12,
            decoration: BoxDecoration(
              color: AppColors.modalColorRedOpacity01,
              borderRadius: AppSpacing.rounded8,
              border: Border.all(color: AppColors.modalColorRedOpacity03),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: AppColors.error, size: AppSpacing.iconSmall),
                AppSpacing.gapH8,
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: AppTextStyles.regular12.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  bool _isImageFile(String path) {
    final lowerPath = path.toLowerCase();
    return lowerPath.endsWith('.jpg') ||
        lowerPath.endsWith('.jpeg') ||
        lowerPath.endsWith('.png') ||
        lowerPath.endsWith('.gif') ||
        lowerPath.endsWith('.webp');
  }

  bool _isImageUrl(String url) {
    final lowerUrl = url.toLowerCase();
    return lowerUrl.contains('.jpg') ||
        lowerUrl.contains('.jpeg') ||
        lowerUrl.contains('.png') ||
        lowerUrl.contains('.gif') ||
        lowerUrl.contains('.webp');
  }
}
