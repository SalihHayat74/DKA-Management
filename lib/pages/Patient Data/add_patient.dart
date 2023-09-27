import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:management_of_dka_abgs/pages/Components/AddPatientComponent.dart';
import 'package:flutter/material.dart';
import 'package:management_of_dka_abgs/services/firestore_services.dart';

class AddPatient extends StatefulWidget {
  User user ;
  AddPatient(this.user);

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {

  TextEditingController reg_no = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController admitted_by = TextEditingController();
  bool loading = false;



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color(0xFFE6EFF9),
      appBar: AppBar(
        backgroundColor: Color(0xFF555FD2),
        title: Text(
          "REGISTER PATIENT",
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/2.png"),
                  fit: BoxFit.cover,
                  opacity: 490)),
          child: Column(
            children: [
              SizedBox(height: 20,),
              TextField(
                controller: reg_no,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Reg No",
                    hintText: "Registration Number",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none
                    )),
              ),
              SizedBox(height: 20,),

              TextField(
                controller: name,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Name",
                    hintText: "Enter name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none
                    )),
              ),
              SizedBox(height: 20,),


              TextField(
                controller: age,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Age",
                    hintText: "Age of Patient",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none
                    )),
              ),
              SizedBox(height: 20,),

              TextField(
                controller: weight,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Weight",
                    hintText: "Weight in Kilograms",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none
                    )),
              ),

              SizedBox(height: 20,),

              TextField(
                controller: gender,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Gender",
                    hintText: "F for Female and M for Male",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child:
                  loading ? Center(child: CircularProgressIndicator(),): Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF555FD2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 50,
                    width: 300,
                    child: TextButton(
                      onPressed: () async{
                        if( name.text == "" || age.text =="" || gender.text =="" || reg_no.text=="" || weight=="") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("All Fields are required!!")),);
                        }else {
                          setState(() {
                            loading = true;
                          });
                          await FirestoreService().insertPatient(
                              reg_no.text,
                              name.text,
                              age.text,
                              weight.text,
                              gender.text,
                              admitted_by.text,
                              widget.user.uid);

                          setState(() {
                            loading = false;
                          });
                          Navigator.pop(context);
                        }

                        /*setState(() {

                          Navigator.push(context, MaterialPageRoute(builder: (_)
                          {
                            return HomePage();
                          }));
                        });*/
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
