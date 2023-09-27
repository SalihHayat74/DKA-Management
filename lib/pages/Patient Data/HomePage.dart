import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:management_of_dka_abgs/pages/Authentication%20Pages/Login_Screen.dart';
import 'package:management_of_dka_abgs/pages/Patient%20Data/add_patient.dart';
import 'package:management_of_dka_abgs/pages/Discharge%20Patient%20Components/dischargePatient.dart';
import 'package:management_of_dka_abgs/pages/Patient%20Data/each_patient_details.dart';
import 'package:flutter/material.dart';
import 'package:management_of_dka_abgs/services/auth_services.dart';



class HomePage extends StatelessWidget {
  User user;
  HomePage(this.user);

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
          title: Text("DKA MANAGMENT",style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),),
          actions: [
            TextButton.icon(onPressed: () async {
              AuthService().signout();
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
            },
              icon: Icon(Icons.logout_rounded),
              label: Text("Log out"),
              style: TextButton.styleFrom(
                  primary: Colors.white
              ),)
          ],
        ),
         drawer: Drawer(
           child: ListView(
             // Important: Remove any padding from the ListView.
             padding: EdgeInsets.zero,
             children: [
               const DrawerHeader(
                 decoration: BoxDecoration(
                   color: Colors.blue,
                 ),
                 child: Text(''),
               ),
               ListTile(
                 title: const Text('View Discharged Patients'),
                 onTap: () {

                   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DischargedPatients(user: user,)));
                 },
               ),
             ],
           ),
         ),
         body: StreamBuilder<QuerySnapshot>(
           stream: FirebaseFirestore.instance.collection('patient').orderBy('regno',descending: true).snapshots(),
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
                         (context)=>EachPatientDetails(id: id,name: name,age: age,weight: weight,gender: gender,admittedby: admittedby,regNo: regno,date: time,user: user,)));
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
