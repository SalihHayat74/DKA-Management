import 'package:cloud_firestore/cloud_firestore.dart';

class InvestigationModel {
  final String rbs;
  final String serumketone;
  final String ph;
  final String sodium;
  final String potassium;
  final String chlorine;
  final String carbondioxide;
  final String bicarbonate;


  InvestigationModel({
    required this.rbs,
    required this.serumketone,
    required this.ph,
    required this.sodium,
    required this.potassium,
    required this.chlorine,
    required this.carbondioxide,
    required this.bicarbonate,
  });

  factory InvestigationModel.fromJson(DocumentSnapshot snapshot) {
    return InvestigationModel(
        rbs: snapshot['rbs'],
        serumketone: snapshot['serumketone'],
        ph: snapshot['ph'],
        sodium: snapshot['sodium'],
        potassium: snapshot['potassium'],
        chlorine: snapshot['chlorine'],
        carbondioxide: snapshot['carbondioxide'],
        bicarbonate: snapshot['bicarbonate']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (rbs != null) "rbs": rbs,
      if (serumketone != null) "serumketone": serumketone,
      if (ph != null) "ph": ph,
      if (sodium != null) "sodium": sodium,
      if (potassium != null) "potassium": potassium,
      if (chlorine != null) "chlorine": chlorine,
      if (carbondioxide != null) "carbondioxide": carbondioxide,
      if (bicarbonate != null) "bicarbonate": bicarbonate,
    };
  }
}