import 'package:flutter/material.dart';
import '../../models/common_chart_model.dart';
import '../common_chart_card_widget.dart';
import '../../../../../../chartappbar/chart_app_bar.dart';

class CommonChartDetailsPage extends StatefulWidget {
  final List<CommonChartModel> Charts;
  final int initialIndex;

  const CommonChartDetailsPage({
    super.key,
    required this.Charts,
    required this.initialIndex,
  });

  @override
  State<CommonChartDetailsPage> createState() => _CommonChartDetailsPageState();
}

class _CommonChartDetailsPageState extends State<CommonChartDetailsPage> {
  final GlobalKey _initialKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Scroll to the initial item after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_initialKey.currentContext != null) {
        Scrollable.ensureVisible(
          _initialKey.currentContext!,
          duration: Duration.zero,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const ChartAppBar(
        title: 'Post',
        showBack: true,
      ),
      body: ListView.builder(
        itemCount: widget.Charts.length,
        itemBuilder: (context, index) {
          return CommonChartCardWidget(
            key: index == widget.initialIndex ? _initialKey : ValueKey(widget.Charts[index].id),
            data: widget.Charts[index],
            isFeedView: false,
          );
        },
      ),
    );
  }
}





























