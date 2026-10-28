import 'package:flutter/material.dart';

void main() {
  runApp(const TextAnalyzerApp());
}

class TextAnalyzerApp extends StatelessWidget {
  const TextAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teksto analizė',
      home: const AnalysisScreen(),
    );
  }
}

class AnalysisResult {
  final String text;
  final int sentences, words, punctuationMarks, digits;

  AnalysisResult({
    required this.text,
    required this.sentences,
    required this.words,
    required this.punctuationMarks,
    required this.digits,
  });
}

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<AnalysisResult> _history = [];
  AnalysisResult? _current;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _analyze() {
    final text = _controller.text;
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Įveskite tekstą analizei')),
      );
      return;
    }

    final result = AnalysisResult(
      text: text,
      sentences: Counter.getSentenceCount(text),
      words: Counter.getWordCount(text),
      punctuationMarks: Counter.getPunctuationCount(text),
      digits: Counter.getNumberCount(text),
    );

    setState(() {
      _current = result;
      _history.insert(0, result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teksto analizė')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Įveskite tekstą',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _analyze,
                child: const Text('Analizuoti'),
              ),
              const SizedBox(height: 16),
              if (_current == null)
                const Text('Rezultatų dar nėra. Įveskite tekstą ir paspauskite "Analizuoti".')
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rezultatai',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text('Sakiniai: ${_current!.sentences}'),
                        Text('Žodžiai: ${_current!.words}'),
                        Text('Skyrybos ženklai: ${_current!.punctuationMarks}'),
                        Text('Skaičiai: ${_current!.digits}'),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              const Text(
                'Tikrinimų istorija',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              if (_history.isEmpty)
                const Text('Istorija tuščia.')
            else
              for (final item in _history)
                ListTile(
                  subtitle: Text(
                    'Tekstas: ${item.text}\n'
                    'Sakiniai: ${item.sentences}\n'
                    'Žodžiai: ${item.words}\n'
                    'Skyrybos ženklai: ${item.punctuationMarks}\n'
                    'Skaičiai: ${item.digits}',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Counter {
  static int getWordCount(String? input) {
    if (input == null) return -1;
    final words = input.trim().split(RegExp(r'\s+'));
    int wordCount = 0;
    for (final word in words) {
      final subWords = word.split(RegExp(r'[^a-zA-ZąčęėįšųūžĄČĘĖĮŠŲŪŽ]+'));
      for (final singleWord in subWords) {
        if (singleWord.isNotEmpty) {
          wordCount++;
        }
      }
    }
    return wordCount;
  }

  static int getSentenceCount(String? input) {
    if (input == null) return -1;
    String text = input.trim();
    List<String> pieces = text.split(RegExp(r'[.!?]+'));
    int count = 0;
    for (String piece in pieces) {
      if (RegExp(r'[a-zA-ZąčęėįšųūžĄČĘĖĮŠŲŪŽ0-9]').hasMatch(piece)) {
        count++;
      }
    }
    return count;
  }

  static int getNumberCount(String? input) {
    if (input == null) return -1;
    int count = 0;
    for (final c in input.split('')) {
      if (RegExp(r'[0-9]').hasMatch(c)) {
        count++;
      }
    }
    return count;
  }

  static int getPunctuationCount(String? input) {
    if (input == null) return -1;
    int count = 0;
    for (final c in input.split('')) {
      if (RegExp(r'[.,!?;:\-–—()"„“]').hasMatch(c)) {
        count++;
      }
    }
    return count;
  }
}
