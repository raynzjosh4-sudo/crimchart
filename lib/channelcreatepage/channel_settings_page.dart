import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../chartappbar/chart_app_bar.dart';

class ChannelSettingsPage extends StatefulWidget {
  const ChannelSettingsPage({super.key});

  @override
  State<ChannelSettingsPage> createState() => _ChannelSettingsPageState();
}

class _ChannelSettingsPageState extends State<ChannelSettingsPage> {
  // General Settings
  bool _isPrivate = true;
  bool _isDiscoverable = true;
  String _inviteMode = 'Request to Join';

  // Privacy & Data
  bool _privateDataMode = false;
  bool _showGifts = true;
  bool _allowGifting = true;

  // Moderation & Restrictions
  bool _allowMediaSharing = true;
  String _slowMode = 'Off';
  String _contentFilter = 'Medium';

  // Notifications
  String _notifications = 'All';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const ChartAppBar(
        title: 'Channel Settings',
        showBack: true,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('GENERAL SETTINGS', primaryColor),
              _buildSwitchTile('Private Channel', _isPrivate, (v) => setState(() => _isPrivate = v), primaryColor, colorScheme),
              _buildDropdownTile('Invite Mode', _inviteMode, ['Request to Join', 'Open', 'Invite Only'], (v) => setState(() => _inviteMode = v!), primaryColor, colorScheme),
              _buildSwitchTile('Discoverable', _isDiscoverable, (v) => setState(() => _isDiscoverable = v), primaryColor, colorScheme),

              const SizedBox(height: 32),
              _buildSectionHeader('PRIVACY & DATA', primaryColor),
              _buildSwitchTile('Private Data Mode', _privateDataMode, (v) => setState(() => _privateDataMode = v), primaryColor, colorScheme),
              _buildSwitchTile('Show Gifts to Members', _showGifts, (v) => setState(() => _showGifts = v), primaryColor, colorScheme),
              _buildSwitchTile('Allow Gifting', _allowGifting, (v) => setState(() => _allowGifting = v), primaryColor, colorScheme),

              const SizedBox(height: 32),
              _buildSectionHeader('MODERATION & RESTRICTIONS', primaryColor),
              _buildSwitchTile('Allow Media Sharing', _allowMediaSharing, (v) => setState(() => _allowMediaSharing = v), primaryColor, colorScheme),
              _buildDropdownTile('Slow Mode', _slowMode, ['Off', '30s', '1m', '5m'], (v) => setState(() => _slowMode = v!), primaryColor, colorScheme),
              _buildDropdownTile('Content Filter', _contentFilter, ['Low', 'Medium', 'High'], (v) => setState(() => _contentFilter = v!), primaryColor, colorScheme),

              const SizedBox(height: 32),
              _buildSectionHeader('NOTIFICATIONS', primaryColor),
              _buildDropdownTile('Notifications', _notifications, ['All', 'Mentions Only', 'None'], (v) => setState(() => _notifications = v!), primaryColor, colorScheme),

              const SizedBox(height: 48),

              // Navigation to Invitations (Next Step)
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'SAVE SETTINGS',
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged, Color primaryColor, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: primaryColor,
            activeTrackColor: primaryColor.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile(String title, String value, List<String> options, ValueChanged<String?> onChanged, Color primaryColor, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              icon: Icon(LucideIcons.chevronDown, color: primaryColor, size: 18),
              onChanged: onChanged,
              dropdownColor: colorScheme.surfaceContainerHigh,
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}





























