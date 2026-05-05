import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/app/helpers/notification_storage.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notificationList = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final data = await NotificationStorage.getNotifications();

    setState(() {
      notificationList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 70,
        foregroundColor: kBlack,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.notifications,
          style: textStyleNormal(
            fontSize: 22,
            color: kBlack,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: notificationList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt, color: kGrey, size: 80),
                  spaceVertical(height: 10.0),
                  Text(
                    AppLocalizations.of(context)!.notificationDesc,
                    style: textStyleNormal(
                      color: kGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notificationList.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final notification = notificationList[index];

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 5.0,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(reserveBayImage),
                      spaceHorizontal(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification["title"] ?? "Parking Notification",
                              style: textStyleNormal(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            spaceVertical(height: 2.0),
                            const Divider(),
                            spaceVertical(height: 2.0),
                            Text(
                              notification["description"] ?? "",
                              style: textStyleNormal(),
                            ),
                            if (notification["plateNumber"] != null)
                              Text(
                                "Plate: ${notification["plateNumber"]}",
                                style: textStyleNormal(
                                  color: kGrey,
                                  fontSize: 13,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
