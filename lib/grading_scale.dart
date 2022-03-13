import 'package:flapp/interval.dart';
import 'package:tuple/tuple.dart';

class GradingScale {
  final List<Interval> _scale;
  final String name;

  GradingScale({required List<Interval> scale})
      : _scale = scale,
        name = "Custom";

  GradingScale.collegeBoard()
      : _scale = [
          Interval("A+", 96.5, 100),
          Interval("A", 92.5, 96.5),
          Interval("A-", 89.5, 92.5),
          Interval("B+", 86.5, 89.5),
          Interval("B", 82.5, 86.5),
          Interval("B-", 79.5, 82.5),
          Interval("C+", 76.5, 79.5),
          Interval("C", 72.5, 76.5),
          Interval("C-", 69.5, 72.5),
          Interval("D+", 66.5, 69.5),
          Interval("D", 64.5, 66.5),
          Interval("F", 0, 64.5),
        ],
        name = "College Board";

  List<Interval> get scale => _scale;
}
