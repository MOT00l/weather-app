import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedCardScreen(),
    );
  }
}

class AnimatedCardScreen extends StatefulWidget {
  @override
  _AnimatedCardScreenState createState() => _AnimatedCardScreenState();
}

class _AnimatedCardScreenState extends State<AnimatedCardScreen> {
  bool _isVisible = false;

  void _toggleCard() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text("Animated Card")),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _toggleCard,
              child: Text("Toggle Card"),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: _isVisible ? 20 : -300, // Move in from the left
            top: 200,
            child: Card(
              elevation: 8,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: 250,
                height: 150,
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    "Hello, I'm an animated card!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
