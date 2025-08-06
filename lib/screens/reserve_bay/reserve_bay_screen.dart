import 'package:flutter/material.dart';
import 'package:project/widget/loading_dialog.dart';

class ReserveBayScreen extends StatefulWidget {
  const ReserveBayScreen({super.key});

  @override
  State<ReserveBayScreen> createState() => _ReserveBayScreenState();
}

class _ReserveBayScreenState extends State<ReserveBayScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoadingDialog());
  }
}
