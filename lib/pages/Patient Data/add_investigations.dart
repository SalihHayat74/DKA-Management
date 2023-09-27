import 'package:management_of_dka_abgs/pages/treatmentPages/treatmentScreen.dart';
import 'package:flutter/material.dart';
import 'package:management_of_dka_abgs/services/classifier.dart';
import '../../services/firestore_services.dart';




class AddInvestigation extends StatefulWidget {
   String regNo;
   String weight;

  AddInvestigation({required this.regNo,required this.weight});

  @override
  State<AddInvestigation> createState() => _AddInvestigationState();
}

class _AddInvestigationState extends State<AddInvestigation> {
  TextEditingController rbs = TextEditingController();

  TextEditingController serumketone = TextEditingController();

  TextEditingController ph = TextEditingController();

  TextEditingController sodium = TextEditingController();

  TextEditingController potassium = TextEditingController();

  TextEditingController chlorine = TextEditingController();

  TextEditingController carbondioxide = TextEditingController();

  TextEditingController bicarbonate = TextEditingController();

  TextEditingController urineOutput = TextEditingController();

  bool loading =false;

  late Classifier classifier = Classifier();
  void initState() {
    super.initState();
    classifier = Classifier();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
    Container(
    decoration: const BoxDecoration(
      color: Colors.white,
    image: DecorationImage(
        image: AssetImage('images/medSigns2.jpeg'),
    opacity: 0.2,
    fit: BoxFit.cover
    )
    ),
    ),
     Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF555FD2),
        title: const Text("Add Investigations"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    // optional flex property if flex is 1 because the default flex is 1
                    flex: 1,
                    child: TextField(
                      controller: rbs,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "RBS",
                        suffixText: "mg/dl",
                        hintText: "Enter RBS",
                        filled: true,
                        fillColor: Colors.white.withOpacity(.8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.black,width: 2),
                        ),

                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    // optional flex property if flex is 1 because the default flex is 1
                    flex: 1,
                    child: TextField(
                      controller: serumketone,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Serum Ketone",
                          hintText: "Ketone",
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.black,width: 2),
                          )
                      ),

                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    // optional flex property if flex is 1 because the default flex is 1
                    flex: 1,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: ph,
                      decoration: InputDecoration(
                          labelText: "PH",
                          hintText: "Enter PH",
                          filled: true,
                          fillColor: Colors.white.withOpacity(.8),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black,width: 2),
                          )
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    // optional flex property if flex is 1 because the default flex is 1
                    flex: 1,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: sodium,
                      decoration: InputDecoration(
                          suffixText: "mmol/L",
                          labelText: "Na+",
                          hintText: "Enter Na+",
                          filled: true,
                          fillColor: Colors.white.withOpacity(.8),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.black,width: 2),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    // optional flex property if flex is 1 because the default flex is 1
                    flex: 1,
                    child: TextField(
                      controller: potassium,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "K+",
                          suffixText: "mmol/L",
                          hintText: "Enter K+",
                          filled: true,
                          fillColor: Colors.white.withOpacity(.8),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.black,width: 2),
                          )
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    // optional flex property if flex is 1 because the default flex is 1
                    flex: 1,
                    child: TextField(
                      controller: chlorine,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Cl-",
                          hintText: "Enter Cl-",
                          suffixText: "mmol/L",
                          filled: true,
                          fillColor: Colors.white.withOpacity(.8),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.black,width: 2),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    // optional flex property if flex is 1 because the default flex is 1
                    flex: 1,
                    child: TextField(
                      controller: carbondioxide,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "CO2",
                          suffixText: "mmol/L",
                          hintText: "Enter CO2",
                          filled: true,
                          fillColor: Colors.white.withOpacity(.8),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.black,width: 2),
                          )
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    // optional flex property if flex is 1 because the default flex is 1
                    flex: 1,
                    child: TextField(
                      controller: bicarbonate,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "HCO3",
                          suffixText: "mmol/L",
                          hintText: "Enter HCO3",
                          filled: true,
                          fillColor: Colors.white.withOpacity(.8),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.black,width: 2),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    // optional flex property if flex is 1 because the default flex is 1
                    flex: 1,
                    child: TextField(
                      controller: urineOutput,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Urine Output",
                          suffixText: "mL",
                          hintText: "Enter Urine Output",
                          filled: true,
                          fillColor: Colors.white.withOpacity(.8),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.black,width: 2),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Center(
                child:
                loading ? Center(child: CircularProgressIndicator(),):Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Color(0xFF555FD2),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: TextButton(
                    onPressed: ()async{

                      //if( rbs.text == "" || serumketone.text =="" || ph.text =="" || sodium.text =="" || potassium.text=="" || chlorine.text=="" || carbondioxide.text=="" || bicarbonate.text=="") {
                       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                       //     content: Text("All Fields are required!!")),);
                      //}else{
                      // double pH = double.parse(ph.text);
                      // double pCO2 = double.parse(carbondioxide.text);
                      // double hCO3 = double.parse(bicarbonate.text);
                      //
                      // final prediction = classifier.classify(pH, pCO2, hCO3);
                      // print("I am returned from classify");
                        setState(() {
                          loading = true;
                        });
                        await FirestoreService().InsertInvestigations(
                            rbs.text,
                            serumketone.text,
                            ph.text,
                            sodium.text,
                            potassium.text,
                            chlorine.text,
                            carbondioxide.text,
                            bicarbonate.text,
                            urineOutput.text,
                            //anionGap,
                            widget.regNo);

                        setState(() {
                          loading = false;
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                int sugar = int.parse(rbs.text);
                                double pH = double.parse(ph.text);
                                double pCO2 = double.parse(carbondioxide.text);
                                double hCO3 = double.parse(bicarbonate.text);
                                double ketone = double.parse(serumketone.text);
                                if(pH < 7.4 && pCO2 < 40 && hCO3 < 22){
                                  if(sugar > 250 && ketone > 0.6){
                                    return Container(
                                      child: AlertDialog(
                                        title: Container(
                                          alignment: Alignment.topCenter,
                                          child: Text("PREDICTION",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                              fontSize: 20,
                                            ),),
                                        ),
                                        content: Column(
                                          children: [
                                            Container(
                                                alignment: Alignment.topCenter,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 1,
                                                      style: BorderStyle.solid
                                                  ),
                                                  borderRadius: BorderRadius.circular(10),

                                                ),
                                                child: Text("Prediction:\nBased on the given investigations data, Acidosis is Metabolic Acidosis and it is predicted that patient has DKA. For treatment click on treatment Button.",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                  ),
                                                )
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Container(
                                            alignment: Alignment.bottomCenter,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 150,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 2
                                                    ),
                                                    borderRadius: BorderRadius.circular(50)
                                                  ),
                                                  child: TextButton(

                                                    onPressed: () {
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ManagmentTable(regNo: widget.regNo,weight: widget.weight,)));
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Icon(Icons.batch_prediction,
                                                          size: 50,
                                                          color: Colors.black,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text("View Treatment",
                                                            style: TextStyle(color: Colors.black,),
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );

                                  }
                                }else if(pH < 7.4 && pCO2 > 40 && hCO3 > 22){
                                  if(sugar > 250 && ketone > 0.6){
                                    return AlertDialog(
                                      title: Container(
                                        alignment: Alignment.topCenter,
                                        child: Text("PREDICTION",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: 20,
                                          ),),
                                      ),
                                      content: Container(
                                          alignment: Alignment.topCenter,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black,
                                                width: 1,
                                                style: BorderStyle.solid
                                            ),
                                            borderRadius: BorderRadius.circular(10),

                                          ),
                                          child: Text("Based on the given investigations data, Acidosis is Respiratory Acidosis and it is predicted that patient has DKA. For treatment click on treatment Button.",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          )
                                      ),
                                      actions: [
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 150,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 2
                                                    ),
                                                    borderRadius: BorderRadius.circular(50)
                                                ),
                                                child: TextButton(

                                                  onPressed: () {
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ManagmentTable(regNo: widget.regNo,weight: widget.weight,)));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Icon(Icons.batch_prediction,
                                                        size: 50,
                                                        color: Colors.black,
                                                      ),Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text("View Treatment",
                                                          style: TextStyle(color: Colors.black,),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],

                                    );
                                  }
                                }
                                return AlertDialog(
                                  title: Container(
                                    alignment: Alignment.topCenter,
                                    child: Text("PREDICTION",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 20,
                                      ),),
                                  ),
                                  content: Container(
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                          style: BorderStyle.solid
                                      ),
                                      borderRadius: BorderRadius.circular(10),

                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Text("Based on the given investigations data, There is no Acidosis.",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  actions: [
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 2,
                                                ),
                                                borderRadius: BorderRadius.circular(50)
                                            ),
                                            child: TextButton(

                                              onPressed: () {
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ManagmentTable(regNo: widget.regNo,weight: widget.weight,)));
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(Icons.batch_prediction,
                                                    size: 50,
                                                    color: Colors.black,
                                                  ),Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text("View Treatment",
                                                      style: TextStyle(color: Colors.black,),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],

                                );

                              }
                          );
                        });

                        //Navigator.pop(context);
                      },

                    //},
                    child: Text("Submit",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    )]
    );
  }
}
