import 'package:flutter/material.dart';

class KidSettingsPanel extends StatefulWidget {
  final bool initialSoundEnabled;
  final bool initialMusicEnabled;
  final double initialSoundVolume;
  final double initialMusicVolume;
  final Function(bool) onSoundChanged;
  final Function(bool) onMusicChanged;
  final Function(double) onSoundVolumeChanged;
  final Function(double) onMusicVolumeChanged;
  final VoidCallback onClosePressed;

  const KidSettingsPanel({
    super.key,
    this.initialSoundEnabled = true,
    this.initialMusicEnabled = true,
    this.initialSoundVolume = 0.8,
    this.initialMusicVolume = 0.6,
    required this.onSoundChanged,
    required this.onMusicChanged,
    required this.onSoundVolumeChanged,
    required this.onMusicVolumeChanged,
    required this.onClosePressed,
  });

  @override
  State<KidSettingsPanel> createState() => _KidSettingsPanelState();
}

class _KidSettingsPanelState extends State<KidSettingsPanel> {
  late bool _soundEnabled;
  late bool _musicEnabled;
  late double _soundVolume;
  late double _musicVolume;
  bool _showSettings = false;

  @override
  void initState() {
    super.initState();
    _soundEnabled = widget.initialSoundEnabled;
    _musicEnabled = widget.initialMusicEnabled;
    _soundVolume = widget.initialSoundVolume;
    _musicVolume = widget.initialMusicVolume;
  }

  void _toggleSettings() {
    setState(() => _showSettings = !_showSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Settings Button
        Positioned(
          top: 20,
          right: 20,
          child: _buildSettingsButton(),
        ),

        // Settings Panel
        if (_showSettings)
          Positioned(
            top: 80,
            right: 20,
            child: _buildSettingsPanel(),
          ),
      ],
    );
  }

  Widget _buildSettingsButton() {
    return GestureDetector(
      onTap: _toggleSettings,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange[300],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(Icons.settings, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return Material(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.lightBlue[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildPanelHeader(),
            _buildSoundControls(),
            _buildMusicControls(),
            _buildCloseButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelHeader() {
    return Row(
      children: [
        const Icon(Icons.settings, color: Colors.blue),
        const SizedBox(width: 8),
        Text(
          'SETTINGS',
          style: TextStyle(
            color: Colors.blue[800],
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'LuckiestGuy',
          ),
        ),
      ],
    );
  }

  Widget _buildSoundControls() {
    return Column(
      children: [
        _buildCartoonSwitch(
          icon: Icons.volume_up,
          label: 'Sounds',
          value: _soundEnabled,
          onChanged: (val) {
            setState(() => _soundEnabled = val);
            widget.onSoundChanged(val);
          },
        ),
        if (_soundEnabled)
          Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 8),
            child: Slider(
              value: _soundVolume,
              onChanged: (val) {
                setState(() => _soundVolume = val);
                widget.onSoundVolumeChanged(val);
              },
              activeColor: Colors.orange,
              inactiveColor: Colors.orange[100],
            ),
          ),
      ],
    );
  }

  Widget _buildMusicControls() {
    return Column(
      children: [
        _buildCartoonSwitch(
          icon: Icons.music_note,
          label: 'Music',
          value: _musicEnabled,
          onChanged: (val) {
            setState(() => _musicEnabled = val);
            widget.onMusicChanged(val);
          },
        ),
        if (_musicEnabled)
          Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 8),
            child: Slider(
              value: _musicVolume,
              onChanged: (val) {
                setState(() => _musicVolume = val);
                widget.onMusicVolumeChanged(val);
              },
              activeColor: Colors.purple,
              inactiveColor: Colors.purple[100],
            ),
          ),
      ],
    );
  }

  Widget _buildCloseButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
      onPressed: _toggleSettings,
      child: const Text('OK', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildCartoonSwitch({
    required IconData icon,
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[800], size: 28),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: Colors.blue[800], fontSize: 16)),
          const Spacer(),
          Transform.scale(
            scale: 1.3,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.green,
              inactiveThumbColor: Colors.red[300],
            ),
          ),
        ],
      ),
    );
  }
}
