import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/channel_entity.dart';
import '../../../../core/errors/exceptions.dart';

@injectable
class ChannelRemoteSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<ChannelEntity> createChannel(
    Map<String, dynamic> channelData, {
    String? avatarUrl,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw ServerException('User not authenticated');

      // 👑 1. PREPARE THE EXACT DATABASE PAYLOAD
      final payload = {
        'creator_id': userId,
        'name': channelData['name'],
        'description': channelData['description'],
        'avatar_url': avatarUrl, // This is now the Cloudflare URL!
        'age_restriction': channelData['ageRestriction'],
        'members_other_channels': channelData['membersOtherChannels'],
        'members_following': channelData['membersFollowing'],
        'join_method': channelData['joinMethod'],
        'prevent_leaving': channelData['preventLeaving'],
        'country_restrictions': channelData['countryRestrictions'],
        'allow_commenting_by': channelData['allowCommentingBy'],
        'members_count': 1,
      };

      // 👑 2. INSERT INTO 'channels' TABLE
      final response = await _supabase
          .from('channels')
          .insert(payload)
          .select()
          .single();

      final newChannelId = response['id'];

      // 👑 3. ADD CREATOR TO 'channel_members' TABLE AS ADMIN
      await _supabase.from('channel_members').insert({
        'channel_id': newChannelId,
        'user_id': userId,
        'role': 'admin',
      });

      return ChannelEntity.fromJson(response);
    } catch (e) {
      debugPrint('❌ [Channel DB Insert Error]: $e');
      throw ServerException('Failed to create channel in DB: $e');
    }
  }

  Future<ChannelEntity> updateChannel(
    String channelId,
    Map<String, dynamic> channelData, {
    String? avatarUrl,
  }) async {
    try {
      // Build payload dynamically to avoid nulling out fields not provided
      final payload = <String, dynamic>{};

      if (channelData.containsKey('name'))
        payload['name'] = channelData['name'];
      if (channelData.containsKey('description'))
        payload['description'] = channelData['description'];
      if (channelData.containsKey('age_restriction'))
        payload['age_restriction'] = channelData['age_restriction'];
      if (channelData.containsKey('members_other_channels'))
        payload['members_other_channels'] =
            channelData['members_other_channels'];
      if (channelData.containsKey('members_following'))
        payload['members_following'] = channelData['members_following'];
      if (channelData.containsKey('join_method'))
        payload['join_method'] = channelData['join_method'];
      if (channelData.containsKey('prevent_leaving'))
        payload['prevent_leaving'] = channelData['prevent_leaving'];
      if (channelData.containsKey('country_restrictions'))
        payload['country_restrictions'] = channelData['country_restrictions'];
      if (channelData.containsKey('allow_commenting_by'))
        payload['allow_commenting_by'] = channelData['allow_commenting_by'];

      // Only include avatarUrl if a new one was provided
      if (avatarUrl != null) {
        payload['avatar_url'] = avatarUrl;
      }

      if (payload.isEmpty) {
        throw ServerException('No data provided to update');
      }

      final response = await _supabase
          .from('channels')
          .update(payload)
          .eq('id', channelId)
          .select()
          .single();

      return ChannelEntity.fromJson(response);
    } catch (e) {
      debugPrint('❌ [Channel DB Update Error]: $e');
      throw ServerException('Failed to update channel in DB: $e');
    }
  }

  Future<List<ChannelEntity>> getChannels(String filter) async {
    final supabase = Supabase.instance.client;
    final currentUserId = supabase.auth.currentUser?.id;

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
        members_other_channels, 
        members_following, 
        join_method, 
        prevent_leaving, 
        country_restrictions, 
        allow_commenting_by, 
        members_count, 
        created_at, 
        unread_count,
        creator_profile:profiles!channels_creator_id_fkey(profile_image_url)
      ''');

      if (filter == 'private') {
        if (currentUserId != null) {
          query = query.eq('creator_id', currentUserId);
        }
      } else if (filter == 'public') {
        // Assume 'join_method' determines privacy or just fetch all?
        // query = query.eq('join_method', 'public'); // for now no filter
      } else if (filter == 'channels' || filter == 'all') {
        // No filter needed, just fetch all channels limit 20
      }

      final response = await query
          .order('created_at', ascending: false)
          .limit(20);

      return (response as List<dynamic>)
          .map((data) => ChannelEntity.fromJson(data))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch channels: $e');
    }
  }

  /// 🛰️ REAL-TIME: Listen for any changes to the channels table
  Stream<List<ChannelEntity>> watchChannels(String filter) {
    final supabase = Supabase.instance.client;
    final currentUserId = supabase.auth.currentUser?.id;

    // Supabase Stream provides real-time updates for a selection of rows
    return supabase
        .from('channels')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((response) {
          final allChannels = response
              .map((data) => ChannelEntity.fromJson(data))
              .toList();

          if (filter == 'private') {
            return allChannels
                .where((c) => c.creatorId == currentUserId)
                .toList();
          } else if (filter == 'public') {
            // return allChannels.where((c) => !c.isPrivate).toList();
            return allChannels;
          } else if (filter == 'channels' || filter == 'all') {
            return allChannels;
          }
          return allChannels;
        });
  }
}
