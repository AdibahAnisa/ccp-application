import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SystemUpdate extends StatefulWidget {
  const SystemUpdate({super.key});

  @override
  State<SystemUpdate> createState() => _SystemUpdateState();
}

class _SystemUpdateState extends State<SystemUpdate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Text(
                "SYSTEM UPDATE",
                style: GoogleFonts.inter(
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Image.asset(
                'assets/images/logo_ccp.png',
                height: 130,
              ),
              const SizedBox(height: 40),
              Text(
                "We are currently updating our system\n"
                "to serve you better.\n"
                "Some features may be temporarily\n"
                "unavailable.",
                style: GoogleFonts.inter(
                  fontSize: 17,
                  color: Colors.black54,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
