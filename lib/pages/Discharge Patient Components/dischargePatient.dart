import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:management_of_dka_abgs/pages/Discharge%20Patient%20Components/viewDischargePatientDetails.dart';
import 'package:management_of_dka_abgs/pages/Patient%20Data/add_patient.dart';
import 'package:flutter/material.dart';




class DischargedPatients extends StatelessWidget {

  User user;
  DischargedPatients({required this.user});


  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage('images/medSigns2.jpeg'),
                    opacity: 0.2,
                    fit: BoxFit.cover
                )
            ),
          ),
          Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white.withOpacity(0.9),

            appBar: AppBar(
              backgroundColor: Colors.blueAccent.withOpacity(0.8),
              elevation: 0,
              title: Text("Discharged Patients",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),),

            ),

            body: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('DischargedPatients').orderBy('regno',descending: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasError){
                    return Text("OOOOoooops!! Something went Wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      final String ? name= data['name'];
                      final String ? age= data['age'];
                      final String weight= data['weight'];
                      final String ? gender = data['gender'];
                      final String ? admittedby = data['admittedby'];
                      final String regno = data['regno'];
                      final String ? id = document.id;
                      final String ? time = data['date'];
                      return Card(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                          child: ListTile(

                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                            title: Text("Name:  ${name}     Patient Id: ${id}",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            subtitle: Text("RegNo: ${regno}                   Date:${time}",overflow: TextOverflow.ellipsis,maxLines: 2,),
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder:
                                  (context)=>DischargePatientDetails(id: id,name: name,age: age,weight: weight,gender: gender,admittedby: admittedby,regNo: regno,date: time,user: user,)));
                            },
                          ));
                    }).toList(),
                  );
                }

            ),



            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.teal,
              child: Icon(Icons.person_add_alt),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddPatient(user)));
              },
            ),

          )
        ]);
  }
}
