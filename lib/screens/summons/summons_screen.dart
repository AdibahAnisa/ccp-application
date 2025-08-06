import 'package:flutter/material.dart';
import 'package:project/models/models.dart';
import 'package:project/widget/loading_dialog.dart';

class SummonsScreen extends StatefulWidget {
  const SummonsScreen({super.key});

  @override
  State<SummonsScreen> createState() => _SummonsScreenState();
}

class _SummonsScreenState extends State<SummonsScreen> {
  late final TicketModel summonModel;
  late final CompoundModel compoundModel;
  List<TicketModel>? summonsList;
  final TextEditingController _searchController = TextEditingController();
  // Use a Set to keep track of selected notices
// Change to String if you want to store other IDs like offenderIDNo or vehicleRegistrationNumber
// Temporary list to store selected summons

  List<PlateNumberModel>? _plateNumbers = [];

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    compoundModel = CompoundModel();
    summonModel = TicketModel();
    _searchController.addListener(_onSearchChanged); // Add search listener
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

      _plateNumbers = arguments['plateNumbers'] as List<PlateNumberModel>?;

// Set future for FutureBuilder
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getSummons() async {
    if (_plateNumbers == null || _plateNumbers!.isEmpty) return;

    try {} catch (e) {
      print('General error in fetching summons: $e');
    }

    setState(() {});
  }

  Future<void> _onSearchChanged() async {
    String query = _searchController.text.toLowerCase();

    if (query.isNotEmpty) {
      // Filter the summonsList based on the selected input type
      setState(() {
        summonsList = summonsList?.where((summon) {
          return false;
        }).toList();
      });
    } else {
      // If the query is empty, reload the original summons list
      await _getSummons();
      setState(() {}); // Ensure the state is updated to reflect the changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoadingDialog(),
    );
  }
}
