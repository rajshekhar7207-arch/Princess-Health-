import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const MaterialApp(home: PrincessDashboard()));

class PrincessDashboard extends StatefulWidget {
  const PrincessDashboard({super.key});
  @override
  State<PrincessDashboard> createState() => _PrincessDashboardState();
}

class _PrincessDashboardState extends State<PrincessDashboard> {
  int _seconds = 3600; 
  Timer? _timer;
  bool _isStarted = false;

  void _startTimer() {
    setState(() => _isStarted = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds > 0) setState(() => _seconds--);
      else { _timer?.cancel(); }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Princess Health"), backgroundColor: const Color(0xFFD4AF37)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isStarted)
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
                onPressed: _startTimer,
                child: const Text("నేను మందు వేసుకున్నాను", style: TextStyle(color: Colors.black)),
              )
            else
              Text("${(_seconds ~/ 60)}:${(_seconds % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 60)),
          ],
        ),
      ),
    );
  }
}
