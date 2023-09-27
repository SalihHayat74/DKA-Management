import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}


class ViewGraph extends StatefulWidget {
  final String ? id;
  final String ? pH;
  final String ? Na;
  final String ? potassium;
  final String ? serumKetone;
  final String ? CO2;
  final String ? HCO3;

  ViewGraph({
    this.id,
    this.pH,
    this.Na,
    this.potassium,
    this.serumKetone,
    this.CO2,
    this.HCO3
});

  SringToInt(){
    int PH=int.parse(pH!);
    int sodium = int.parse(Na!);
    int Potassium = int.parse(potassium!);
    int serumketone= int.parse(serumKetone!);
    int Co2 = int.parse(CO2!);
    int Hco3 = int.parse(HCO3!);

  }

  @override
  State<ViewGraph> createState() => _ViewGraphState();
}

class _ViewGraphState extends State<ViewGraph> {
  @override
  Widget build(BuildContext context) {
    // final List<ChartData> chartData = [
    //   ChartData(2010, 35),
    //   ChartData(2011, 28),
    //   ChartData(2012, 34),
    //   ChartData(2013, 32),
    //   ChartData(2014, 40)
    // ];


    return Scaffold(
      appBar: AppBar(
        title: Text("Graphs"),

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('investigations').snapshots(),
        builder: (BuildContext context,AsyncSnapshot <QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something Went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<ChartData> chartData = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> eachInv = document.data() as Map<String, dynamic>;
            int ph=int.parse(eachInv[2]);
            double rbs=double.parse(eachInv[0]);

            chartData.add(ChartData(ph, rbs));
          }).toList();

          // String x=data[7];
          // int y=int.parse(data[2]);




          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/3.png"),
                      fit: BoxFit.cover,
                      opacity: 450
                  )
              ),
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
                       SfCartesianChart(
                          series: <ChartSeries>[
                            // Renders line chart
                            LineSeries<ChartData, int>(
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y
                            )
                          ]
                      )
                    ],

                  )
              ]

              ),
          )
        );
      }
    )

    );
  }
}
