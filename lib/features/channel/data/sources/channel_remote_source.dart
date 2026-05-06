import 'package:crown/core/errors/exceptions.dart';
import 'package:crown/profile/models/charter_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/channel_entity.dart';

import 'package:injectable/injectable.dart';

@lazySingleton
class ChannelRemoteSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  Future<ChannelEntity> createChannel(
    Map<String, dynamic> channelData, {
    String? avatarUrl,
  }) async {
    try {
      final response = await _supabase
          .from('channels')
          .insert(channelData)
          .select()
          .single();

      return ChannelEntity.fromJson(response);
    } catch (e) {
      debugPrint('❌ [createChannel Error]: $e');
      throw ServerException('Failed to create channel: $e');
    }
  }

  Future<ChannelEntity> updateChannel(
    String channelId,
    Map<String, dynamic> channelData, {
    String? avatarUrl,
  }) async {
    try {
      final response = await _supabase
          .from('channels')
          .update(channelData)
          .eq('id', channelId)
          .select('''
            id, 
            creator_id, 
            name, 
            description, 
            avatar_url, 
            age_restriction, 
            visible_to_other_channel_members, 
            visible_to_followed_users, 
            join_method, 
            prevent_leaving, 
            country_restrictions, 
            allow_commenting_by, 
            allow_status_posting_by,
            allow_invitations_by,
            members_count, 
            followers_count,
            tags_count,
            likes_count,
            is_discoverable,
            created_at, 
            unread_count,
            creator_profile:profiles!channels_creator_id_fkey(username, display_name, profile_image_url)
          ''')
          .maybeSingle();

      if (response == null) {
        throw ServerException(
          'Update failed: 0 rows affected. The channel may have been deleted, or Row Level Security (RLS) blocked the update because you are not the creator.',
        );
      }

      return ChannelEntity.fromJson(response);
    } catch (e) {
      debugPrint('❌ [updateChannel Error]: $e');
      throw ServerException('Failed to update channel: $e');
    }
  }

  Future<List<ChannelEntity>> getChannels(String filter, {int page = 0}) async {
    final supabase = Supabase.instance.client;
    final currentUserId = supabase.auth.currentUser?.id;
    const int pageSize = 20;

    try {
      // Base Query: JOIN profiles to get the creator's real profile image explicitly using the foreign key
      // Base Query: List all columns explicitly to avoid 'is_private' ghosting from stale schema cache
      var query = supabase.from('channels').select('''
        id, 
        creator_id, 
        name, 
        description, 
        avatar_url, 
        age_restriction, 
        visible_to_other_channel_members, 
        visible_to_followed_users, 
        join_method, 
        prevent_leaving, 
        country_restrictions, 
        allow_commenting_by, 
        allow_status_posting_by,
        allow_invitations_by,
        members_count, 
        followers_count,
        tags_count,
        likes_count,
        is_discoverable,
        created_at, 
        unread_count,
        creator_profile:profiles!channels_creator_id_fkey(username, display_name, profile_image_url)
      ''');

      if (filter == 'private') {
        if (currentUserId != null) {
          query = query.eq('creator_id', currentUserId);
        }
      } else if (filter == 'joined') {
        if (currentUserId != null) {
          // Fetch channels where the user is a member
          final memberResponse = await supabase
              .from('channel_members')
              .select('channel_id')
              .eq('user_id', currentUserId);

          final joinedChannelIds = (memberResponse as List<dynamic>)
              .map((data) => data['channel_id'])
              .toList();

          if (joinedChannelIds.isEmpty) {
            query = query.eq('creator_id', currentUserId);
          } else {
            // Include channels they joined OR channels they created
            query = query.or(
              'creator_id.eq.$currentUserId,id.in.(${joinedChannelIds.join(",")})',
            );
          }
        }
      } else if (filter == 'public') {
        // Assume 'join_method' determines privacy or just fetch all?
        // query = query.eq('join_method', 'public'); // for now no filter
      } else if (filter == 'channels' || filter == 'all') {
        // No filter needed, just fetch all channels limit 20
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(page * pageSize, (page + 1) * pageSize - 1);

      return (response as List<dynamic>)
          .map((data) => ChannelEntity.fromJson(data))
          .toList();
    } catch (e) {
      debugPrint('❌ [getChannels Error]: $e');
      throw ServerException('Failed to fetch channels: $e');
    }
  }

  Stream<List<ChannelEntity>> watchChannels(String filter) {
    // Basic implementation: fetch once and then listen for updates on the table
    // For a real production app, you might want more sophisticated logic here
    return _supabase
        .from('channels')
        .stream(primaryKey: ['id'])
        .map(
          (data) => data.map((json) => ChannelEntity.fromJson(json)).toList(),
        );
  }

  Future<List<CharterModel>> getChannelMembers(String channelId) async {
    try {
      final response = await _supabase
          .from('channel_members')
          .select('*, profiles(*)')
          .eq('channel_id', channelId);

      final List<dynamic> dataList = response as List<dynamic>;

      return dataList.map((data) {
        final profile = data['profiles'] as Map<String, dynamic>;
        return CharterModel(
          id: profile['id'],
          username: profile['username'] ?? 'unknown',
          displayName: profile['display_name'] ?? 'Unknown User',
          profileImageUrl: profile['profile_image_url'] ?? '',
          title: profile['ChartTitle'] ?? 'Member',
          category: profile['crown_category'] ?? 'default',
          role: data['role'] ?? 'member',
          chartCount: profile['posts_count'] ?? 0,
          channelCount: profile['channels_count'] ?? 0,
          isMe: profile['id'] == _supabase.auth.currentUser?.id,
        );
      }).toList();
    } catch (e) {
      debugPrint('❌ [getChannelMembers Error]: $e');
      throw ServerException('Failed to fetch channel members: $e');
    }
  }

  Future<void> sendInvitation({
    required String senderId,
    required String sourceChannelId,
    required String targetChannelId,
    String? channelName,
    String? channelImageUrl,
    String? channelTitle,
  }) async {
    try {
      // 👑 1. RECORD IN Structured Invitations Table
      await _supabase.from('channel_invitations').insert({
        'sender_id': senderId,
        'source_channel_id': sourceChannelId,
        'target_channel_id': targetChannelId,
      });

      // 👑 2. BROADCAST TO Feed (Linked to main chart table)
      // We insert a special "Invitation Post" into the source channel's feed
      await _supabase.from('channel_posts').insert({
        'channel_id': sourceChannelId,
        'author_id': senderId,
        'caption':
            '🚀 Hey! Join my other channel: ${channelName ?? "New Community"}',
        'post_type': 'invitation',
        'metadata': {
          'target_channel_id': targetChannelId,
          'target_channel_name': channelName,
          'target_channel_image': channelImageUrl,
          'target_channel_title': channelTitle,
          'is_invitation': true,
        },
      });

      debugPrint(
        '🚀 [RemoteSource] Invitation successfully broadcasted to $sourceChannelId',
      );
    } catch (e) {
      debugPrint('❌ [sendInvitation Error]: $e');
      throw ServerException('Failed to send invitation: $e');
    }
  }

  Future<void> sendChannelMessage(Map<String, dynamic> messageData) async {
    try {
      await _supabase.from('channel_messages').insert(messageData);
    } catch (e) {
      debugPrint('❌ [sendChannelMessage Error]: $e');
      throw ServerException('Failed to send message to cloud: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> streamChannelMessages(String channelId) {
    return _supabase
        .from('channel_messages')
        .stream(primaryKey: ['id'])
        .eq('channel_id', channelId)
        .order('created_at', ascending: false)
        .limit(10);
  }

  Future<List<Map<String, dynamic>>> getChannelMessages(
    String channelId, {
    int limit = 20,
    DateTime? beforeTimestamp,
  }) async {
    try {
      var query = _supabase.from('channel_messages').select();

      // 1. Apply Filters
      query = query.eq('channel_id', channelId);
      if (beforeTimestamp != null) {
        query = query.lt(
          'created_at',
          beforeTimestamp.toUtc().toIso8601String(),
        );
      }

      // 2. Apply Transformations
      final response = await query
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } catch (e) {
      debugPrint('❌ [getChannelMessages Error]: $e');
      throw ServerException('Failed to fetch messages: $e');
    }
  }

  Future<void> setPresence({
    required String channelId,
    required String userId,
    required bool isOnline,
    required bool isTyping,
    String? displayName,
    String? avatarUrl,
  }) async {
    try {
      await _supabase.from('channel_presence').upsert({
        'channel_id': channelId,
        'user_id': userId,
        'is_online': isOnline,
        'is_typing': isTyping,
        'last_seen_at': DateTime.now().toUtc().toIso8601String(),
        'last_known_name': displayName,
        'last_known_avatar': avatarUrl,
      });
    } catch (e) {
      debugPrint('❌ [setPresence Error]: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> streamPresence(String channelId) {
    return _supabase
        .from('channel_presence')
        .stream(primaryKey: ['channel_id', 'user_id'])
        .eq('channel_id', channelId);
  }
}
