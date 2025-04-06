import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';

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
      print('Error loading words: $e');
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
    await audioPlayer.play(AssetSource('audio/$audioFile'));
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text(
          'Kid Translator',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'ComicNeue',
          ),
        ),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Input area with suggestions
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: inputController,
                  focusNode: inputFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Enter a word',
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.deepPurple,
                      fontFamily: 'ComicNeue',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                  ),
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'ComicNeue',
                  ),
                  onTap: () {
                    setState(() {
                      showSuggestions = inputController.text.isNotEmpty &&
                          suggestions.isNotEmpty;
                    });
                  },
                  onSubmitted: (_) => translateWord(),
                ),
                if (showSuggestions)
                  Material(
                    elevation: 4,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: suggestions.length,
                        itemBuilder: (context, index) {
                          final word = suggestions[index];
                          return ListTile(
                            title: Text(
                              _getDisplayText(word),
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'ComicNeue',
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

            // Translate button
            ElevatedButton(
              onPressed: translateWord,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Translate',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontFamily: 'ComicNeue',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Results area
            if (showResults)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (currentTranslation != null) ...[
                      if (!_isInputLanguage(currentTranslation!['english']))
                        _buildTranslationCard(
                          'English',
                          currentTranslation!['english'] ?? 'Not available',
                          currentTranslation!['audio_english'],
                        ),
                      if (!_isInputLanguage(currentTranslation!['amharic']))
                        _buildTranslationCard(
                          'አማርኛ',
                          currentTranslation!['amharic'] ?? 'Not available',
                          currentTranslation!['audio_amharic'],
                        ),
                      if (!_isInputLanguage(currentTranslation!['afaan_oromo']))
                        _buildTranslationCard(
                          'Afaan Oromo',
                          currentTranslation!['afaan_oromo'] ?? 'Not available',
                          currentTranslation!['audio_oromo'],
                        ),
                    ] else
                      const Text(
                        'Word not found!',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.red,
                          fontFamily: 'ComicNeue',
                        ),
                        textAlign: TextAlign.center,
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
      String language, String text, String? audioFile) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              language,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                fontFamily: 'ComicNeue',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 28,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up, size: 30),
                  color: Colors.blue,
                  onPressed: () => playAudio(audioFile),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
