import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExchangeGridPage extends StatelessWidget {
  const ExchangeGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E8C7), // Parchment-like background
      body: Column(
        children: [
          // Top Status Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.brown[800],
              border: Border.all(color: Colors.brown[900]!, width: 2),
            ),
            child: Row(
              children: [
                // Horse Currency
                _buildStatusItem(Icons.agriculture, "640"),
                const SizedBox(width: 16),
                // Crown Currency
                _buildStatusItem(Icons.emoji_events, "10.8K"),
                const Spacer(),
                // Time
                Text(
                  "8:52",
                  style: GoogleFonts.medievalSharp(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                // Network Status
                const Icon(Icons.network_cell, color: Colors.white, size: 18),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Main Reward Box at Top
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber[300]!, width: 3),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildResourceItem("12K", Icons.bolt, Colors.blue),
                            const SizedBox(width: 20),
                            _buildResourceItem(
                                "600", Icons.agriculture, Colors.grey),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "FREE",
                          style: GoogleFonts.medievalSharp(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Down arrow from main reward
                  const Icon(Icons.arrow_downward,
                      color: Colors.amber, size: 36),

                  // First Row of Boxes
                  _buildBoxRow(
                    context,
                    boxes: [
                      _BoxData(value: "5", icon: Icons.bolt, locked: false),
                      _BoxData(
                          value: "10", icon: Icons.agriculture, locked: false),
                      _BoxData(
                          value: "8", icon: Icons.emoji_events, locked: true),
                    ],
                  ),

                  // Down arrow between rows
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Icon(Icons.arrow_downward,
                        color: Colors.amber, size: 36),
                  ),

                  // Second Row of Boxes
                  _buildBoxRow(
                    context,
                    boxes: [
                      _BoxData(value: "15", icon: Icons.bolt, locked: false),
                      _BoxData(
                          value: "20", icon: Icons.agriculture, locked: true),
                      _BoxData(
                          value: "18", icon: Icons.emoji_events, locked: true),
                    ],
                  ),

                  // Down arrow between rows
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Icon(Icons.arrow_downward,
                        color: Colors.amber, size: 36),
                  ),

                  // Third Row of Boxes (some completed)
                  _buildBoxRow(
                    context,
                    boxes: [
                      _BoxData(
                          value: "25",
                          icon: Icons.bolt,
                          locked: false,
                          completed: true),
                      _BoxData(
                          value: "30",
                          icon: Icons.agriculture,
                          locked: false,
                          completed: true),
                      _BoxData(
                          value: "28", icon: Icons.emoji_events, locked: true),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: Colors.red[700],
        child: const Icon(Icons.close, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBoxRow(BuildContext context, {required List<_BoxData> boxes}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 0; i < boxes.length; i++) ...[
            _buildExchangeBox(boxes[i]),
            if (i < boxes.length - 1)
              const Icon(Icons.arrow_forward, color: Colors.amber, size: 36),
          ],
        ],
      ),
    );
  }

  Widget _buildExchangeBox(_BoxData data) {
    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        color: data.locked ? Colors.grey[300] : Colors.amber[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: data.locked ? Colors.grey : Colors.amber[300]!,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(data.icon,
                  size: 36,
                  color: data.locked ? Colors.grey : Colors.amber[800]),
              const SizedBox(height: 4),
              Text(
                data.value,
                style: GoogleFonts.medievalSharp(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: data.locked ? Colors.grey : Colors.brown[800],
                ),
              ),
            ],
          ),
          if (data.locked)
            const Positioned(
              bottom: 4,
              left: 4,
              child: Icon(Icons.lock, color: Colors.amber, size: 16),
            ),
          if (data.completed)
            Container(
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.check_circle, color: Colors.green, size: 36),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.medievalSharp(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildResourceItem(String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 36),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.medievalSharp(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _BoxData {
  final String value;
  final IconData icon;
  final bool locked;
  final bool completed;

  _BoxData({
    required this.value,
    required this.icon,
    this.locked = false,
    this.completed = false,
  });
}
