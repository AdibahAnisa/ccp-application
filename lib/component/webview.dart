// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/constant.dart';
import 'package:project/theme.dart';
import 'package:project/widget/custom_dialog.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
  @override
  void initState() {
    super.initState();
  }

  bool _isFileDownload(String url) {
    return url.contains('/api/file/');
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      PermissionStatus storagePermission = await Permission.storage.status;
      PermissionStatus manageStoragePermission =
          await Permission.manageExternalStorage.status;

      if (storagePermission.isGranted || manageStoragePermission.isGranted) {
        return true;
      }

      storagePermission = await Permission.storage.request();
      manageStoragePermission =
          await Permission.manageExternalStorage.request();

      if (storagePermission.isGranted || manageStoragePermission.isGranted) {
        return true;
      }

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

      return _requestPermissions();
    }
    return true;
  }

  Future<void> _downloadFile(String url) async {
    if (!await _requestPermissions()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission Denied! Cannot save file.")),
      );
      return;
    }

    try {
      Dio dio = Dio();
      String fileName = url.split('/').last;
      Directory? directory = await getExternalStorageDirectory();
      String filePath = '${directory!.path}/$fileName.pdf';

      await dio.download(
        url,
        filePath,
        onReceiveProgress: (count, total) {
          setState(() {});
        },
      );

      setState(() {});
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
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(widget.url))),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              javaScriptEnabled: true,
              useShouldOverrideUrlLoading: true,
              clearCache: false,
              mediaPlaybackRequiresUserGesture: false,
            ),
          ),
          onWebViewCreated: (controller) {},
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url;
            if (uri != null && _isFileDownload(uri.toString())) {
              _downloadFile(uri.toString());
              return NavigationActionPolicy.CANCEL;
            }
            return NavigationActionPolicy.ALLOW;
          },
          onDownloadStartRequest: (controller, downloadStartRequest) async {
            String url = downloadStartRequest.url.toString();
            _downloadFile(url);
          },
        ),
      ),
    );
  }
}
