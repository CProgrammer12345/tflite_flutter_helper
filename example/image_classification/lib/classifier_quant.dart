import 'package:imageclassification/classifier.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'localdb.dart';

class ClassifierQuant extends Classifier {
  ClassifierQuant({int numThreads: 1}) : super(numThreads: numThreads);

  @override
  String get modelName => LocalDB.modelName;

  @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(0, 1);

  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 255);
}
