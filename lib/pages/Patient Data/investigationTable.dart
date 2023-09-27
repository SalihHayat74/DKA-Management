import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:charts_flutter/flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class InvestigationsTable{
  double rbs;
  double ketone;
  double ph;
  double sodium;
  double potassium;
  double chlorine;
  double pCO2;
  double bicarbonate;
  int urineOutput;
  String time;

  InvestigationsTable(
      this.rbs,
      this.ketone,
      this.ph,
      this.sodium,
      this.potassium,
      this.chlorine,
      this.pCO2,
      this.bicarbonate,
      this.urineOutput,
      this.time,
      );

}
class Investigations extends StatelessWidget {
  String regNo;
  Investigations({required this.regNo});


  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
    Container(
    decoration: BoxDecoration(
      color: Colors.white,
    image: DecorationImage(
        image: AssetImage('images/medSigns2.jpeg'),
    opacity: .1,
    fit: BoxFit.cover
    )
    ),
    ),
    Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      appBar: AppBar(
        title: Text("Table"),

      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('investigations').where('PatientId',isEqualTo: regNo).orderBy('Time', descending: false).snapshots(),
          builder: (BuildContext context,AsyncSnapshot <QuerySnapshot> snapshot){
            if(snapshot.hasError){
              return Text('Something Went wrong');
            }

            final List storedocs = [];
            snapshot.data?.docs.map((DocumentSnapshot document){
              Map<String, dynamic> eachInv = document.data() as Map<String, dynamic>;

              String date_=eachInv['Time'];
              DateTime date=DateTime.parse(date_);
              double ketone = double.parse(eachInv['Serum Ketone']);
              double pH=double.parse(eachInv['PH']);
              double rbS=double.parse(eachInv['RBS']);
              double potassium = double.parse(eachInv['K+']);
              double cO2= double.parse(eachInv['PCO2']);
              double hCO3= double.parse(eachInv['HCO3']);
              double sodium= double.parse(eachInv['Na+']);
              double chlorine=double.parse(eachInv['Cl-']);
              int urineOutput=int.parse(eachInv['Urine Output']);

              //storedocs.add(InvestigationsTable(rbS,ketone,pH,sodium,potassium,chlorine,cO2,hCO3,urineOutput,date_));
              storedocs.add(eachInv);
            }).toList();



            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Container(
                          height: 150,
                          child: Image(
                            image: AssetImage("images/dr_inj.gif"),
                          ),
                        ),
                        SizedBox(height: 10,),

                        Divider(
                          color: Color(0xFF555FD2),
                          indent: 50,
                          endIndent: 50,
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Table(
                                border: TableBorder.all(),
                                columnWidths: const <int, TableColumnWidth>{
                                  //   0: FixedColumnWidth(30),
                                  1: FixedColumnWidth(60),
                                  //
                                },
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(
                                      children: [
                                        TableCell(
                                            child: Container(
                                              color: Colors.teal,
                                              child: Center(
                                                child: Text('RBS',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                ),
                                              ),
                                            )
                                        ),
                                        TableCell(
                                            child: Container(
                                              color: Colors.teal,
                                              child: Center(
                                                child: Text('S- Ketone',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                ),
                                              ),
                                            )
                                        ),
                                        TableCell(
                                            child: Container(
                                              color: Colors.teal,
                                              child: Center(
                                                child: Text('PH',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                ),

                                              ),
                                            )
                                        ),
                                        TableCell(
                                            child: Container(
                                              color: Colors.teal,
                                              child: Center(
                                                child: Text('Na+',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                ),
                                              ),
                                            )
                                        ),
                                        TableCell(
                                            child: Container(
                                              color: Colors.teal,
                                              child: Center(
                                                child: Text('K+',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                ),
                                              ),
                                            )
                                        ),
                                        TableCell(
                                            child: Container(
                                              color: Colors.teal,
                                              child: Center(
                                                child: Text('Cl-',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                ),
                                              ),
                                            )
                                        ),
                                        TableCell(
                                            child: Container(
                                              color: Colors.teal,
                                              child: Center(
                                                child: Text('PCO2',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                ),
                                              ),
                                            )
                                        ),
                                        TableCell(
                                            child: Container(
                                              color: Colors.teal,
                                              child: Center(
                                                child: Text('HCO3',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                ),
                                              ),
                                            )
                                        ),
                                        TableCell(
                                            child: Container(
                                              color: Colors.teal,
                                              child: Center(
                                                child: Text('U/out',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                ),
                                              ),
                                            )
                                        ),
                                        TableCell(
                                            child: Container(
                                              color: Colors.teal,
                                              child: Center(
                                                child: Text('Time',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                ),
                                              ),
                                            )
                                        ),
                                      ]
                                  ),
                                  for(var i=0; i<storedocs.length;  i++) ...[
                                    TableRow(
                                        children: [
                                          TableCell(
                                              child: Container(
                                                color: Colors.white,
                                                child: Center(
                                                  child: Text(storedocs[i]['RBS'],style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                  ),
                                                ),
                                              )
                                          ),
                                          TableCell(
                                              child: Container(
                                                color: Colors.white,
                                                child: Center(
                                                  child: Text(storedocs[i]['Serum Ketone'],style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                  ),
                                                ),
                                              )
                                          ),
                                          TableCell(
                                              child: Container(
                                                color: Colors.white,
                                                child: Center(
                                                  child: Text(storedocs[i]['PH'],style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                  ),

                                                ),
                                              )
                                          ),
                                          TableCell(
                                              child: Container(
                                                color: Colors.white,
                                                child: Center(
                                                  child: Text(storedocs[i]['Na+'],style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                  ),
                                                ),
                                              )
                                          ),
                                          TableCell(
                                              child: Container(
                                                color: Colors.white,
                                                child: Center(
                                                  child: Text(storedocs[i]['K+'],style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                  ),
                                                ),
                                              )
                                          ),
                                          TableCell(
                                              child: Container(
                                                color: Colors.white,
                                                child: Center(
                                                  child: Text(storedocs[i]['Cl-'],style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                  ),
                                                ),
                                              )
                                          ),
                                          TableCell(
                                              child: Container(
                                                color: Colors.white,
                                                child: Center(
                                                  child: Text(storedocs[i]['PCO2'],style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                  ),
                                                ),
                                              )
                                          ),
                                          TableCell(
                                              child: Container(
                                                color: Colors.white,
                                                child: Center(
                                                  child: Text(storedocs[i]['HCO3'],style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                  ),
                                                ),
                                              )
                                          ),
                                          TableCell(
                                              child: Container(
                                                color: Colors.white,
                                                child: Center(
                                                  child: Text(storedocs[i]['Urine Output'],style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                  ),
                                                ),
                                              )
                                          ),
                                          TableCell(
                                              child: Container(
                                                color: Colors.white,
                                                child: Center(
                                                  child: Text(storedocs[i]['Time'],style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold,),
                                                  ),
                                                ),
                                              )
                                          ),
                                        ]
                                    ),
                                  ]
                                ],
                              ),
                            )
                          ],
                        )
                      ]

                  )
              ),
            );


          }

      ),
    )]
    );
  }

}

