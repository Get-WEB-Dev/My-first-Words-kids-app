import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  List<dynamic> words = [];
  TextEditingController inputController = TextEditingController();
  final AudioPlayer audioPlayer = AudioPlayer();
  Map<String, dynamic>? currentTranslation;
  bool showResults = false;
  List<Map<String, dynamic>> suggestions = [];
  FocusNode inputFocusNode = FocusNode();
  bool showSuggestions = false;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    loadWords();
    inputController.addListener(_updateSuggestions);
  }

  @override
  void dispose() {
    inputController.removeListener(_updateSuggestions);
    inputController.dispose();
    audioPlayer.dispose();
    inputFocusNode.dispose();
    super.dispose();
  }

  Future<void> loadWords() async {
    try {
      final String response =
          await rootBundle.loadString('assets/home/translations.json');
      final data = await json.decode(response);
      setState(() {
        words = data['words'] ?? [];
      });
    } catch (e) {
      debugPrint('Error loading words: $e');
    }
  }

  void _updateSuggestions() {
    final query = inputController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        suggestions = [];
        showSuggestions = false;
      });
      return;
    }

    setState(() {
      suggestions = words.cast<Map<String, dynamic>>().where((word) {
        return (word['english']?.toString().toLowerCase() ?? '')
                .startsWith(query) ||
            (word['amharic']?.toString() ?? '').startsWith(query) ||
            (word['afaan_oromo']?.toString().toLowerCase() ?? '')
                .startsWith(query);
      }).toList();
      showSuggestions = suggestions.isNotEmpty;
    });
  }

  void _selectSuggestion(Map<String, dynamic> word) {
    setState(() {
      inputController.text = _getDisplayText(word);
      currentTranslation = word;
      showResults = true;
      showSuggestions = false;
      inputFocusNode.unfocus();
    });
    _celebrateTranslation();
  }

  String _getDisplayText(Map<String, dynamic> word) {
    final query = inputController.text.trim().toLowerCase();
    if ((word['english']?.toString().toLowerCase() ?? '').startsWith(query)) {
      return word['english'];
    } else if ((word['amharic']?.toString() ?? '').startsWith(query)) {
      return word['amharic'];
    } else {
      return word['afaan_oromo'];
    }
  }

  Future<void> playAudio(String? audioFile) async {
    if (audioFile == null || audioFile.isEmpty) return;
    setState(() => _isSpeaking = true);
    await audioPlayer.play(AssetSource('audio/$audioFile'));
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isSpeaking = false);
  }

  void _celebrateTranslation() {
    // You can add confetti animation or other celebration effects here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Great job! 🎉', style: GoogleFonts.comicNeue(fontSize: 20)),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void translateWord() {
    final query = inputController.text.trim();
    if (query.isEmpty) {
      setState(() {
        showResults = false;
        currentTranslation = null;
      });
      return;
    }

    final foundWord = words.cast<Map<String, dynamic>>().firstWhere(
          (word) =>
              (word['english']?.toString().toLowerCase() ?? '') ==
                  query.toLowerCase() ||
              (word['amharic']?.toString() ?? '') == query ||
              (word['afaan_oromo']?.toString().toLowerCase() ?? '') ==
                  query.toLowerCase(),
          orElse: () => <String, dynamic>{},
        );

    setState(() {
      currentTranslation = foundWord.isNotEmpty ? foundWord : null;
      showResults = true;
      showSuggestions = false;
    });

    if (foundWord.isNotEmpty) {
      _celebrateTranslation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E8FF), // Light purple background
      appBar: AppBar(
        title: Text(
          'Magic Translator',
          style: GoogleFonts.luckiestGuy(
            fontSize: 32,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.purple.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Animated header
            Lottie.asset(
              'assets/home/magic_wand.json',
              height: 100,
              fit: BoxFit.contain,
            ),

            // Input area with suggestions
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: inputController,
                    focusNode: inputFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Type a magic word...',
                      labelStyle: GoogleFonts.comicNeue(
                        fontSize: 20,
                        color: Colors.purple,
                      ),
                      border: InputBorder.none,
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.purple),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      suffixIcon: inputController.text.isNotEmpty
                          ? IconButton(
                              icon:
                                  const Icon(Icons.clear, color: Colors.purple),
                              onPressed: () {
                                inputController.clear();
                                setState(() {
                                  showResults = false;
                                  showSuggestions = false;
                                });
                              },
                            )
                          : null,
                    ),
                    style: GoogleFonts.comicNeue(
                      fontSize: 22,
                    ),
                    onTap: () {
                      setState(() {
                        showSuggestions = inputController.text.isNotEmpty &&
                            suggestions.isNotEmpty;
                      });
                    },
                    onSubmitted: (_) => translateWord(),
                  ),
                ),
                if (showSuggestions)
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.purple[100]!),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: suggestions.length,
                        itemBuilder: (context, index) {
                          final word = suggestions[index];
                          return ListTile(
                            leading: const Icon(Icons.auto_awesome,
                                color: Colors.purple),
                            title: Text(
                              _getDisplayText(word),
                              style: GoogleFonts.comicNeue(
                                fontSize: 20,
                              ),
                            ),
                            onTap: () => _selectSuggestion(word),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Magic translate button
            ElevatedButton(
              onPressed: translateWord,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: 8,
                shadowColor: Colors.orange.withOpacity(0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/home/sparkle.json',
                    height: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Abracadabra!',
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Results area
            if (showResults)
              Expanded(
                child: Column(
                  children: [
                    if (currentTranslation != null) ...[
                      if (!_isInputLanguage(currentTranslation!['english']))
                        _buildTranslationCard(
                          'English',
                          currentTranslation!['english'] ?? 'Not available',
                          currentTranslation!['audio_english'],
                          Colors.blue[100]!,
                        ),
                      if (!_isInputLanguage(currentTranslation!['amharic']))
                        _buildTranslationCard(
                          'አማርኛ',
                          currentTranslation!['amharic'] ?? 'Not available',
                          currentTranslation!['audio_amharic'],
                          Colors.green[100]!,
                        ),
                      if (!_isInputLanguage(currentTranslation!['afaan_oromo']))
                        _buildTranslationCard(
                          'Afaan Oromo',
                          currentTranslation!['afaan_oromo'] ?? 'Not available',
                          currentTranslation!['audio_oromo'],
                          Colors.yellow[100]!,
                        ),
                    ] else
                      Column(
                        children: [
                          Lottie.asset(
                            'assets/home/confused.json',
                            height: 150,
                          ),
                          Text(
                            'Oops! No magic word found!',
                            style: GoogleFonts.comicNeue(
                              fontSize: 24,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isInputLanguage(dynamic value) {
    final query = inputController.text.trim();
    if (value == null) return false;
    return value.toString().toLowerCase() == query.toLowerCase();
  }

  Widget _buildTranslationCard(
      String language, String text, String? audioFile, Color cardColor) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  language,
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 22,
                    color: Colors.purple,
                  ),
                ),
                const Spacer(),
                _isSpeaking && audioFile != null
                    ? Lottie.asset(
                        'assets/home/speaking.json',
                        height: 30,
                      )
                    : IconButton(
                        icon: const Icon(Icons.volume_up, size: 30),
                        color: Colors.purple,
                        onPressed: () => playAudio(audioFile),
                      ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                text,
                style: GoogleFonts.comicNeue(
                  fontSize: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
