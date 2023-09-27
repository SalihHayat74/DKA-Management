import 'package:management_of_dka_abgs/pages/Authentication%20Pages/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:management_of_dka_abgs/pages/Patient%20Data/HomePage.dart';
import 'package:management_of_dka_abgs/services/auth_services.dart';

class LoginScreen extends StatefulWidget{

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),

      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/12.jpg"),
                  fit: BoxFit.cover,
                  opacity: 490
              )),
          child: Padding(padding: EdgeInsets.all(20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image(
                  image: AssetImage("images/logoo.png"),
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 25,),

              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 25,),

              loading? CircularProgressIndicator() : Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: ()async{
                    setState((){
                      loading = true;
                    });
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(),),);
                    if(emailController.text=="" || passwordController.text==""){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"),backgroundColor: Colors.red,));
                    }else{
                      User? result = await AuthService().login(emailController.text, passwordController.text, context);
                      if(result != null){
                        print(result.email);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage(result)), (route) => false);
                        }
                        };

                    setState((){
                      loading = false;
                    });
                  },

                  child: Text("Submit",style: TextStyle(
                      fontSize: 25,fontWeight: FontWeight.bold
                  ),),
                ),
              ),
              SizedBox(height: 10,),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen(),),);
              }, child: Text("Not Registered? Register here"))
            ],
          ),
          ),
        ),
      ),
    );
  }
}