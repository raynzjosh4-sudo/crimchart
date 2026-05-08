import 'package:crimchart/features/allchannels/models/chart_channel.dart';
import 'package:crimchart/profile/widgets/charters/charted_in_channel.dart';
import 'package:flutter/material.dart';

import 'made_in_channel.dart';

class ChartChannelListItem extends StatelessWidget {
  final ChartChannel channel;
  final bool isChartedIn;
  final bool isSubChannel;
  final int? index;

  const ChartChannelListItem({
    super.key,
    required this.channel,
    required this.isChartedIn,
    this.isSubChannel = false,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    if (isChartedIn) {
      return ChartedInChannel(
        channel: channel,
        isSubChannel: isSubChannel,
        index: index,
      );
    } else {
      return MadeInChannel(
        channel: channel,
        isSubChannel: isSubChannel,
        index: index,
      );
    }
  }
}











