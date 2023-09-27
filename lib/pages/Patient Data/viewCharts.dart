import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChartData {
  ChartData(this.x, this.ph,this.potassium,this.rbs,this.chlorine,this.sodium,this.HCO3,this.CO2,this.urineOutput);
  final DateTime x;
  final double ph;
  final double potassium;
  final double rbs;
  final double chlorine;
  final double sodium;
  final double HCO3;
  final double CO2;
  final double urineOutput;
}

// class ChartData_RBS{
//   ChartData_RBS(this.x,this.rbs,this.urineOut);
//   final  DateTime x;
//   final double rbs;
//   final double urineOut;
//}


class viewGraphs extends StatelessWidget {
  String regNo;
  viewGraphs({required this.regNo});

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
       backgroundColor: Colors.white.withOpacity(.8),
        appBar: AppBar(
          title: Text("Graphs"),

        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('investigations').where('PatientId', isEqualTo: regNo).snapshots(),
            builder: (BuildContext context,AsyncSnapshot <QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something Went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              //final List<ChartData_RBS> chartData_RBS=[];
              final List<ChartData> chartData = [];

              snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> eachInv = document.data() as Map<String, dynamic>;

                String date_=eachInv['Time'];
                DateTime date=DateTime.parse(date_);
                double pH=double.parse(eachInv['PH']);
                double rbS=double.parse(eachInv['RBS']);
                double potassium = double.parse(eachInv['K+']);
                double cO2= double.parse(eachInv['PCO2']);
                double hCO3= double.parse(eachInv['HCO3']);
                double sodium= double.parse(eachInv['Na+']);
                double chlorine=double.parse(eachInv['Cl-']);
                double urineOutput=double.parse(eachInv['Urine Output']);

                chartData.add(ChartData(date, pH,potassium,rbS,cO2,hCO3,sodium,chlorine,urineOutput));
                //chartData_RBS.add(ChartData_RBS(date, rbS, urineOutput));

              }).toList();

              return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    // height: MediaQuery.of(context).size.height,
                    // width: MediaQuery.of(context).size.width,
                    // decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //         image: AssetImage("images/3.png"),
                    //         fit: BoxFit.cover,
                    //         opacity: 450
                    //     )
                    // ),
                    child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Container(
                            height: 150,
                            child: Image(
                              image: AssetImage("images/details.png"),
                            ),
                          ),
                          SizedBox(height: 10,),

                          Divider(
                            color: Color(0xFF555FD2),
                            indent: 50,
                            endIndent: 50,
                          ),
                          //for(var i=0; i<chartData.length;  i++) ...[
                          Column(
                            children: [
                              Container(
                                child: Text("Graph ",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                              )
                            ],
                          ),

                          Column(
                            children: [
                              Container(
                                color: Colors.white.withOpacity(.8),
                                child: SfCartesianChart(
                                  //backgroundColor: Colors.white.withOpacity(.8),
                                  primaryXAxis: DateTimeAxis(),

                                    legend: Legend(

                                    isVisible: true,
                                    overflowMode: LegendItemOverflowMode.wrap
                                  ),
                                    series: <CartesianSeries<ChartData, DateTime>>[
                                    LineSeries<ChartData, DateTime>(
                                      name: 'PH',
                                    dataSource: chartData,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.ph
                                ),

                                    LineSeries<ChartData, DateTime>(
                                        name: 'K+',
                                        dataSource: chartData,
                                        xValueMapper: (ChartData data, _) => data.x,
                                        yValueMapper: (ChartData data, _) => data.potassium
                                    ),
                                    LineSeries<ChartData, DateTime>(
                                        name: 'CL-',
                                        dataSource: chartData,
                                        xValueMapper: (ChartData data, _) => data.x,
                                        yValueMapper: (ChartData data, _) => data.chlorine
                                    ),
                                    LineSeries<ChartData, DateTime>(
                                        name: 'PCO2',
                                        dataSource: chartData,
                                        xValueMapper: (ChartData data, _) => data.x,
                                        yValueMapper: (ChartData data, _) => data.CO2
                                    ),
                                    LineSeries<ChartData, DateTime>(
                                        name: 'HCO3',
                                        dataSource: chartData,
                                        xValueMapper: (ChartData data, _) => data.x,
                                        yValueMapper: (ChartData data, _) => data.HCO3
                                    ),
                                    LineSeries<ChartData, DateTime>(
                                        name: 'Na+',
                                        dataSource: chartData,
                                        xValueMapper: (ChartData data, _) => data.x,
                                        yValueMapper: (ChartData data, _) => data.sodium
                                    ),
                                    LineSeries<ChartData, DateTime>(
                                        name: 'RBS',
                                        dataSource: chartData,
                                        xValueMapper: (ChartData data, _) => data.x,
                                        yValueMapper: (ChartData data, _) => data.rbs
                                    ),
                                    LineSeries<ChartData, DateTime>(
                                        name: 'U/output',
                                        dataSource: chartData,
                                        xValueMapper: (ChartData data, _) => data.x,
                                        yValueMapper: (ChartData data, _) => data.urineOutput
                                    ),

                          ]
                          )
                              )
                            ],

                          ),

                        ]

                   // ]
                    ),
                  )
              );
            }
        )

    )]
    );
  }
}
