import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Progress Tracking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProgressTrackingScreen(),
    );
  }
}

class ProgressTrackingScreen extends StatefulWidget {
  @override
  _ProgressTrackingScreenState createState() => _ProgressTrackingScreenState();
}

class _ProgressTrackingScreenState extends State<ProgressTrackingScreen> {
  int _quizScore = 0;
  double _proficiencyLevel = 0.0; // This could be calculated dynamically
  List<String> _wordsLearned = []; // List to store words learned by the user
  List<String> _selectedCategoryWords = []; // List to store words for selected category
  int _currentWordIndex = 0;
  TextEditingController _wordInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProgressData();
    _loadWords(); // Load words for the selected category
  }

  Future<void> _loadProgressData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _quizScore = prefs.getInt('quiz_score') ?? 0;
      _proficiencyLevel = prefs.getDouble('proficiency_level') ?? 0.0;
      _wordsLearned = prefs.getStringList('words_learned') ?? [];
    });
  }

  Future<void> _updateProgressData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('quiz_score', _quizScore);
    prefs.setDouble('proficiency_level', _proficiencyLevel);
    prefs.setStringList('words_learned', _wordsLearned);
  }

  Future<void> _loadWords() async {
    // Simulate loading words for a selected category
    // For demonstration, let's assume we have some sample words for category 'Animals'
    setState(() {
      _selectedCategoryWords = ['Cat', 'Dog', 'Elephant', 'Lion', 'Tiger'];
    });
  }

  void _learnWord(String word) {
    // Add the word to the list of words learned
    setState(() {
      _wordsLearned.add(word);
      _updateProgressData();
    });
  }

  void _updateQuizScore(int score) {
    setState(() {
      _quizScore = score;
      _updateProgressData();
    });
  }

  void _updateProficiencyLevel() {
    // Calculate proficiency level based on quiz score and words learned
    // For demonstration, let's calculate it as the percentage of words learned out of total words
    double totalWords = _selectedCategoryWords.length.toDouble();
    double learnedWords = _wordsLearned.length.toDouble();
    double proficiencyPercentage = (learnedWords / totalWords) * 100;
    setState(() {
      _proficiencyLevel = proficiencyPercentage;
      _updateProgressData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress Tracking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Words Learned: ${_wordsLearned.length}'),
            SizedBox(height: 20),
            Text('Quiz Score: $_quizScore'),
            SizedBox(height: 20),
            Text('Proficiency Level: ${_proficiencyLevel.toStringAsFixed(2)}%'),
            SizedBox(height: 20),
            TextField(
              controller: _wordInputController,
              decoration: InputDecoration(
                labelText: 'Enter Word to Learn',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _learnWord(_wordInputController.text); // Learn the word input by the user
                _wordInputController.clear(); // Clear the text input field
              },
              child: Text('Learn Word'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen(updateQuizScore: _updateQuizScore)),
                );
              },
              child: Text('Take Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}


class QuizScreen extends StatefulWidget {
  final Function(int) updateQuizScore;

  QuizScreen({required this.updateQuizScore});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _score = 0;
  int _questionIndex = 0;

  final List<Map<String, dynamic>> _quizQuestions = [
    {
      'question': 'What is the capital of France?',
      'options': ['Paris', 'London', 'Berlin', 'Rome'],
      'correctAnswer': 'Paris',
    },
    {
      'question': 'What is the largest mammal?',
      'options': ['Elephant', 'Blue Whale', 'Giraffe', 'Hippopotamus'],
      'correctAnswer': 'Blue Whale',
    },
    {
      'question': 'What is the chemical symbol for water?',
      'options': ['W', 'Wa', 'H2O', 'O'],
      'correctAnswer': 'H2O',
    },
    {
      'question': 'Who wrote "To Kill a Mockingbird"?',
      'options': ['Harper Lee', 'J.K. Rowling', 'Stephen King', 'Mark Twain'],
      'correctAnswer': 'Harper Lee',
    },
    {
      'question': 'What is the largest planet in our solar system?',
      'options': ['Jupiter', 'Saturn', 'Neptune', 'Mars'],
      'correctAnswer': 'Jupiter',
    },
    {
      'question': 'What is the chemical symbol for gold?',
      'options': ['Au', 'Ag', 'Fe', 'Pb'],
      'correctAnswer': 'Au',
    },
    {
      'question': 'Who painted the Mona Lisa?',
      'options': ['Leonardo da Vinci', 'Pablo Picasso', 'Vincent van Gogh', 'Michelangelo'],
      'correctAnswer': 'Leonardo da Vinci',
    },
    {
      'question': 'Which country is known as the Land of the Rising Sun?',
      'options': ['Japan', 'China', 'South Korea', 'Thailand'],
      'correctAnswer': 'Japan',
    },
    {
      'question': 'What is the square root of 144?',
      'options': ['12', '10', '14', '16'],
      'correctAnswer': '12',
    },
    {
      'question': 'What is the capital of Australia?',
      'options': ['Sydney', 'Melbourne', 'Canberra', 'Brisbane'],
      'correctAnswer': 'Canberra',
    },
    {
      'question': 'Who invented the telephone?',
      'options': ['Alexander Graham Bell', 'Thomas Edison', 'Nikola Tesla', 'Albert Einstein'],
      'correctAnswer': 'Alexander Graham Bell',
    },
    {
      'question': 'What is the largest ocean on Earth?',
      'options': ['Pacific Ocean', 'Atlantic Ocean', 'Indian Ocean', 'Arctic Ocean'],
      'correctAnswer': 'Pacific Ocean',
    },
    {
      'question': 'Who discovered penicillin?',
      'options': ['Alexander Fleming', 'Marie Curie', 'Albert Einstein', 'Isaac Newton'],
      'correctAnswer': 'Alexander Fleming',
    },
    {
      'question': 'What is the chemical symbol for iron?',
      'options': ['Fe', 'Au', 'Ag', 'Pb'],
      'correctAnswer': 'Fe',
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Mars', 'Venus', 'Jupiter', 'Mercury'],
      'correctAnswer': 'Mars',
    },
    {
      'question': 'Who wrote "The Great Gatsby"?',
      'options': ['F. Scott Fitzgerald', 'Ernest Hemingway', 'Mark Twain', 'J.K. Rowling'],
      'correctAnswer': 'F. Scott Fitzgerald',
    },
    {
      'question': 'What is the capital of Brazil?',
      'options': ['Rio de Janeiro', 'Brasília', 'São Paulo', 'Salvador'],
      'correctAnswer': 'Brasília',
    },
    {
      'question': 'What is the chemical symbol for oxygen?',
      'options': ['O', 'H2O', 'O2', 'O3'],
      'correctAnswer': 'O',
    },
    {
      'question': 'Who wrote "1984"?',
      'options': ['George Orwell', 'F. Scott Fitzgerald', 'Ernest Hemingway', 'Charles Dickens'],
      'correctAnswer': 'George Orwell',
    },
    {
      'question': 'What is the largest continent by land area?',
      'options': ['Asia', 'Africa', 'North America', 'Europe'],
      'correctAnswer': 'Asia',
    },
    {
      'question': 'What is the chemical symbol for carbon?',
      'options': ['C', 'Co', 'Ca', 'Cr'],
      'correctAnswer': 'C',
    },
  ];

  void _submitAnswer(String selectedOption) {
    if (selectedOption == _quizQuestions[_questionIndex]['correctAnswer']) {
      setState(() {
        _score++;
      });
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
    });
    if (_questionIndex == _quizQuestions.length) {
      widget.updateQuizScore(_score);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: _questionIndex < _quizQuestions.length
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Question ${_questionIndex + 1}:'),
          SizedBox(height: 20),
          Text(
            _quizQuestions[_questionIndex]['question'],
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          ...(_quizQuestions[_questionIndex]['options'] as List<String>).map((option) {
            return ElevatedButton(
              onPressed: () => _submitAnswer(option),
              child: Text(option),
            );
          }).toList(),
        ],
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Quiz Completed!'),
            SizedBox(height: 20),
            Text('Your Score: $_score'),
          ],
        ),
      ),
    );
  }
}
