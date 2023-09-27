//import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:management_of_dka_abgs/pages/viewCharts.dart';
import 'package:intl/intl.dart';


class ManagmentData{
  ManagmentData(
      this.time,
      this.rbs,
      this.ph,
      this.potassium,
      this.chlorine,
      this.sodium,
      this.HCO3,
      this.CO2,
      this.urineOutput,
      this.formated_hour,
      this.formated_minutes);

  final String time;
  final double ph;
  final double rbs;
  final double potassium;
  final double chlorine;
  final double sodium;
  final double HCO3;
  final double CO2;
  final double urineOutput;
  final int formated_hour;
  final  int formated_minutes;
  //ManagmentList();
}

class ManagmentTable extends StatelessWidget {
  String regNo;
  String weight;

  ManagmentTable({
    required this.regNo,
    required this.weight,

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
    fit: BoxFit.cover)
    ),
    ),
    Scaffold(
      backgroundColor: Colors.white.withOpacity(.8),
      appBar: AppBar(
        title: Text("Treatment Table"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('investigations').where('PatientId', isEqualTo: regNo).orderBy('Time', descending: false).snapshots(),
    builder: (BuildContext context,AsyncSnapshot <QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something Went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final List<ManagmentData> treatmentList = [];

        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> eachInv = document.data() as Map<String, dynamic>;

          String date_ = eachInv['Time'];
          DateTime date = DateTime.parse(date_);
          String formatted_hour = DateFormat('HH').format(date);
          String formatted_minutes = DateFormat('mm').format(date);

          int time_hour =  int.parse(formatted_hour);
          int time_minute =  int.parse(formatted_minutes);

          String regNo = eachInv['PatientId'];
          double ph = double.parse(eachInv['PH']);
          double rbs = double.parse(eachInv['RBS']);
          double potassium = double.parse(eachInv['K+']);
          double cO2 = double.parse(eachInv['PCO2']);
          double hCO3 = double.parse(eachInv['HCO3']);
          double sodium = double.parse(eachInv['Na+']);
          double chlorine = double.parse(eachInv['Cl-']);
          double urineOutput = double.parse(eachInv['Urine Output']);

          treatmentList.add(ManagmentData(
              date_,
              rbs,
              ph,
              potassium,
              chlorine,
              sodium,
              hCO3,
              cO2,
              urineOutput,
              time_hour,
              time_minute

          ));
        }).toList();
        for(int i=0 ; i<treatmentList.length; i++){

            ManagmentData data = treatmentList[i];
            int k = i + 1;
            double weight_double = double.parse(weight);
            double infusion_rate = 9*weight_double;
            double insulin_regular_bolus = 0.15 * weight_double;
            double insulin_infusion = 0.1 * weight_double;
            double insulin_infusion_double =0.11 * weight_double;
            double insulin_regular_bolus_double =0.16 * weight_double;
            double insulin_regular_half = 0.125 * weight_double;
            double insulin_infusion_half = 0.09 * weight_double;
            double anionGap =data.sodium + data.potassium -data.chlorine -data.HCO3;
/****************************************************************************************************************
    When initial investigations are entered.
    The following If condition will execute as at initial time the value of i=0.
    And treatmentList length is = 1 because there is only one entry in the investigations.
    K is intentionally 1 more than i.
    So if i = 0 than K will be K = 1,
*****************************************************************************************************************/
          if(i==0 && k==treatmentList.length){
/*********** Here we are checking for value of potassium **********/
            if(data.potassium < 3.3 && data.rbs > 250){
              return Container(
                alignment: Alignment.topCenter,
                color: Colors.transparent,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      /**Container For Anion Gap **/
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Anion Gap = ${anionGap}',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 10,),
                      /**! Container for Poassium !**/
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Entry number = ${i}\n\nWarning!!!\nK+ is ${data.potassium} which is less than 3.3.\nFirst correct K+, do not Give Insulin.\nGive 40mEq K+ per hour(2/3 KCL and 1/3 KPO4)',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      /********************************************************************
                                            PH Management
                       *******************************************************************/
                      SizedBox(height: 10,),
                      if(data.ph<6.9)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph} which is less than 6.9.\nGive NaHCO3(100 mmol), dilute in 400ml water.\ninfusion rate = 200ml/hour.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.ph >= 6.9 && data.ph <= 7)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph}\nGive NaHCO3(50 mmol), dilute in 200ml water.\ninfusion rate = 200ml/hour.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.ph>7)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph}\nNo HCO3 required.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ],
                      /********************************************************************
                                            Sodium/Fluid Management
                       *******************************************************************/
                      SizedBox(height: 10,),
                      if(data.sodium > 135)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Fluid Management\n\nNa+ = ${data.sodium}\nGive 0.45% NaCl.\nInfusion rate = ${infusion_rate}/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.sodium<135)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Fluid Management\n\nNa+ = ${data.sodium} which is less than normal.\nGive 0.9% NaCl.\nInfusion rate = ${infusion_rate}ml/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ],
                      SizedBox(height: 10,),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Investigation Entry # ${i}\nInvestigation Entry time ${data.time}',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                ),
              );
            }else if(data.potassium >= 5 && data.rbs > 250){
              return Container(
                alignment: Alignment.topCenter,
                color: Colors.transparent,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Investigation Entry # ${i}\nInvestigation Entry time ${data.time}',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Anion Gap = ${anionGap}',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Potassium Management\n\nWarning!!!\nK+ is ${data.potassium}, which is high.\nDo not give K+.',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Insulin Management\n\nGive insulin regular bolus ${insulin_regular_bolus}/hour or insulin IV infuison ${insulin_infusion}/hour',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 10,),
                      if(data.ph<6.9)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph} which is less than 6.9.\nGive NaHCO3(100 mmol), dilute in 400ml water.\ninfusion rate = 200ml/hour.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.ph >= 6.9 && data.ph <= 7)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph}\nGive NaHCO3(50 mmol), dilute in 200ml water.\ninfusion rate = 200ml/hour.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.ph>7)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph}\nNo HCO3 required.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ],
                      if(data.sodium > 135)...[
                        Container(
                          width:300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Fluid Management\n\nNa+ = ${data.sodium}\nGive 0.45% NaCl.\nInfusion rate = ${infusion_rate}/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.sodium<135)...[
                        Container(
                          width:300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Fluid Management\n\nNa+ = ${data.sodium} which is less than normal.\nGive 0.9% NaCl.\nInfusion rate = ${infusion_rate}ml/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ],

                    ],
                  ),
                ),
              );
            }else if(data.potassium >= 3.3 && data.potassium < 5 && data.rbs > 250){
              return Container(
                alignment: Alignment.topCenter,
                color: Colors.white.withOpacity(.8),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Investigation Entry # ${i}\nInvestigation Entry time ${data.time}',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Anion Gap = ${anionGap}',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: 300,
                        color: Colors.red,
                        alignment: Alignment.center,
                        child: Text('Potassium Management\n\n\nK+ is ${data.potassium}\nGive 20-30 mEq/L K+ per hour(2/3 KCL and 1/3 KPO4) to Keep K+ at 4-5 mEq/L',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width:300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Insulin Management\n\nGive insulin regular bolus ${insulin_regular_bolus}/hour or insulin IV infuison ${insulin_infusion}/hour',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 10,),
                      if(data.ph<6.9)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph} which is less than 6.9.\nGive NaHCO3(100 mmol), dilute in 400ml water.\ninfusion rate = 200ml/hour.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.ph >= 6.9 && data.ph <= 7)...[
                        Container(
                          width:300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph}\nGive NaHCO3(50 mmol), dilute in 200ml water.\ninfusion rate = 200ml/hour.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.ph>7)...[
                        Container(
                          width:300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph}\nNo HCO3 required.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ],
                      if(data.sodium > 135)...[
                        Container(
                          width:300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Fluid Management\n\nNa+ = ${data.sodium}\nGive 0.45% NaCl.\nInfusion rate = ${infusion_rate}/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.sodium<135)...[
                        Container(
                          width:300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Sodium Management\n\nNa+ = ${data.sodium} which is less than normal.\nGive 0.9% NaCl.\nInfusion rate = ${infusion_rate}ml/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ],

                    ],
                  ),
                ),
              );
            }
/************************************************************************************************************************
    The following If condition will execute when i >= 1.
    And treatmentList length is >= 2 because there is more 2 or more entries in the investigations.

    Why this if condition is added:
      We need RBS difference.
      We need urine output difference.
      We need PH difference.
*************************************************************************************************************************/
          }else if(i>0 && k==treatmentList.length){
            /**! This is the previous object variable for finding difference !**/
            ManagmentData data_previous=treatmentList[i-1];

            double rbs_difference = (data.rbs - data_previous.rbs).abs();

            double urineOutput = data.urineOutput - data_previous.urineOutput;



            //Potassium Management
            if(data.potassium < 3.3 && data.rbs > 250){

              return Container(
                alignment: Alignment.topCenter,
                color: Colors.transparent,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Container(
                        width:300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Anion Gap = ${anionGap}',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Entry number = ${i}\n\nWarning!!!\nK+ is ${data.potassium} which is less than 3.3.\nFirst correct K+, do not Give Insulin.\nGive 40mEq K+ per hour(2/3 KCL and 1/3 KPO4)',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 10,),
                      if(data.ph<6.9)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph} which is less than 6.9.\nGive NaHCO3(100 mmol), dilute in 400ml water.\ninfusion rate = 200ml/hour.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.ph >= 6.9 && data.ph <= 7)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph}\nGive NaHCO3(50 mmol), dilute in 200ml water.\ninfusion rate = 200ml/hour.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.ph>7)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph}\nNo HCO3 required.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ],
                      if(i < 5)...[
                        if(data.rbs > 250)...[
                        SizedBox(height: 20,),
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Fluid Replacement\n\nGive NS 500-1000 ml/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.rbs <= 250)...[
                          SizedBox(height: 20,),
                          Container(
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.8),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text('Fluid Replacement\n\nGive D5 and NS 250-500ml/hour',
                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                          ),
                        ],
                      ]else if(i >= 5)...[
                        SizedBox(height: 20,),
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Fluid Replacement\n\nGive NS 250-500 ml/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ],
                      if(data.sodium > 135)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Fluid Management\n\nNa+ = ${data.sodium}\nGive 0.45% NaCl.\nInfusion rate = ${infusion_rate}/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.sodium<135)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Sodium Management\n\nNa+ = ${data.sodium} which is less than normal.\nGive 0.9% NaCl.\nInfusion rate = ${infusion_rate}ml/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ],
                      SizedBox(height: 10,),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Investigation Entry # ${i}\nInvestigation Entry time ${data.time}',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                ),
              );
            }else if(data.potassium >= 5 && data.rbs > 250){
              return Container(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Investigation Entry # ${i+1}\nInvestigation Entry time ${data.time}',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Anion Gap = ${anionGap}',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Potassium Management\n\nWarning!!!\nK+ is ${data.potassium}, which is high.\nDo not give K+.',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      if(rbs_difference< 75)...[
                        SizedBox(height: 20,),
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Insulin Management\n\nRBS is ${data.rbs} and Previous RBS is ${data_previous.rbs} Difference is ${rbs_difference}.\nGive insulin regular bolus ${insulin_regular_bolus_double}/hour or insulin IV infuison ${insulin_infusion_double}/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(rbs_difference >= 75 && rbs_difference <= 100)...[
                        SizedBox(height: 20,),
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Insulin Management\n\nRBS Difference is ${rbs_difference}.\nGive insulin regular bolus ${insulin_regular_bolus}/hour or insulin IV infuison ${insulin_infusion}/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(rbs_difference > 100)...[
                        SizedBox(height: 20,),
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Insulin Management\n\nRBS Difference is ${rbs_difference}.\nGive insulin regular bolus ${insulin_regular_half}/hour or insulin IV infuison ${insulin_infusion_half}/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ],

                      SizedBox(height: 10,),
                      if(data.ph<6.9)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph} which is less than 6.9.\nGive NaHCO3(100 mmol), dilute in 400ml water.\ninfusion rate = 200ml/hour.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.ph >= 6.9 && data.ph <= 7)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph}\nGive NaHCO3(50 mmol), dilute in 200ml water.\ninfusion rate = 200ml/hour.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.ph>7)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph}\nNo HCO3 required.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ],
                      if(data.sodium > 135)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Fluid Management\n\nNa+ = ${data.sodium}\nGive 0.45% NaCl.\nInfusion rate = ${infusion_rate}/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.sodium<135)...[
                        SizedBox(height: 20,),
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Fluid Management\n\nNa+ = ${data.sodium} which is less than normal.\nGive 0.9% NaCl.\nInfusion rate = ${infusion_rate}ml/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ],

                    ],
                  ),
                ),
              );
            }else if(data.potassium >= 3.3 && data.potassium < 5 && data.rbs > 250){
              return Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(.8),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Investigation Entry # ${i}\nInvestigation Entry time ${data.time}',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Anion Gap = ${anionGap}',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Potassium Management\n\n\nK+ is ${data.potassium}\nGive 20-30 mEq/L K+ per hour(2/3 KCL and 1/3 KPO4) to Keep K+ at 4-5 mEq/L',
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                      ),
                      if(rbs_difference< 75)...[
                        SizedBox(height: 20,),
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Insulin Management\n\nRBS Difference is ${rbs_difference}.\nGive insulin regular bolus ${insulin_regular_bolus_double}/hour or insulin IV infuison ${insulin_infusion_double}/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(rbs_difference >= 75 && rbs_difference <= 100)...[
                        SizedBox(height: 20,),
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Insulin Management\n\nRBS Difference is ${rbs_difference}.\nGive insulin regular bolus ${insulin_regular_bolus}/hour or insulin IV infuison ${insulin_infusion}/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(rbs_difference > 100)...[
                        SizedBox(height: 20,),
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Insulin Management\n\nRBS Difference is ${rbs_difference}.\nGive insulin regular bolus ${insulin_regular_half}/hour or insulin IV infuison ${insulin_infusion_half}/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ],
                      SizedBox(height: 10,),
                      if(data.ph<6.9)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph} which is less than 6.9.\nGive NaHCO3(100 mmol), dilute in 400ml water.\ninfusion rate = 200ml/hour.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.ph >= 6.9 && data.ph <= 7)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph}\nGive NaHCO3(50 mmol), dilute in 200ml water.\ninfusion rate = 200ml/hour.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.ph>7)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('PH Management\n\nPH = ${data.ph}\nNo HCO3 required.',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ],
                      if(data.sodium > 135)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Fluid Management\n\nNa+ = ${data.sodium}\nGive 0.45% NaCl.\nInfusion rate = ${infusion_rate}/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ]else if(data.sodium<135)...[
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Fluid Management\n\nNa+ = ${data.sodium} which is less than normal.\nGive 0.9% NaCl.\nInfusion rate = ${infusion_rate}ml/hour',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                        ),
                      ],

                    ],
                  ),
                ),
              );
            }


          }
        }

    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.all(10),
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.7),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Text('It seems that this is not DKA because RBS is less than 250.Therefore we have no treatment for other complications.\n\nMay be it become possible to provide you other treatments as well thanks.',
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                ),
              ],
            ),
          ),

    );
    }

    ),


    )
        ]
    );
        }
  }