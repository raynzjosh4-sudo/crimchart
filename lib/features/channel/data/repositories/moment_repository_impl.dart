import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';
import '../../domain/repositories/moment_repository.dart';
import '../../domain/entities/channel_moment_entity.dart';
import '../../../../core/db/chart_native_db.dart';

@LazySingleton(as: MomentRepository)
class MomentRepositoryImpl implements MomentRepository {
  final _supabase = Supabase.instance.client;
  final _db = ChartNativeDB.instance;

  @override
  Future<ChannelMomentEntity?> shareMoment({
    required String channelId,
    required String mediaUrl,
    required String mediaType,
    String? caption,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final momentData = {
        'channel_id': channelId,
        'author_id': user.id,
        'media_url': mediaUrl,
        'media_type': mediaType,
        'caption': caption,
        'expires_at':
            DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
      };

      final response =
          await _supabase.from('channel_moments').insert(momentData).select();

      if (response.isNotEmpty) {
        final newMomentRaw = response.first;
        
        // ── Enrich with Author Info for Local DB ──
        // Since we just posted, we know the current user's info
        // We can fetch it from profiles or just use the current session info
        final profileResponse = await _supabase
            .from('profiles')
            .select('display_name, profile_image_url')
            .eq('id', user.id)
            .single();
            
        final Map<String, dynamic> enrichedData = Map.from(newMomentRaw);
        enrichedData['author_name'] = profileResponse['display_name'];
        enrichedData['author_avatar_url'] = profileResponse['profile_image_url'];

        await _db.upsertChannelMoment(enrichedData);
        return ChannelMomentEntity.fromMap(enrichedData);
      }
      return null;
    } catch (e) {
      debugPrint('❌ [MomentRepository] Error sharing moment: $e');
      rethrow;
    }
  }

  @override
  Future<void> cleanupExpiredMoments(String channelId) async {
    try {
      final now = DateTime.now().toIso8601String();

      // 1. Remote Cleanup
      await _supabase
          .from('channel_moments')
          .delete()
          .lt('expires_at', now)
          .eq('channel_id', channelId);

      // 2. Local Cleanup
      await _db.deleteExpiredMoments(channelId);
      
      debugPrint('🧹 [MomentRepository] Expired moments cleaned up');
    } catch (e) {
      debugPrint('⚠️ [MomentRepository] Cleanup error: $e');
    }
  }

  @override
  Future<void> syncMoments({required String channelId, int offset = 0}) async {
    try {
      final response = await _supabase
          .from('channel_moments')
          .select('*, author:profiles(display_name, profile_image_url)')
          .eq('channel_id', channelId)
          .order('created_at', ascending: false)
          .range(offset, offset + 9);

      final list = response as List;
      for (final raw in list) {
        final map = Map<String, dynamic>.from(raw);
        final author = map['author'] as Map<String, dynamic>?;
        if (author != null) {
          map['author_name'] = author['display_name'];
          map['author_avatar_url'] = author['profile_image_url'];
        }
        await _db.upsertChannelMoment(map);
      }
    } catch (e) {
      debugPrint('⚠️ [MomentRepository] Sync failed, trying fallback: $e');
      try {
        final response = await _supabase
            .from('channel_moments')
            .select()
            .eq('channel_id', channelId)
            .order('created_at', ascending: false)
            .range(offset, offset + 9);

        final list = response as List;
        for (final raw in list) {
          final map = Map<String, dynamic>.from(raw);
          final authorId = map['author_id'] as String?;

          if (authorId != null) {
            try {
              final profile = await _supabase
                  .from('profiles')
                  .select('display_name, profile_image_url')
                  .eq('id', authorId)
                  .single();
              map['author_name'] = profile['display_name'];
              map['author_avatar_url'] = profile['profile_image_url'];
            } catch (profileError) {
              debugPrint('⚠️ [MomentRepository] Fallback profile fetch failed: $profileError');
            }
          }
          await _db.upsertChannelMoment(map);
        }
      } catch (fallbackError) {
        debugPrint('❌ [MomentRepository] Critical Sync Fallback error: $fallbackError');
      }
    }
  }
}
