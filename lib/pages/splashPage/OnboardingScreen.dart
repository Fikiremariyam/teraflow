import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedLanguage = 'English';

  final List<Map<String, String>> _pages = [
    {
      'title': 'Track and Monitor Your Health',
      'description':
          'Track your period, monitor pregnancy, and receive medication reminders for informed decisions with accurate data.',
      'illustration': 'lib/images/undraw_modern-design_yur1.svg',
    },
    {
      'title': 'Access to Health Information',
      'description':
          'Confidentially access a library of health videos, blogs, and audio to help you make informed decisions about your well-being',
      'illustration': 'lib/images/undraw_uploading_nu4x.svg',
    },
    {
      'title': 'Access to Health Information',
      'description':
          'Confidentially access a library of health videos, blogs, and audio to help you make informed decisions about your well-being',
      'illustration': 'lib/images/boardingscreen1.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  DropdownButton<String>(
                    value: _selectedLanguage,
                    items: ['English', 'አማርኛ']
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(value),
                                  if (value == _selectedLanguage)
                                    const SizedBox(width: 4),
                                  if (value == _selectedLanguage)
                                    const Icon(Icons.check,
                                        color: Colors.deepPurple),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() => _selectedLanguage = newValue);
                      }
                    },
                    underline: Container(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() => _currentPage = page);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: SvgPicture.asset(
                            _pages[index]['illustration']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(32.0),
                        decoration: const BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _pages[index]['title']!,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _pages[index]['description']!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: List.generate(
                                    _pages.length,
                                    (i) => Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: i == _currentPage
                                            ? Colors.white
                                            : Colors.white38,
                                      ),
                                    ),
                                  ),
                                ),
                                FloatingActionButton(
                                  onPressed: () {
                                    if (_currentPage < _pages.length - 1) {
                                      _pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    } else {
                                      Navigator.pushReplacementNamed(
                                          context, '/welcome');
                                    }
                                  },
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
