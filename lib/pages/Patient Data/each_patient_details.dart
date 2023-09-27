import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:management_of_dka_abgs/pages/Patient%20Data/investigationTable.dart';
import 'package:management_of_dka_abgs/pages/treatmentPages/treatmentScreen.dart';
import '../../Constant/constant.dart';
import '../../services/firestore_services.dart';
import 'add_investigations.dart';
import 'package:management_of_dka_abgs/pages/Patient%20Data/viewCharts.dart';

class EachPatientDetails extends StatelessWidget {

  final String ? id;
  final String ? name;
  final String ? age;
  final String weight;
  final String ? gender;
  final String ? admittedby;
  final String regNo;
  final String ? date;
   User user;


  EachPatientDetails({
  required this.id,
  required this.name,
  required this.age,
  required this.weight,
  required this.gender,
  required this.admittedby,
  required this.regNo,
  required this.date,
  required this.user,
  });

  



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

      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Patient Details",
          style: ktextField,
        ),
        actions: [
          TextButton.icon(onPressed: () async {
            await showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text("Please Confirm"),
                    content: Text("Are you sure to Discharge Patient"),
                    actions: [
                      TextButton(
                          onPressed: ()async{
                            await FirestoreService().DischargePatient(regNo, name, age, weight, gender, admittedby, id);
                             FirestoreService().deletePatient(regNo);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text("Yes")),
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          }, child: Text("No"))
                    ],
                  );
                });


            
            //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
          },
            icon: Icon(Icons.person_remove),
            label: Text("Discharge"),
            style: TextButton.styleFrom(
                primary: Colors.white
            ),)
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('patient').where('userId',isEqualTo: user.uid).snapshots(),
    builder: (BuildContext context,AsyncSnapshot <QuerySnapshot> snapshot){
    if(snapshot.hasError){
    return Text('Something Went wrong');
    }
    if(snapshot.connectionState == ConnectionState.waiting) {
    return Center(
    child: CircularProgressIndicator(),
    );
    }


    final List storedocs = [];
    snapshot.data!.docs.map((DocumentSnapshot document){
    Map<String, dynamic> eachInvistigation = document.data() as Map<String, dynamic>;
    storedocs.add(eachInvistigation);
    }).toList();
    return
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height*.87,
          //width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            // image: DecorationImage(
            //             //     image: AssetImage("images/3.png"),
            //             //     fit: BoxFit.cover,
            //             //     opacity: 450
            //             // )
          ),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Container(
                height: 150,
                //width: 700,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                                  image: AssetImage("images/doctor-animate.gif"),
                      //image: AssetImage("images/dr_inj.gif"),

                      //fit: BoxFit.fitWidth,
                                  opacity: 800
                              )
                ),
              ),
              SizedBox(height: 10,),

              Divider(
                color: Color(0xFF555FD2),
                indent: 50,
                endIndent: 50,
              ),
              Container(
                width: 150,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.8),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Text("Patient Details",
                  style:TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ) ,),
              ),
              Container(
                width: 350,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.8),
                  border: Border.all(
                    color: Colors.deepPurple,
                    width: 1,
                    style: BorderStyle.solid
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Text("Name : ${name}",
                            textAlign: TextAlign.center,
                            style: ktextField,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text("Age : ${age}",
                            textAlign: TextAlign.center,
                            style: ktextField,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text("Reg No:${id}",
                            textAlign: TextAlign.center,
                            style: ktextField,
                          ),
                        )
                      ],

                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Text("Gender :${gender}",
                            textAlign: TextAlign.center,
                            style: ktextField,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Text("Date: ${date}",
                            textAlign: TextAlign.center,
                            style: ktextField,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Text("Weight: ${weight}",
                            textAlign: TextAlign.center,
                            style: ktextField,
                          ),
                        ),

                      ],

                    ),
                  ],
                ),
              ),
              
              Divider(
                color: Color(0xFF555FD2),
                indent: 50,
                endIndent: 50,
              ),
              
              SizedBox(
                height: 20,
              ),

              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color:Color(0xFF555FD2),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddInvestigation(regNo: regNo, weight: weight,)));
                          },
                          child: Column(
                            children: [
                              Icon(Icons.add_box,
                                size: 50,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Add \n Investigations",
                                  style: TextStyle(color: Colors.white,),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color:Color(0xFF555FD2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(

                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Investigations(regNo: regNo,)));


                          },
                          child: Column(
                            children: [
                              Icon(Icons.analytics_outlined,
                                size: 50,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("View Table",
                                  style: TextStyle(color: Colors.white,),
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color:Color(0xFF555FD2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>viewGraphs(regNo: regNo,)));
                          },
                          child: Column(
                            children: [
                              Icon(Icons.table_chart,
                                color: Colors.white,
                                size: 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("View Graphs",
                                  style: TextStyle(color: Colors.white,),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color:Color(0xFF555FD2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () {
                            // setState(() {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ManagmentTable(regNo: regNo,weight: weight,)));
                            //     return ViewPatient();
                            //   }));
                            // });
                          },
                          child: Column(
                            children: [
                              Icon(Icons.batch_prediction,
                                size: 50,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("View\nTreatment",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      );
    })
    )]);
  }
}
