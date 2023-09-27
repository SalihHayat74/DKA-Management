import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class FirestoreService{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future insertPatient(String regNo, String name, String age,String weight,String gender, String admittedby,String userId)async{
    try{
      CollectionReference users = firestore.collection('patient');
      DateTime now= DateTime.now();
      String formattedTime = DateFormat('dd-MM-yyyy H:m').format(now);
     // await firestore.collection('patient').add({
      await users.doc(regNo).set({
        'name': name.toString(),
        'age': age.toString(),
        'weight': weight.toString(),
        'gender': gender.toString(),
        'admittedby': admittedby.toString(),
        'regno': regNo.toString(),
        "date": formattedTime,
        "userId": userId

      });
    }catch(e){
      //print(e);
    }
  }

  Future DischargePatient(
      String regNo,
      String ? name,
      String ? age,
      String weight,
      String ? gender,
      String ? admittedby,
      String ? userId
      )async{
    try{
      CollectionReference users = firestore.collection('DischargedPatients');
      DateTime now= DateTime.now();
      String formattedTime = DateFormat('dd-MM-yyyy H:m').format(now);
      // await firestore.collection('patient').add({
      await users.doc(regNo).set({
        'name': name.toString(),
        'age': age.toString(),
        'weight': weight.toString(),
        'gender': gender.toString(),
        'admittedby': admittedby.toString(),
        'regno': regNo.toString(),
        "date": formattedTime,
        "userId": userId

      });
    }catch(e){
      //print(e);
    }
  }

  Future InsertInvestigations(
      String rbs,
      String serumketone,
      String ph,
      String sodium,
      String potassium,
      String chlorine,
      String carbondioxide,
      String bicarbonate,
      String urineOutput,
      String ? regNo)async{

    CollectionReference invId  = firestore.collection('investigations');
    DateTime now= DateTime.now();
    String formattedTime = DateFormat('yyyy-dd-MM HH:mm:ss').format(now);
    await invId.add({
      'RBS' : rbs,
      'Serum Ketone' : serumketone,
      'PH': ph,
      'Na+': sodium,
      'K+': potassium,
      'Cl-': chlorine,
      'PCO2': carbondioxide,
      'HCO3': bicarbonate,
      'Urine Output': urineOutput,
      //'AG': anionGap,
      'PatientId': regNo,
      'Time': formattedTime

    });
  }


  Future deletePatient(String docId)async{
    try{
      await firestore.collection('patient').doc(docId).delete();
    }catch(e){
      print(e);
    }
  }


}