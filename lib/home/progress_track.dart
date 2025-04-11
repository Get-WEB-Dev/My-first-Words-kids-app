import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../School/Nursery/English/Quarter 1/services.dart';
import 'quiz_progress.dart';

class CategoryProgressPage extends StatefulWidget {
  const CategoryProgressPage({super.key});

  @override
  State<CategoryProgressPage> createState() => _CategoryProgressPageState();
}

class _CategoryProgressPageState extends State<CategoryProgressPage> {
  late Map<String, double> _categoryProgress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await ProgressServices().getCategoryProgress();
    setState(() {
      _categoryProgress = progress;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Progress', style: GoogleFonts.comicNeue()),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProgress,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: _categoryProgress.entries.map((entry) {
                  return _buildCategoryProgressCard(
                    entry.key,
                    entry.value,
                    _getCategoryColor(entry.key),
                  );
                }).toList(),
              ),
            ),
    );
  }

  Widget _buildCategoryProgressCard(
      String category, double progress, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: GoogleFonts.comicNeue(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 20,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: GoogleFonts.comicNeue(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () => _showCategoryDetails(category),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    // Assign colors based on category
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
    ];
    return colors[category.hashCode % colors.length];
  }

  void _showCategoryDetails(String category) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => _buildCategoryDetailsSheet(category),
    );
  }

  Widget _buildCategoryDetailsSheet(String category) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category,
            style: GoogleFonts.comicNeue(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder(
            future: _getCategoryQuizzes(category),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final quizzes = snapshot.data ?? [];
              return Column(
                children: quizzes
                    .map((quiz) => _buildQuizProgressTile(quiz))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuizProgressTile(QuizProgress quiz) {
    return ListTile(
      title: Text(quiz.title),
      trailing: Text(
        '${quiz.score}/${quiz.totalQuestions}',
        style: GoogleFonts.comicNeue(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: LinearProgressIndicator(
        value: quiz.totalQuestions > 0 ? quiz.score / quiz.totalQuestions : 0,
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Future<List<QuizProgress>> _getCategoryQuizzes(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await DataService.loadAllItems();
    final quizzes = items
        .where((item) =>
            item.type == 'quiz' &&
            (item.category ?? 'Uncategorized') == category)
        .toList();

    return quizzes.map((quiz) {
      final score = prefs.getInt('quiz_score_${quiz.id}') ?? 0;
      return QuizProgress(
        title: quiz.title,
        score: score,
        totalQuestions: quiz.questions?.length ?? 0,
      );
    }).toList();
  }
}

class QuizProgress {
  final String title;
  final int score;
  final int totalQuestions;

  QuizProgress({
    required this.title,
    required this.score,
    required this.totalQuestions,
  });
}
