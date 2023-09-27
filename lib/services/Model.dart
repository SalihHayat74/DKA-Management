 import 'package:cloud_firestore/cloud_firestore.dart';

 class PatientModel {
   final String id;
   final String name;
   final String age;
   final String gender;
   final String admittedby;
   final String regNo;
   final String date;
   final String userId;


   PatientModel({
     required this.id,
     required this.name,
     required this.age,
     required this.gender,
     required this.admittedby,
     required this.regNo,
     required this.date,
     required this.userId,
   });

   factory PatientModel.fromJson(DocumentSnapshot snapshot) {
     return PatientModel(
         id: snapshot['id'],
         regNo: snapshot['regNo'],
         name: snapshot['name'],
         age: snapshot['age'],
         gender: snapshot['gender'],
         admittedby: snapshot['admittedby'],
         date: snapshot['date'],
         userId: snapshot['userId']
     );
   }

   Map<String, dynamic> toFirestore() {
     return {
       if (name != null) "name": name,
       if (age != null) "age": age,
       if (gender != null) "gender": gender,
       if (admittedby != null) "admittedby": admittedby,
       if (regNo != null) "regNo": regNo,
       if (id  != null) "id": id,
     };
   }
 }

