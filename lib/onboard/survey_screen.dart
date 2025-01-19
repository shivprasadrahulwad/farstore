import 'package:farstore/onboard/wait_popup.dart';
import 'package:flutter/material.dart';

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int _currentQuestionIndex = 0;
  double _progress = 0.0;
  List<int> _selectedOptions = [];
  bool _canGoBack = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': "Let's get started. Which of these best describes you?",
      'description': "We'll help you get set up based on your business needs.",
      'type': 'single', // single or multiple
      'options': [
        {'text': "I'am just starting",},
        {
          'text': "I'am already selling online or in person",
        },

      ],
    },
    {
      'question': 'Where you would like to sell?',
      'description':
          "Pick as any as you like - we will make sure you're set up to sell in these places.",
      'type': 'multiple',
      'options': [
        {
          'text': 'An online store',
          'description': 'Create a fully customizable store.',
          'icon': Icons.apple
        },
        {
          'text': 'In person',
          'description': 'sell at retail stores or other physical locations.'
        },
        {
          'text': 'Socail media',
          'description': 'Reach customers on Facebook, instagram, and more.'
        },
        {
          'text': "I'am not sure",
        }
      ],
    },
    {
      'question': 'What do you plan to sell first?',
      'description':
          "Pick what you want to start with. We'll help you stock your store.",
      'type': 'multiple',
      'options': [
        {
          'text': 'Products I buy or make myself',
          'description': 'Shipped by me.',
          'icon': Icons.apple
        },
        {
          'text': 'Dropshipping products',
          'description': 'Sourced and shipped by a third party.'
        },
        {
          'text': 'Print-on-demand products',
          'description': 'My designs, printed and shipped by a third party.'
        },
        {
          'text': 'Digital products',
          'description': 'Music, digital art, etc.',
          'icon': Icons.apple
        },
        {
          'text': 'Services',
          'description': 'Coaching, housekeeping, consulting.',
          'icon': Icons.apple
        },
        {
          'text': "I'will decide later",
        }
      ],
    },
  ];

  void _updateProgress() {
    // Start at 10% for first question, leave 10% at the end
    _progress = 0.1 + ((_currentQuestionIndex / (_questions.length - 1)) * 0.8);
  }

void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _updateProgress();
        _selectedOptions.clear(); // Reset selections for the next question
        _canGoBack = true;
      } else {
        // When on the last question and Next is pressed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return WaitPopup(
              onClose: () {
                Navigator.of(context).pop(); // Close the popup
                // Add navigation logic here to go to the next screen
              },
            );
          },
        );
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
        _updateProgress();
        _selectedOptions.clear();
        _canGoBack = _currentQuestionIndex > 0;
      }
    });
  }

  void _skipQuestion() {
    _nextQuestion();
  }

  void _skipAll() {
    setState(() {
      _currentQuestionIndex = _questions.length - 1;
      _updateProgress();
      _selectedOptions.clear();
      _canGoBack = true;
    });
  }

  void _selectOption(int index, bool isMultipleChoice) {
    setState(() {
      if (isMultipleChoice) {
        if (_selectedOptions.contains(index)) {
          _selectedOptions.remove(index);
        } else {
          _selectedOptions.add(index);
        }
      } else {
        _selectedOptions = [index];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _updateProgress(); // Set initial progress
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final isMultipleChoice = currentQuestion['type'] == 'multiple';

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Text('Back',
                    style: TextStyle(
                        fontSize: 18,
                        color: _canGoBack ? Colors.black : Colors.grey)),
              ],
            ),

            // Title
            const Text(
              'ShopEz',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey[300],
                color: Colors.green,
                minHeight: 7,
              ),
            ),
            const SizedBox(height: 32),

            // Question
            Text(
              currentQuestion['question'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            if (currentQuestion['description'] != null) ...[
              const SizedBox(height: 8),
              Text(
                currentQuestion['description'],
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 16),

            // Options
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion['options'].length,
                itemBuilder: (context, index) {
                  final option = currentQuestion['options'][index];
                  final isSelected = _selectedOptions.contains(index);

                  return GestureDetector(
                    onTap: () {
                      _selectOption(index, isMultipleChoice);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected ? Colors.green : Colors.black,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (isMultipleChoice)
                                GestureDetector(
                                  onTap: () {
                                    _selectOption(index, isMultipleChoice);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.green
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.green
                                              : Colors.grey,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      width: 20,
                                      height: 20,
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              size: 18,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                  ),
                                )
                              else
                                Radio(
                                  value: index,
                                  groupValue: _selectedOptions.isEmpty
                                      ? null
                                      : _selectedOptions.first,
                                  onChanged: (value) {
                                    _selectOption(index, isMultipleChoice);
                                  },
                                  activeColor: Colors.green,
                                ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option['text'],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    if (option['description'] != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          option['description'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (option['icon'] != null) const Spacer(),
                              if (option['icon'] != null)
                                Icon(
                                  option['icon'],
                                  color:
                                      isSelected ? Colors.green : Colors.black,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Next and Skip buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (_canGoBack)
                  GestureDetector(
                    onTap: _canGoBack ? _previousQuestion : null,
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                        ),
                        Text('Back', style: TextStyle(color: Colors.black))
                      ],
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: _skipAll,
                  child: const Text(
                    'Skip All',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: _skipQuestion,
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectedOptions.isNotEmpty ? _nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedOptions.isNotEmpty
                        ? Colors.green
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Next'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
