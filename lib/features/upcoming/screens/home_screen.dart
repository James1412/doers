import 'package:doers/features/admob/ad_helper.dart';
import 'package:doers/features/upcoming/components/date_tile.dart';
import 'package:doers/features/upcoming/components/new_bottom_sheet.dart';
import 'package:doers/features/upcoming/date_tile_model.dart';
import 'package:doers/features/upcoming/todo_tile_model.dart';
import 'package:doers/features/upcoming/date_list_provider.dart';
import 'package:doers/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //TODO: Change this
  bool showAd = true;
  void onAccept(
      DragTargetDetails<ToDoTileModel> receivedData, DateTileModel dateTile) {
    context.read<DateListProvider>().onAccept(receivedData, dateTile);
  }

  void onDragComplete(dateTile, event) {
    context.read<DateListProvider>().onDragComplete(dateTile, event);
  }

  void removeDate(DateTileModel dateTile) {
    context.read<DateListProvider>().removeDate(dateTile);
  }

  List tabList = ["New Date", "New Event"];
  DateTime selectedDate = DateTime.now();

  void onCreateDate(bool isEvent, {required BuildContext context1}) {
    // If creation is including the event
    if (isEvent) {
      context.read<DateListProvider>().addEvent(ToDoTileModel(
          date: selectedDate,
          text: _newEventController.text,
          isChecked: ValueNotifier(false),
          isEditing: ValueNotifier(false)));
      resetSelectedDate();
      context.read<DateListProvider>().setDeclinedDate(false);
      _newEventController.clear();
      Navigator.pop(context);
    } else {
      for (DateTileModel date
          in Provider.of<DateListProvider>(context, listen: false).dateList) {
        if (getDate(date.date) == getDate(selectedDate)) {
          context.read<DateListProvider>().setDeclinedDate(true);
          return;
        }
      }
      context
          .read<DateListProvider>()
          .addDate(DateTileModel(date: selectedDate, events: []));
      resetSelectedDate();
      Navigator.pop(context);
    }
  }

  final TextEditingController _newEventController = TextEditingController();
  void onNewEventTap() {
    showModalBottomSheet(
      isDismissible: false,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (context) => NewBottomSheet(
        resetSelectedDate: resetSelectedDate,
        controller: _newEventController,
        onDateTimeChanged: onDateTimeChanged,
        selectedDate: selectedDate,
        tabList: tabList,
        onCreateDate: onCreateDate,
      ),
    );
  }

  void onDateTimeChanged(value) {
    context.read<DateListProvider>().setDeclinedDate(false);
    selectedDate = value;
    setState(() {});
  }

  void resetSelectedDate() {
    setState(() {
      selectedDate = DateTime.now();
    });
  }

  @override
  void dispose() {
    _newEventController.dispose();
    _ad?.dispose();
    super.dispose();
  }

  BannerAd? _ad;
  @override
  void initState() {
    super.initState();
    _initGoogleMobileAds();
    BannerAd(
      adUnitId: HomeScreenAdHelper.bannerAdUnitId,
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

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    List<DateTileModel> dateList = context
        .watch<DateListProvider>()
        .dateList
        .where((element) =>
            element.date.isAfter(currentDay) ||
            element.date.isAtSameMomentAs(currentDay))
        .toList();

    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.white,
            pinned: true,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                currentYear.toString(),
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                if (_ad != null && showAd)
                  Container(
                    height: _ad!.size.height.toDouble(),
                    width: _ad!.size.width.toDouble(),
                    alignment: Alignment.center,
                    child: AdWidget(
                      ad: _ad!,
                    ),
                  ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dateList.length,
                  itemBuilder: (context, index) {
                    return DateTile(
                      dateTile: dateList[index],
                      onAccept: onAccept,
                      getDate: getDate,
                      onDragComplete: onDragComplete,
                      isDateToday: isDateToday,
                      removeDate: removeDate,
                    );
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        splashColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: onNewEventTap,
        child: const Icon(Icons.add),
      ),
    );
  }
}
