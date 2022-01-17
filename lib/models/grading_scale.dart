import 'package:tuple/tuple.dart';

class GradingScale {
  final List<Tuple2<String, double>> _scale;

  GradingScale({required List<Tuple2<String, double>> scale}) : _scale = scale;

  GradingScale.collegeBoard()
      : _scale = const [
          Tuple2("A+", 97),
          Tuple2("A", 93),
          Tuple2("A-", 90),
          Tuple2("B+", 87),
          Tuple2("B", 83),
          Tuple2("B-", 80),
          Tuple2("C+", 77),
          Tuple2("C", 73),
          Tuple2("C-", 70),
          Tuple2("D+", 67),
          Tuple2("D", 65),
          Tuple2("F", 0),
        ];

  List<Tuple2<String, double>> get scale => _scale;

  void update(int index, String label, double weight) {
    _scale[index] = Tuple2(label, weight);
  }

  void remove(int index) {
    _scale.removeAt(index);
  }
}
