import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/commentingsheets/widgets/commenting_sheet.dart';
import 'package:crimchart/features/widgets/chartcard/models/media_data.dart';
import 'package:crimchart/core/widgets/chart_linear_loader.dart';
import 'package:crimchart/features/showcase/chart_toast.dart';
import 'package:crimchart/features/channel/application/channel_creation_controller.dart';

class ChannelEditPage extends ConsumerStatefulWidget {
  final String channelId;
  final String initialTitle;
  final String? initialDescription;
  final String? initialAvatarUrl;

  const ChannelEditPage({
    super.key,
    required this.channelId,
    required this.initialTitle,
    this.initialDescription,
    this.initialAvatarUrl,
  });

  @override
  ConsumerState<ChannelEditPage> createState() => _ChannelEditPageState();
}

class _ChannelEditPageState extends ConsumerState<ChannelEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  MediaData? _selectedMedia;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showMediaPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentingSheet(
        showInputField: false,
        onMediaSelected: (media) {
          setState(() {
            _selectedMedia = media;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = theme.primaryColor;

    ref.listen(channelCreationControllerProvider, (previous, next) {
      if (next.status == ChannelCreationStatus.success) {
        ChartToast.showSuccess(
          context,
          title: 'Success',
          message: 'Channel updated successfully!',
        );
        Navigator.pop(context);
      } else if (next.status == ChannelCreationStatus.error) {
        ChartToast.showError(
          context,
          title: 'Update Failed',
          message: next.error ?? 'Failed to update channel',
        );
      }
    });

    final isLoading = ref.watch(channelCreationControllerProvider).status == ChannelCreationStatus.processing;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: 'Edit Channel', // 👑 Simple string as in your other page
        showBack: true,
        centerTitle: true,
      ),
      body: Column(
        children: [
          ChartLinearLoader(isLoading: isLoading),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Interactive Avatar Selector
              Center(
                child: GestureDetector(
                  onTap: () => _showMediaPicker(context),
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                      image: _selectedMedia != null
                          ? DecorationImage(
                              image: _selectedMedia!.contentUrl.startsWith('http')
                                  ? NetworkImage(_selectedMedia!.contentUrl) as ImageProvider
                                  : FileImage(File(_selectedMedia!.contentUrl)),
                              fit: BoxFit.cover,
                            )
                          : widget.initialAvatarUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(widget.initialAvatarUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.camera,
                          size: 32,
                          color: const Color(0xFFFFD700).withValues(alpha: 0.9), // 👑 VIBRANT VINTAGE GOLD
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Essential Identity Fields
              TextField(
                controller: _nameController,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: context.tr('channel_title_hint'),
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(18),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: context.tr('channel_description_hint'),
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(18),
                ),
              ),
              const SizedBox(height: 32),

              // Save Action Box
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () async {
                    final name = _nameController.text.trim();
                    if (name.isEmpty) {
                      ChartToast.showError(
                        context,
                        title: 'Error',
                        message: 'Please enter a name',
                      );
                      return;
                    }

                    // 👑 TRIGGER REAL BACKEND SYNC
                    await ref.read(channelCreationControllerProvider.notifier).editChannel(
                      channelId: widget.channelId,
                      name: name,
                      description: _descriptionController.text.trim(),
                      newMediaPath: _selectedMedia?.contentUrl,
                      oldCloudflareUrl: widget.initialAvatarUrl,
                    );
                  },
                  child: Container(
                    width: 120,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _isLoading
                          ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.1)
                          : colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        // Using plain string or tr if available, tr('save') should exist
                        context.tr('save') != 'save' ? context.tr('save') : 'Save',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: primaryColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
