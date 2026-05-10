import 'package:crimchart/core/db/chart_native_db.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedAccount {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final int notificationsCount;

  SavedAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.notificationsCount,
  });
}

final savedAccountsProvider = StreamProvider<List<SavedAccount>>((ref) async* {
  final db = ChartNativeDB.instance.db;

  // Watch the users table to get real saved accounts from the device
  final usersStream = db.select(db.users).watch();

  await for (final users in usersStream) {
    List<SavedAccount> accounts = [];
    
    for (final user in users) {
      // Calculate total notifications for this user from channelMembers
      final memberRows = await (db.select(db.channelMembers)
            ..where((t) => t.userId.equals(user.id)))
          .get();
          
      int totalNotifications = 0;
      for (final member in memberRows) {
        totalNotifications += (member.unreadCount ?? 0) + (member.unreadMomentsCount ?? 0);
      }
      
      accounts.add(
        SavedAccount(
          id: user.id,
          name: user.displayName ?? user.username ?? 'Unknown Account',
          email: user.username ?? '', // Fallback to username for email display
          avatar: user.profileImageUrl ?? '',
          notificationsCount: totalNotifications,
        )
      );
    }
    
    yield accounts;
  }
});
