import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:german_quiz_app/simple_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Main extends ConsumerStatefulWidget {
  const Main({super.key});

  @override
  ConsumerState<Main> createState() => _MainState();
}

class _MainState extends ConsumerState<Main> {
  final images = [
    "assets/images/panel1.webp",
    "assets/images/panel2.webp",
    "assets/images/panel3.jpg",
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
    var width = MediaQuery.of(context).size.width;
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("200 questions", style: TextStyle( fontFamily: 'RobotoSlab', fontSize: width*0.045, color: Colors.deepPurple),textAlign: TextAlign.center),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple
                ),
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
              onPressed: () async {
                final Uri url = Uri.parse("https://langoracademy.com/");

                try {
                  // 1) Dış tarayıcıyı dene
                  final opened = await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );

                  if (!opened) {
                    // 2) Olmazsa uygulama içi webview dene
                    final inApp = await launchUrl(
                      url,
                      mode: LaunchMode.inAppWebView,
                      webViewConfiguration: const WebViewConfiguration(
                        enableJavaScript: true,
                      ),
                    );

                    if (!inApp) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Bağlantı açılamadı.")),
                        );
                      }
                    }
                  }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Hata: $e")),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Learn German",
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
              onPressed: () async {
                final Uri url = Uri.parse("https://langoracademy.com/");

                try {
                  // 1) Dış tarayıcıyı dene
                  final opened = await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );

                  if (!opened) {
                    // 2) Olmazsa uygulama içi webview dene
                    final inApp = await launchUrl(
                      url,
                      mode: LaunchMode.inAppWebView,
                      webViewConfiguration: const WebViewConfiguration(
                        enableJavaScript: true,
                      ),
                    );

                    if (!inApp) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Bağlantı açılamadı.")),
                        );
                      }
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Hata: $e")),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Download Books",
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
              ),
            )
            ],
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("🟢 Multiple categories (Vocabulary, Grammar, etc.)"),
                Text("🟢 Score tracking with statistics)"),
                Text("🟢 Works offline"),
              ],
            ),
          ),
          SizedBox(height: 10,),
          ConstrainedBox(constraints: BoxConstraints(maxWidth: 720),
          child: const FAQSection(
              title: 'Frequently Asked Questions',
              items: [
                FAQItem(
                  question: 'Who is this app for?',
                  answer:
                      'It’s designed for anyone learning German for beginners (A1)',
                ),
                FAQItem(
                  question: 'Do I need an internet connection?',
                  answer:
                      'Not really 🙂 Most quizzes work offline. Internet is only required for updates.',
                ),
                FAQItem(
                  question: 'How often are new quizzes added?',
                  answer:
                      'We plan to update the app regularly with new questions and categories.',
                ),
                FAQItem(
                  question: 'Is the app free?',
                  answer:
                      'Yes! The app is completely free right now. Premium features may be added later.'
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