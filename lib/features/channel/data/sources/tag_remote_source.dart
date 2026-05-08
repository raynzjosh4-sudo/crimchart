import 'package:flutter/foundation.dart';
import 'package:crimchart/features/channel/domain/entities/tag_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';

import 'package:crimchart/features/auth/data/sources/auth_local_source.dart';
import 'package:crimchart/core/di/injection.dart';

@lazySingleton
class TagRemoteSource {
  // Use a getter to ensure we always get the live, initialized client
  SupabaseClient get _supabase => Supabase.instance.client;

  Future<String?> get _effectiveUserId async {
    // 1. Try Supabase Auth first
    final supabaseId = _supabase.auth.currentUser?.id;
    if (supabaseId != null) return supabaseId;

    // 2. Fallback to Native C++ Auth Session
    try {
      final localAuth = getIt<AuthLocalSource>();
      final user = await localAuth.getUser();
      return user?.id;
    } catch (e) {
      debugPrint('🚨 [TagRemoteSource] Native Auth fallback failed: $e');
      return null;
    }
  }

  Future<TagEntity> createTag({
    required String postId,
    required String sourceChannelId,
    required String targetChannelId,
    required List<String> linkChain,
  }) async {
    final userId = await _effectiveUserId;
    if (userId == null) {
      debugPrint('❌ [TagRemoteSource] Auth Error: No user logged in (Checked Supabase & Native)');
      throw Exception('User not authenticated');
    }

    debugPrint('👤 [TagRemoteSource] Authenticated as: $userId');

    final payload = {
      'post_id': postId,
      'user_id': userId,
      'source_channel_id': sourceChannelId,
      'target_channel_id': targetChannelId,
      'link_chain': linkChain,
    };

    debugPrint('🚀 [TagRemoteSource] Inserting tag into "channel_content_tags"');
    debugPrint('🚀 [TagRemoteSource] Payload: $payload');

    try {
      final response = await _supabase
          .from('channel_content_tags')
          .insert(payload)
          .select()
          .single();
      
      debugPrint('✅ [TagRemoteSource] Insert successful!');
      return TagEntity.fromJson(response);
    } catch (e) {
      debugPrint('❌ [TagRemoteSource] Supabase Error: $e');
      rethrow;
    }
  }

  Future<void> removeTag(String tagId) async {
    await _supabase.from('channel_content_tags').delete().eq('id', tagId);
  }

  Future<bool> isPostTagged({
    required String postId,
    required String targetChannelId,
  }) async {
    final userId = await _effectiveUserId;
    if (userId == null) return false;

    final response = await _supabase
        .from('channel_content_tags')
        .select()
        .eq('post_id', postId)
        .eq('user_id', userId)
        .eq('target_channel_id', targetChannelId)
        .maybeSingle();

    return response != null;
  }
}
