import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:german_quiz_app/pages/HomePage.dart';
import 'package:german_quiz_app/simple_provider.dart';

class Completed extends ConsumerWidget {
  const Completed({super.key});

  String _gradeLabel(double percent) {
    if (percent >= 90 && percent <= 100) return 'excellent';
    if (percent >= 80 && percent < 90)   return 'goot';
    if (percent >= 65 && percent < 80)   return 'satisfactory';
    if (percent >= 50 && percent < 65)   return 'pass';
    return 'unsatisfactory';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trueScore  = ref.watch(trueProvider);   // doğru sayısı
    final falseScore = ref.watch(falseProvider);  // yanlış sayısı

    final totalAnswered = (trueScore + falseScore).toDouble();

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    if (totalAnswered == 0) {
      return const Scaffold(
        body: Center(child: Text('There is no graphic')),
      );
    }

    final percent = (trueScore / totalAnswered) * 100.0;
    final label   = _gradeLabel(percent);

    final data = <_Slice>[
      _Slice('True',  trueScore.toDouble(),  Colors.blue),
      _Slice('False', falseScore.toDouble(), Colors.red),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results', style: TextStyle(fontFamily: 'RobotoSlab', fontWeight: FontWeight.bold,),),
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> HomePage()), (Route<dynamic> route) => false);
          },
          child: Icon(Icons.arrow_back_ios,)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // Üstte özet + not etiketi
              Card(
                child: ListTile(
                  title: Text('All: ${totalAnswered.toInt()} questions'),
                  subtitle: Text('✅ True: $trueScore   ❌ False: $falseScore'),
                  trailing: Text(
                    '${percent.toStringAsFixed(0)}% • $label',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
          
              // Pasta grafik
              AspectRatio(
                aspectRatio: 1.3,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                    sections: data.map((d) {
                      final pct = (d.value / totalAnswered) * 100.0;
                      return PieChartSectionData(
                        color: d.color,
                        value: d.value,
                        title: '${pct.isNaN ? 0 : pct.toStringAsFixed(0)}%',
                        radius: 70,
                        titleStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
          
              // Lejant
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: data.map((d) {
                  final pct = (d.value / totalAnswered) * 100.0;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 12, height: 12,
                        decoration: BoxDecoration(color: d.color, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text('${d.label} • ${pct.isNaN ? 0 : pct.toStringAsFixed(0)}%'),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: height*0.07,),
              Text("Requirements:", style: TextStyle(fontFamily: 'RobotoSlab',fontSize: width*0.055, color: Colors.black, fontWeight: FontWeight.w600),),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5.0,),
                  Text("*  Below 60%: fail, unsatisfactory (1)", style: TextStyle(fontSize: width*0.04), textAlign: TextAlign.start,),
                  Text("*  from 60%: pass (2)", ),
                  Text("*  from 70%: satisfactory, acceptable (3)"),
                  Text("*  from 80%: good (4)"),
                  Text("*  from 90%: excellent, very good (5)"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Slice {
  final String label;
  final double value;
  final Color color;
  _Slice(this.label, this.value, this.color);
}
