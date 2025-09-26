import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:german_quiz_app/model/quiz_questions.dart';
import 'package:german_quiz_app/pages/Completed.dart';
import 'package:german_quiz_app/selected_provider.dart';
import 'package:german_quiz_app/simple_provider.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var width = MediaQuery.of(context).size.width;
    final asyncCats = ref.watch(categoriesProvider);

    return Scaffold(
      body: asyncCats.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Hata: $e')),
        data: (cats) {
          if (cats.isEmpty) return const Center(child: Text('Kategori yok'));
          return ListView.builder(
            itemCount: cats.length,
            itemBuilder: (context, index) {
              final c = cats[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 166, 136, 250)
                  ),
                  child: ListTile(
                    title: Text(c.category, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width*0.045),),
                    subtitle: Text('Number of questions: ${c.questions.length}', style: TextStyle(fontFamily: 'NotoSans',color: Colors.white)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.white,),
                    onTap: () {
                    // QUIZ state reset (providerlara burada yazmak güvenli)
                    ref.read(trueProvider.notifier).state = 0;
                    ref.read(falseProvider.notifier).state = 0;
                    ref.read(selectedProvider.notifier).clear(); // varsa

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuestionsPage(
                          title: c.category,
                          questions: c.questions,
                        ),
                      ),
                    );
                  },

                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
class QuestionsPage extends ConsumerStatefulWidget {
  final String title;
  final List<QuizQuestions> questions;

  const QuestionsPage({
    super.key,
    required this.title,
    required this.questions,
  });
  @override
  ConsumerState<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends ConsumerState<QuestionsPage> {
  final Map<int, String> selected = {}; // soruIndex -> seçilen şık id
  late int galan_sor;
  @override
  void initState(){
    super.initState();
    galan_sor = widget.questions.length;
    selected.clear();
  }

  @override
  Widget build(BuildContext context) {

    final questions = widget.questions;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        selected.clear();
        galan_sor = widget.questions.length;
        ref.read(trueProvider.notifier).state = 0;
        ref.read(falseProvider.notifier).state = 0;
        return true; 
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: TextStyle(fontFamily: 'RobotoSlab',color: Colors.white, fontWeight: FontWeight.bold,)),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(galan_sor.toString(), style: TextStyle(fontSize: width*0.08, color: Colors.green, fontWeight: FontWeight.bold),),
            )
          ]
      
          
        ),
        body: questions.isEmpty
            ? const Center(child: Text('Soru yok'))
            : ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final q = questions[index];
                  final selectedId = selected[index];
      
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              '${q.id}) ${q.question}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'RobotoSlab',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 3,
                            children: q.options.map((o) {
                              final isChosen = selectedId == o.id;
                              final locked = selectedId != null;
      
                              return GestureDetector(
                                onTap: locked
                                    ? null
                                    : () {
                                        final isCorrect = o.id == q.correctAnswer;
                                        setState(() {
                                          selected[index] = o.id;
                                          galan_sor--;
                                          ref.read(selectedProvider.notifier).setSelected(index, o.id);
                                        });
      
                                        final allAnswered = selected.length == questions.length;
                                        // Skoru sadece ilk seçimde güncelle
                                        if (isCorrect) {
                                          ref.read(trueProvider.notifier).state++;
                                        } else {
                                          ref.read(falseProvider.notifier).state++;
                                        }
                                        if (allAnswered){
                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> Completed()),
                                          (Route<dynamic> route)=> false);
                                        }
                                      },
                                child: Container(
                                  margin: const EdgeInsets.all(6),
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: isChosen
                                        ? (o.id == q.correctAnswer
                                            ? Colors.green
                                            : Colors.red)
                                        : Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isChosen
                                          ? Colors.black54
                                          : Colors.blueGrey.shade200,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      o.text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'AlanSans',
                                        fontSize: 15,
                                        fontWeight: isChosen
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

final categoriesProvider = FutureProvider<List<QuizCategories>>((ref) async {
  final data = await rootBundle.loadString("assets/data/sorular.json");
  final List<dynamic> jsonList = jsonDecode(data) as List<dynamic>;
  return jsonList
      .map((e) => QuizCategories.fromJson(e as Map<String, dynamic>))
      .toList();
});