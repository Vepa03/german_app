import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:german_quiz_app/simple_provider.dart';

class Main extends ConsumerStatefulWidget {
  const Main({super.key});

  @override
  ConsumerState<Main> createState() => _MainState();
}

class _MainState extends ConsumerState<Main> {
  final images = [
    "assets/images/bg2.jpg",
    "assets/images/bg3.jpg",
    "assets/images/bg2.jpg",
    "assets/images/bg2.jpg",
    "assets/images/bg2.jpg"
  ];

  int _index = 0;

  late final PageController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  void _prev() {
    if (_index > 0){
      _controller.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  void _next() {
    if (_index < images.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scoreShow = ref.watch(trueProvider);
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AspectRatio(aspectRatio: 16/9,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: images.length,
                    onPageChanged: (i) => setState(() {
                      _index = i;
                    }),
                    itemBuilder: (_,i) => Image.asset(
                      images[i], fit: BoxFit.cover,
                    )
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 0, bottom: 0,
                  child: _CircleButton_left(
                    icon: Icons.chevron_left,
                    onTap: _prev,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 0, bottom: 0,
                  child: _CircleButton_right(
                    icon: Icons.chevron_right,
                    onTap: _next,
                  ),
                ),
                
              ],
            ),),
          ),
          ConstrainedBox(constraints: BoxConstraints(maxWidth: 720),
          child: const FAQSection(
              title: 'Frequently Asked Questions',
              items: [
                FAQItem(
                  question: 'Where and how are the lessons held?',
                  answer:
                      'Lessons are held online via Zoom/Google Meet. After registration, you will receive a link and your weekly schedule.',
                ),
                FAQItem(
                  question: 'What should I do to register?',
                  answer:
                      'Fill out the registration form and our team will contact you within the same day to confirm your level and schedule.',
                ),
                FAQItem(
                  question: 'Is there a trial lesson?',
                  answer:
                      'Yes. You can take one free trial lesson to see the format and ask questions before you decide.',
                ),
                FAQItem(
                  question: 'Which levels do you offer courses for?',
                  answer:
                      'We currently offer A1–C1 levels. Groups are formed by level to keep progress consistent.',
                ),
              ],
            ),
          ),
        ],
      ),
      
    );
  }
}

class FAQSection extends StatelessWidget {
  final String title;
  final List<FAQItem> items;

  const FAQSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pink "FAQ" pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 194, 176, 241),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'FAQ',
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w700,
                letterSpacing: .3,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 18),
      
          // List
          Theme(
            data: theme.copyWith(
              dividerColor: Colors.transparent,
              expansionTileTheme: ExpansionTileThemeData(
                // clean look like the screenshot
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(top: 8, bottom: 8),
                iconColor: Colors.black87,
                collapsedIconColor: Colors.black54,
                textColor: Colors.black87,
                collapsedTextColor: Colors.black87,
              ),
            ),
            child: Column(
              children: List.generate(items.length, (i) {
                final item = items[i];
                return Column(
                  children: [
                    ExpansionTile(
                      // Default trailing is ▼ and rotates automatically.
                      title: Text(
                        item.question,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.answer,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.4,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // subtle divider between rows
                    Container(
                      height: 1,
                      color: Colors.black12.withOpacity(0.08),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  const FAQItem({required this.question, required this.answer});
}


class _CircleButton_right extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton_right({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.35),
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 38, height: 38,
          child: Center(
            child: Icon(Icons.chevron_right, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
class _CircleButton_left extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton_left({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.35),
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 38, height: 38,
          child: Center(
            child: Icon(Icons.chevron_left, color: Colors.white),
          ),
        ),
      ),
    );
  }
}