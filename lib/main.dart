import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const PrincessHealthApp());
}

class PrincessHealthApp extends StatelessWidget {
  const PrincessHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Princess Health',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFD4AF37), // Gold
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        textTheme: GoogleFonts.playfairDisplayTextTheme(ThemeData.dark().textTheme),
      ),
      home: const LoginScreen(),
    );
  }
}

// --- Background Animations (Floating Butterflies and Hearts) ---
class FloatingBackground extends StatefulWidget {
  const FloatingBackground({super.key});

  @override
  State<FloatingBackground> createState() => _FloatingBackgroundState();
}

class _FloatingBackgroundState extends State<FloatingBackground> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(12, (index) => AnimationController(
      duration: Duration(seconds: 6 + (index % 4) * 2),
      vsync: this,
    )..repeat(reverse: true));
    
    _animations = _controllers.map((c) => Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.5),
    ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut))).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0F0F0F), Color(0xFF1A1A1A), Color(0xFF050505)],
            ),
          ),
        ),
        ...List.generate(12, (index) {
          final isHeart = index % 2 == 0;
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Positioned(
                left: MediaQuery.of(context).size.width * (0.05 + (index * 0.15) % 0.9),
                top: MediaQuery.of(context).size.height * (0.1 + (index * 0.08) % 0.8) + (_animations[index].value.dy * 50),
                child: Opacity(
                  opacity: 0.2,
                  child: Icon(
                    isHeart ? Icons.favorite : Icons.flutter_dash,
                    color: const Color(0xFFD4AF37),
                    size: 24 + (index % 3) * 8.0,
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }
}

// --- Login Screen ---
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const FloatingBackground(),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, color: Color(0xFFD4AF37), size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Princess Health',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 36,
                        color: const Color(0xFFD4AF37),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white24),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.black26,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Dashboard())),
                      child: const Text(
                        'లోపలికి వెళ్ళు',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Dashboard ---
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _secondsRemaining = 3600;
  bool _timerActive = false;
  Timer? _timer;

  void _startTimer() {
    setState(() {
      _timerActive = true;
      _secondsRemaining = 3600;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        _showBreakfastAlert();
      }
    });
  }

  void _showBreakfastAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Breakfast Time!', style: TextStyle(color: Color(0xFFD4AF37))),
        content: const Text('Your 60 minutes are up. You can have your breakfast now.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFFD4AF37))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Welcome, Princess', style: GoogleFonts.playfairDisplay(color: const Color(0xFFD4AF37))),
      ),
      body: Stack(
        children: [
          const FloatingBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGlassCard(
                  child: Column(
                    children: [
                      const Icon(Icons.medication, color: Color(0xFFD4AF37), size: 40),
                      const SizedBox(height: 16),
                      const Text(
                        'Thyroid Medication',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Have you taken your medicine today?',
                        style: TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _timerActive ? Colors.green.withOpacity(0.2) : const Color(0xFFD4AF37),
                          foregroundColor: _timerActive ? Colors.green : Colors.black,
                          minimumSize: const Size(160, 48),
                        ),
                        onPressed: _timerActive ? null : _startTimer,
                        child: Text(
                          _timerActive ? '✓ Taken' : 'I have Taken it',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_timerActive) ...[
                  const SizedBox(height: 32),
                  _buildGlassCard(
                    child: Column(
                      children: [
                        const Text('Time Until Breakfast', style: TextStyle(fontSize: 18, color: Colors.white70)),
                        const SizedBox(height: 12),
                        Text(
                          '${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 56,
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Courier',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoScreen())),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline, color: Color(0xFFD4AF37), size: 20),
                        SizedBox(width: 8),
                        Text('Thyroid Information', style: TextStyle(color: Color(0xFFD4AF37))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.02)],
        ),
      ),
      child: child,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// --- Thyroid Info Screen ---
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const FloatingBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thyroid Health',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      color: const Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        'The thyroid is a small, butterfly-shaped gland at the base of your neck. It produces hormones that regulate your body\'s energy use, along with many other important functions.\n\n'
                        'Key points for medication:\n'
                        '1. Take your medication on an empty stomach.\n'
                        '2. Wait at least 60 minutes before having breakfast.\n'
                        '3. Consistency is key for hormone balance.\n\n'
                        'Always consult your doctor for specific medical advice.',
                        style: GoogleFonts.dmSans(fontSize: 18, height: 1.6, color: Colors.white.withOpacity(0.9)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('వెనక్కి వెళ్ళు', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
