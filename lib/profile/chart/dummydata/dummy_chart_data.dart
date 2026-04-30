import '../models/chart_chart.dart';

final List<ChartChart> dummyCharts = [
  ChartChart(
    id: '1',
    senderName: 'Vincent📝📝📝',
    senderAvatarUrl: 'https://picsum.photos/seed/vinc/100/100',
    lastMessage: 'Let\'s collaborate on the modern AI project next week!',
    timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    unreadCount: 3,
    isOnline: true,
  ),
  ChartChart(
    id: '2',
    senderName: 'Madam Masaka',
    senderAvatarUrl: 'https://picsum.photos/seed/madam/100/100',
    lastMessage: 'You: The details have been sent to your email.',
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    isOnline: false,
  ),
  ChartChart(
    id: '3',
    senderName: 'Sudo Developer',
    senderAvatarUrl: 'https://picsum.photos/seed/sudo/100/100',
    lastMessage: 'The new TikTok Inbox UI is looTop amazing 🔥',
    timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    unreadCount: 1,
    isOnline: true,
  ),
  ChartChart(
    id: '4',
    senderName: 'Mama Africa',
    senderAvatarUrl: 'https://picsum.photos/seed/mamaaf/100/100',
    lastMessage: 'Can we schedule a call for the upcoming Chart competition?',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    isOnline: false,
  ),
];





























