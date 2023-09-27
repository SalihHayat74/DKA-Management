import 'package:flutter/services.dart';

// Import tflite_flutter
import 'package:tflite_flutter/tflite_flutter.dart';

class Classifier {
  // name of the model file
  final _modelFile = 'saved_model.tflite';
  final _vocabFile = 'labels.txt';

  // TensorFlow Lite Interpreter object
  late Interpreter _interpreter;

  Classifier() {
    // Load model when the classifier is initialized.
    _loadModel();
  }

  void _loadModel() async {
    // Creating the interpreter using Interpreter.fromAsset
    _interpreter = await Interpreter.fromAsset(_modelFile);
    print('Interpreter loaded successfully');

    _interpreter.allocateTensors();
// Print list of input tensors
    print(_interpreter.getInputTensors());
// Print list of output tensors
    print(_interpreter.getOutputTensors());


  }

  List<double> classify(double pH,double pCO2,double hCo3) {



    var ph = [pH];
    var co2 = [pCO2];
    var bicarbonate = [hCo3];
    var input = [ph,co2,bicarbonate];

    print("I am going to output");

    // output of shape [1,4].
    // var output0 = List<double>.filled(4, 0).reshape([1,4]);
    // var output1 = List<double>.filled(4, 1).reshape([1,4]);
    // var output2 = List<double>.filled(4, 2).reshape([1,4]);
    // var output3 = List<double>.filled(4, 3).reshape([1,4]);
    // var output = {0: output0,1: output1, 2: output2, 3: output3};//{0: output0};

    var output = List<double>.filled(4, 0).reshape([1, 4]);


    print("I am after output");
    _interpreter.run(input, output);

    print("I am after interpretor");
    // print outputs
    print([output[0][0], output[0][1], output[0][2], output[0][3]]);
    return [output[0][0], output[0][1], output[0][2], output[0][3]];



  }

}