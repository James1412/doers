import 'package:animated_line_through/animated_line_through.dart';
import 'package:doers/features/admob/ad_helper.dart';
import 'package:doers/models/todo_tile_model.dart';
import 'package:doers/providers/date_list_provider.dart';
import 'package:doers/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  Future<bool> onCheckTap(value, ToDoTileModel event) async {
    return await context.read<DateListProvider>().onCheckTap(event);
  }

  //TODO: Change this
  bool showAd = false;

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: ChartScreenAdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    ).load();
  }

  BannerAd? _ad;

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateList = context.watch<DateListProvider>().dateList;
    final completedTasks = [
      for (var date in dateList)
        for (var event in date.events)
          if (event.isChecked.value) 1
    ].length.toDouble();
    final incompletedTasks = [
      for (var date in dateList)
        for (var event in date.events)
          if (!event.isChecked.value) 1
    ].length.toDouble();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          "Chart",
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: PieChart(
                dataMap: {
                  "Complete!": completedTasks,
                  "Incomplete": incompletedTasks,
                },
                chartType: ChartType.ring,
                colorList: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.15),
                ],
                chartValuesOptions: const ChartValuesOptions(
                  showChartValuesInPercentage: true,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Incomplete Events",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: [
                  for (var date in context.watch<DateListProvider>().dateList)
                    for (var event in date.events)
                      if (!event.isChecked.value)
                        Slidable(
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                onPressed: (val) {
                                  context
                                      .read<DateListProvider>()
                                      .removeEvent(event);
                                },
                                icon: Icons.delete,
                              ),
                            ],
                          ),
                          child: ValueListenableBuilder(
                            valueListenable: event.isChecked,
                            builder: (context, value, child) => InkWell(
                              onTap: () => onCheckTap(1.0, event),
                              child: ListTile(
                                dense: true,
                                tileColor: Colors.white,
                                horizontalTitleGap:
                                    BorderSide.strokeAlignCenter,
                                leading: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: LikeButton(
                                    isLiked: event.isChecked.value,
                                    onTap: (value) => onCheckTap(value, event),
                                    animationDuration:
                                        const Duration(milliseconds: 700),
                                    likeBuilder: (isLiked) {
                                      return Icon(
                                        isLiked
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: isLiked ? Colors.blue : null,
                                        size: 25,
                                      );
                                    },
                                  ),
                                ),
                                title: AnimatedLineThrough(
                                  strokeWidth: 1.0,
                                  isCrossed: event.isChecked.value,
                                  duration: const Duration(milliseconds: 100),
                                  child: Text(
                                    event.text,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                    "${getDate(event.date)} ${DateFormat.jm().format(event.date)}"),
                                trailing: const Icon(Icons.chevron_left),
                              ),
                            ),
                          ),
                        ),
                  if (_ad != null && showAd)
                    Container(
                      width: _ad!.size.width.toDouble(),
                      height: _ad!.size.height.toDouble(),
                      alignment: Alignment.center,
                      child: AdWidget(ad: _ad!),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
