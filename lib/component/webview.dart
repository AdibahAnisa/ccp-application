import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/constant.dart';
import 'package:project/theme.dart';
import 'package:project/widget/custom_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final Map<String, dynamic> details;
  final String url;

  const WebViewPage({
    super.key,
    required this.title,
    required this.url,
    required this.details,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // **Detect file download links**
            if (_isFileDownload(request.url)) {
              _downloadFile(request.url);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  /// **Check if the URL is a file download**
  bool _isFileDownload(String url) {
    return url.contains('/api/file/');
  }

  /// **Request permissions for saving the file (Android 13+)**
  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      PermissionStatus storagePermission = await Permission.storage.status;
      PermissionStatus manageStoragePermission =
          await Permission.manageExternalStorage.status;

      // Check if permission is already granted
      if (storagePermission.isGranted || manageStoragePermission.isGranted) {
        return true;
      }

      // Request permission if not granted
      storagePermission = await Permission.storage.request();
      manageStoragePermission =
          await Permission.manageExternalStorage.request();

      if (storagePermission.isGranted || manageStoragePermission.isGranted) {
        return true; // Permission granted
      }

      // If permanently denied, open settings
      if (storagePermission.isPermanentlyDenied ||
          manageStoragePermission.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                "Permission denied permanently. Please enable it in settings."),
            action: SnackBarAction(
              label: "Open Settings",
              onPressed: () => openAppSettings(),
            ),
          ),
        );
        return false;
      }

      // If the user denies the permission, ask again
      return _requestPermissions();
    }
    return true; // iOS does not need extra permissions
  }

  /// **Download and save file manually**
  Future<void> _downloadFile(String url) async {
    if (!await _requestPermissions()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: const Text("Permission Denied! Cannot save file.")),
      );
      return;
    }

    try {
      Dio dio = Dio();
      String fileName = url.split('/').last; // Extract filename from URL

      Directory? directory =
          await getExternalStorageDirectory(); // Android/iOS safe storage
      String filePath = '${directory!.path}/$fileName.pdf';

      await dio.download(
        url,
        filePath,
        onReceiveProgress: (count, total) {
          setState(() {});
        },
      );

      setState(() {});

      // **Open the file after downloading**
      OpenFile.open(filePath);
    } catch (e) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        CustomDialog.show(
          context,
          title: AppLocalizations.of(context)!.closeReceipt,
          description: AppLocalizations.of(context)!.closeReceiptDesc,
          btnOkText: AppLocalizations.of(context)!.exit,
          btnCancelText: AppLocalizations.of(context)!.cancel,
          btnOkOnPress: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          btnCancelOnPress: () => Navigator.pop(context),
        );
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          toolbarHeight: 100,
          foregroundColor:
              widget.details['color'] == 4294961979 ? kBlack : kWhite,
          backgroundColor: Color(widget.details['color']),
          centerTitle: true,
          title: Text(
            'FPX Payment',
            style: textStyleNormal(
              fontSize: 26,
              color: widget.details['color'] == 4294961979 ? kBlack : kWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
