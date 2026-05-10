import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crimchart/core/widgets/app_avatar.dart';
import '../../../profile/models/charter_model.dart';
import '../../../backicon/custom_back_button.dart';
import 'your_data_tab.dart';
import '../../../features/newinsidechartstartpage/widgets/datacardwidget/sample_media_data.dart';

class ChartedMembersTab extends StatefulWidget {
  const ChartedMembersTab({super.key});

  @override
  State<ChartedMembersTab> createState() => _ChartedMembersTabState();
}

class _ChartedMembersTabState extends State<ChartedMembersTab> {
  CharterModel? _selectedMember;
  final SampleMediaData _sampleData = SampleMediaData();
  final List<int> _selectedDataIndices = [];
  
  List<CharterModel> _realMembers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    try {
      final supabase = Supabase.instance.client;
      final currentUserId = supabase.auth.currentUser?.id;
      
      final response = await supabase
          .from('profiles')
          .select()
          .limit(30);

      final List<CharterModel> members = [];
      for (final profile in response) {
        final profileId = profile['id'].toString();
        // Skip ourselves
        if (profileId == currentUserId) continue;

        members.add(CharterModel(
          id: profileId,
          username: profile['username']?.toString() ?? 'user',
          displayName: profile['display_name']?.toString() ?? 'User',
          profileImageUrl: profile['profile_image_url']?.toString() ?? 'https://i.pravatar.cc/150',
          title: profile['Chart_title']?.toString() ?? 'Member',
          category: profile['Chart_category']?.toString() ?? 'Default',
        ));
      }

      if (mounted) {
        setState(() {
          _realMembers = members;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching members: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      );
    }

    if (_realMembers.isEmpty && _selectedMember == null) {
      return Center(
        child: Text(
          "No public members found.",
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _selectedMember == null
          ? _buildMemberList(colorScheme)
          : _buildMemberDataView(colorScheme),
    );
  }

  Widget _buildMemberList(ColorScheme colorScheme) {
    return ListView.builder(
      key: const ValueKey('member_list'),
      padding: const EdgeInsets.all(16),
      itemCount: _realMembers.length,
      itemBuilder: (context, index) {
        final item = _realMembers[index];
        return ListTile(
          leading: AppAvatar(
            size: 40,
            imageUrl: item.profileImageUrl,
            fallbackIcon: LucideIcons.user,
          ),
          title: Text(
            item.displayName,
            style: TextStyle(color: colorScheme.onSurface),
          ),
          subtitle: Text(
            '@${item.username}',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          trailing: Icon(LucideIcons.star, color: Colors.amber, size: 18),
          onTap: () {
            setState(() {
              _selectedMember = item;
              _selectedDataIndices.clear();
            });
          },
        );
      },
    );
  }

  Widget _buildMemberDataView(ColorScheme colorScheme) {
    return Column(
      key: const ValueKey('member_data'),
      children: [
        // Back Button Header
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 8, right: 16),
          child: Row(
            children: [
              CustomBackButton(
                color: colorScheme.onSurface,
                size: 32.0,
                onPressed: () {
                  setState(() {
                    _selectedMember = null;
                  });
                },
              ),
              AppAvatar(
                size: 28,
                imageUrl: _selectedMember!.profileImageUrl,
                fallbackIcon: LucideIcons.user,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _selectedMember!.displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // Data View (Real public data!)
        Expanded(
          child: YourDataTab(
            targetUserId: _selectedMember!.id,
            onlyPublic: true,    // Restrict strictly to Public media
            selectedIndices: _selectedDataIndices,
            sampleData: _sampleData,
            onMediaTap: (index, item) {
              setState(() {
                if (_selectedDataIndices.contains(index)) {
                  _selectedDataIndices.remove(index);
                } else if (_selectedDataIndices.length < 5) {
                  _selectedDataIndices.add(index);
                }
              });
            },
          ),
        ),
      ],
    );
  }
}





























