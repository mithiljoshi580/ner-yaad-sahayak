import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String gameName;

  const QuizScreen({
    super.key,
    required this.gameName,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  String? selectedOption;
  bool isAnswerChecked = false;
  int score = 0;

  late final List<Map<String, dynamic>> questions;

  // Theme Colors
  static const Color backgroundColor = Color(0xFF080B14);
  static const Color cardColor = Color(0xFF111827);
  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFF3B82F6);
  static const Color borderColor = Color(0xFF263548);
  static const Color secondaryTextColor = Color(0xFF9CA3AF);

  @override
  void initState() {
    super.initState();
    questions = _getQuestionsForGame();
  }

  // ================= QUIZ DATA =================

  List<Map<String, dynamic>> _getQuestionsForGame() {
    switch (widget.gameName) {
      // ================= THANG TA =================
      case 'Thang Ta':
        return [
          {
            'question': 'What is the origin of Thang Ta?',
            'options': [
              {'letter': 'A', 'text': 'Manipur'},
              {'letter': 'B', 'text': 'Assam'},
              {'letter': 'C', 'text': 'Meghalaya'},
              {'letter': 'D', 'text': 'Nagaland'},
            ],
            'correctAnswer': 'A',
          },
          {
            'question': 'What does Thang Ta traditionally involve?',
            'options': [
              {'letter': 'A', 'text': 'Swimming and racing'},
              {'letter': 'B', 'text': 'Swords and spears'},
              {'letter': 'C', 'text': 'Archery only'},
              {'letter': 'D', 'text': 'Horse riding'},
            ],
            'correctAnswer': 'B',
          },
          {
            'question': 'Thang Ta is mainly known as which type of art?',
            'options': [
              {'letter': 'A', 'text': 'Martial Art'},
              {'letter': 'B', 'text': 'Dance Form'},
              {'letter': 'C', 'text': 'Board Game'},
              {'letter': 'D', 'text': 'Musical Instrument'},
            ],
            'correctAnswer': 'A',
          },
          {
            'question':
                'Which region of India is strongly associated with Thang Ta?',
            'options': [
              {'letter': 'A', 'text': 'South India'},
              {'letter': 'B', 'text': 'North-East India'},
              {'letter': 'C', 'text': 'Western India'},
              {'letter': 'D', 'text': 'Central India'},
            ],
            'correctAnswer': 'B',
          },
          {
            'question': 'Why is Thang Ta culturally important?',
            'options': [
              {
                'letter': 'A',
                'text': 'It represents traditional heritage',
              },
              {'letter': 'B', 'text': 'It is a modern video game'},
              {'letter': 'C', 'text': 'It was created recently'},
              {
                'letter': 'D',
                'text': 'It is only played internationally',
              },
            ],
            'correctAnswer': 'A',
          },
        ];

      // ================= MUKNA =================
      case 'Mukna':
        return [
          {
            'question': 'Mukna is a traditional sport from which state?',
            'options': [
              {'letter': 'A', 'text': 'Manipur'},
              {'letter': 'B', 'text': 'Kerala'},
              {'letter': 'C', 'text': 'Punjab'},
              {'letter': 'D', 'text': 'Gujarat'},
            ],
            'correctAnswer': 'A',
          },
          {
            'question': 'Mukna is primarily a form of which sport?',
            'options': [
              {'letter': 'A', 'text': 'Swimming'},
              {'letter': 'B', 'text': 'Wrestling'},
              {'letter': 'C', 'text': 'Football'},
              {'letter': 'D', 'text': 'Archery'},
            ],
            'correctAnswer': 'B',
          },
          {
            'question': 'Which quality is important in Mukna?',
            'options': [
              {'letter': 'A', 'text': 'Strength and strategy'},
              {'letter': 'B', 'text': 'Painting skills'},
              {'letter': 'C', 'text': 'Singing ability'},
              {'letter': 'D', 'text': 'Cooking skills'},
            ],
            'correctAnswer': 'A',
          },
          {
            'question': 'Mukna represents which part of Indian heritage?',
            'options': [
              {'letter': 'A', 'text': 'Traditional sports culture'},
              {'letter': 'B', 'text': 'Modern technology'},
              {'letter': 'C', 'text': 'Space exploration'},
              {'letter': 'D', 'text': 'Digital gaming'},
            ],
            'correctAnswer': 'A',
          },
          {
            'question': 'Mukna players mainly compete using?',
            'options': [
              {'letter': 'A', 'text': 'Traditional wrestling techniques'},
              {'letter': 'B', 'text': 'Vehicles'},
              {'letter': 'C', 'text': 'Electronic devices'},
              {'letter': 'D', 'text': 'Musical instruments'},
            ],
            'correctAnswer': 'A',
          },
        ];

      // ================= INSUKNAWR =================
      case 'Insuknawr':
        return [
          {
            'question': 'Insuknawr is a traditional game associated with?',
            'options': [
              {'letter': 'A', 'text': 'North-East India'},
              {'letter': 'B', 'text': 'Europe'},
              {'letter': 'C', 'text': 'South America'},
              {'letter': 'D', 'text': 'Australia'},
            ],
            'correctAnswer': 'A',
          },
          {
            'question': 'Which quality is important while playing Insuknawr?',
            'options': [
              {'letter': 'A', 'text': 'Teamwork'},
              {'letter': 'B', 'text': 'Driving'},
              {'letter': 'C', 'text': 'Painting'},
              {'letter': 'D', 'text': 'Programming'},
            ],
            'correctAnswer': 'A',
          },
          {
            'question': 'Insuknawr represents which values?',
            'options': [
              {'letter': 'A', 'text': 'Courage and teamwork'},
              {'letter': 'B', 'text': 'Technology and robots'},
              {'letter': 'C', 'text': 'Cooking and farming'},
              {'letter': 'D', 'text': 'Space science'},
            ],
            'correctAnswer': 'A',
          },
          {
            'question': 'Insuknawr is an example of?',
            'options': [
              {'letter': 'A', 'text': 'Traditional cultural game'},
              {'letter': 'B', 'text': 'Modern computer game'},
              {'letter': 'C', 'text': 'Mobile application'},
              {'letter': 'D', 'text': 'Musical performance'},
            ],
            'correctAnswer': 'A',
          },
          {
            'question':
                'Why are traditional games like Insuknawr important?',
            'options': [
              {
                'letter': 'A',
                'text': 'They preserve cultural heritage',
              },
              {'letter': 'B', 'text': 'They replace technology'},
              {'letter': 'C', 'text': 'They are only for computers'},
              {'letter': 'D', 'text': 'They have no cultural value'},
            ],
            'correctAnswer': 'A',
          },
        ];

      default:
        return [];
    }
  }

  // ================= QUIZ LOGIC =================

  void _checkAnswer() {
    if (selectedOption == null || isAnswerChecked) return;

    final correctAnswer =
        questions[currentQuestionIndex]['correctAnswer'] as String;

    setState(() {
      isAnswerChecked = true;

      if (selectedOption == correctAnswer) {
        score++;
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOption = null;
        isAnswerChecked = false;
      });
    } else {
      _showCompletionDialog();
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          title: const Text('Quiz'),
        ),
        body: const Center(
          child: Text(
            'No quiz available.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];
    final correctAnswer =
        currentQuestion['correctAnswer'] as String;

    final double progress =
        (currentQuestionIndex + 1) / questions.length;

    final bool isCorrect = selectedOption == correctAnswer;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,

        title: Text(
          '${widget.gameName} Quiz',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // QUESTION PROGRESS
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'QUESTION ${currentQuestionIndex + 1} OF ${questions.length}',
                    style: const TextStyle(
                      color: Color(0xFF60A5FA),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),

                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      color: secondaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const LinearProgressIndicator(
                  value: 0,
                  minHeight: 8,
                  backgroundColor: Color(0xFF1E293B),
                ),
              ),

              // ACTUAL PROGRESS BAR
              const SizedBox(height: 0),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.transparent,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(
                    accentColor,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // QUESTION CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),

                  gradient: const LinearGradient(
                    colors: [
                      primaryColor,
                      cardColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  border: Border.all(
                    color: borderColor,
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 55,
                      height: 55,

                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.quiz_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      currentQuestion['question'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      isAnswerChecked
                          ? (isCorrect
                              ? 'Correct! Great job! 🎉'
                              : 'Not quite! Check the correct answer below.')
                          : 'Choose the correct answer.',

                      style: TextStyle(
                        color: isAnswerChecked
                            ? (isCorrect
                                ? Colors.greenAccent
                                : Colors.redAccent)
                            : secondaryTextColor,

                        fontSize: 15,

                        fontWeight: isAnswerChecked
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Choose your answer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // OPTIONS
              ...(currentQuestion['options'] as List).map<Widget>(
                (option) => Padding(
                  padding:
                      const EdgeInsets.only(bottom: 14),

                  child: _buildOptionCard(
                    letter: option['letter'] as String,
                    text: option['text'] as String,
                    correctAnswer: correctAnswer,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ANSWER FEEDBACK
              if (isAnswerChecked)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin:
                      const EdgeInsets.only(bottom: 20),

                  decoration: BoxDecoration(
                    color: isCorrect
                        ? Colors.green.withOpacity(0.12)
                        : Colors.red.withOpacity(0.12),

                    borderRadius:
                        BorderRadius.circular(16),

                    border: Border.all(
                      color: isCorrect
                          ? Colors.greenAccent
                          : Colors.redAccent,
                    ),
                  ),

                  child: Row(
                    children: [
                      Icon(
                        isCorrect
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,

                        color: isCorrect
                            ? Colors.greenAccent
                            : Colors.redAccent,

                        size: 28,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          isCorrect
                              ? 'Correct answer! +1 point 🎉'
                              : 'Incorrect. The correct answer is $correctAnswer.',

                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // MAIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  onPressed: selectedOption == null
                      ? null
                      : () {
                          if (!isAnswerChecked) {
                            _checkAnswer();
                          } else {
                            _nextQuestion();
                          }
                        },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    disabledBackgroundColor:
                        const Color(0xFF1E293B),

                    foregroundColor: Colors.white,
                    disabledForegroundColor:
                        secondaryTextColor,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [
                      Icon(
                        !isAnswerChecked
                            ? Icons.fact_check_rounded
                            : currentQuestionIndex ==
                                    questions.length - 1
                                ? Icons.emoji_events_rounded
                                : Icons.arrow_forward_rounded,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        !isAnswerChecked
                            ? 'Check Answer'
                            : currentQuestionIndex ==
                                    questions.length - 1
                                ? 'Finish Quiz'
                                : 'Next Question',

                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ================= OPTION CARD =================

  Widget _buildOptionCard({
    required String letter,
    required String text,
    required String correctAnswer,
  }) {
    final bool isSelected = selectedOption == letter;
    final bool isCorrectOption =
        letter == correctAnswer;

    Color optionBackgroundColor = cardColor;
    Color optionBorderColor = borderColor;
    Color circleColor = const Color(0xFF1E293B);

    IconData? resultIcon;

    if (isAnswerChecked) {
      if (isCorrectOption) {
        optionBackgroundColor =
            const Color(0xFF123B2A);

        optionBorderColor = Colors.greenAccent;

        circleColor = Colors.green;

        resultIcon = Icons.check_rounded;
      } else if (isSelected) {
        optionBackgroundColor =
            const Color(0xFF4A2028);

        optionBorderColor = Colors.redAccent;

        circleColor = Colors.redAccent;

        resultIcon = Icons.close_rounded;
      }
    } else if (isSelected) {
      optionBackgroundColor =
          const Color(0xFF1E3A5F);

      optionBorderColor = accentColor;

      circleColor = accentColor;

      resultIcon = Icons.check_rounded;
    }

    return GestureDetector(
      onTap: isAnswerChecked
          ? null
          : () {
              setState(() {
                selectedOption = letter;
              });
            },

      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 250),

        width: double.infinity,

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: optionBackgroundColor,

          borderRadius:
              BorderRadius.circular(18),

          border: Border.all(
            color: optionBorderColor,

            width: isSelected ||
                    (isAnswerChecked &&
                        isCorrectOption)
                ? 2
                : 1,
          ),
        ),

        child: Row(
          children: [
            AnimatedContainer(
              duration:
                  const Duration(milliseconds: 250),

              width: 42,
              height: 42,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: circleColor,
              ),

              child: Center(
                child: resultIcon != null
                    ? Icon(
                        resultIcon,
                        color: Colors.white,
                      )
                    : Text(
                        letter,
                        style: const TextStyle(
                          color: Color(0xFFC7CDD8),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                text,

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,

                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.w500,
                ),
              ),
            ),

            if (isAnswerChecked && isCorrectOption)
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.greenAccent,
              )
            else if (isAnswerChecked && isSelected)
              const Icon(
                Icons.cancel_rounded,
                color: Colors.redAccent,
              ),
          ],
        ),
      ),
    );
  }

  // ================= QUIZ COMPLETION DIALOG =================

  void _showCompletionDialog() {
    final int totalQuestions = questions.length;

    final double percentage =
        (score / totalQuestions) * 100;

    String message;
    IconData resultIcon;

    if (percentage == 100) {
      message = 'Perfect score! Outstanding knowledge! 🌟';
      resultIcon =
          Icons.workspace_premium_rounded;
    } else if (percentage >= 60) {
      message =
          'Great job! Keep exploring and learning! 🎉';
      resultIcon = Icons.emoji_events_rounded;
    } else {
      message =
          'Nice effort! Try again and improve your score! 💪';
      resultIcon = Icons.school_rounded;
    }

    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,

          child: Container(
            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              color: cardColor,

              borderRadius:
                  BorderRadius.circular(28),

              border: Border.all(
                color: borderColor,
              ),

              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withOpacity(0.4),

                  blurRadius: 25,

                  offset:
                      const Offset(0, 10),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                // RESULT ICON
                Container(
                  width: 80,
                  height: 80,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: primaryColor,

                    border: Border.all(
                      color: accentColor,
                      width: 2,
                    ),
                  ),

                  child: Icon(
                    resultIcon,
                    color:
                        const Color(0xFFFFC857),
                    size: 42,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Quiz Completed!',

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  widget.gameName,

                  style: const TextStyle(
                    color: Color(0xFF60A5FA),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 25),

                // SCORE CARD
                Container(
                  width: double.infinity,

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 25,
                  ),

                  decoration: BoxDecoration(
                    color: backgroundColor,

                    borderRadius:
                        BorderRadius.circular(20),

                    border: Border.all(
                      color: borderColor,
                    ),
                  ),

                  child: Column(
                    children: [
                      const Text(
                        'YOUR SCORE',

                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '$score / $totalQuestions',

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        '${percentage.toInt()}% Correct',

                        style: const TextStyle(
                          color: Color(0xFF60A5FA),
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  message,

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 28),

                // BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },

                        style:
                            OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: borderColor,
                          ),

                          foregroundColor:
                              secondaryTextColor,

                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 15,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),
                        ),

                        child: const Text(
                          'Exit',

                          style: TextStyle(
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child:
                          ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);

                          setState(() {
                            currentQuestionIndex = 0;
                            selectedOption = null;
                            isAnswerChecked = false;
                            score = 0;
                          });
                        },

                        icon: const Icon(
                          Icons.refresh_rounded,
                          size: 20,
                        ),

                        label: const Text(
                          'Restart',

                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              accentColor,

                          foregroundColor:
                              Colors.white,

                          elevation: 0,

                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 15,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
