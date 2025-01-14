import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/widgets/navigation_menu.dart';
import 'package:flutter/material.dart';


class OnboardingItem {
  final String image;
  final String title;
  final String description;

  const OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: GlobalVariables.onboardAssets.length, vsync: this);
    _controller.addListener(() {
      setState(() {
        _currentIndex = _controller.index;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _done() async {
    // Add your caching logic or navigation here
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NavigationMenu()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.cardColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _done,
              child: const Text("SKIP"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: scheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (_controller.index <
                    GlobalVariables.onboardAssets.length - 1) {
                  _controller.animateTo(_controller.index + 1);
                } else {
                  _done();
                }
              },
              child: Text(
                _currentIndex == GlobalVariables.onboardAssets.length - 1
                    ? "DONE"
                    : "NEXT",
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Material(
        color: theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              GlobalVariables.onboardAssets.length,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: _currentIndex == i
                        ? scheme.tertiary
                        : scheme.tertiaryContainer,
                  ),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    child: SizedBox(
                      height: 10,
                      width: _currentIndex == i ? 32 : 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: GlobalVariables.onboardAssets
            .map(
              (item) => Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Expanded(
                      flex: 32,
                      child: Image.asset(item.image),
                    ),
                    Text(
                      item.title,
                      style: style.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Text(
                      item.description,
                      style: style.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(flex: 4),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
