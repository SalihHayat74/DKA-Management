import 'package:management_of_dka_abgs/pages/Patient%20Data/HomePage.dart';
import 'package:management_of_dka_abgs/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Login_Screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool loading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REGISTER"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/3.png"),
                  fit: BoxFit.cover,
                  opacity: 400
              )),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle,
                color: Colors.blue,
                size: 150,
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
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

                TextField(
                  obscureText: true,
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 25,),

                loading ? CircularProgressIndicator(): Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState((){
                        loading = true;
                      });
                      if (emailController.text == "" || passwordController.text == "" || nameController=="") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("All fields are required"),
                          backgroundColor: Colors.red,));
                      } else if (passwordController.text !=
                          confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Password does not match"),
                          backgroundColor: Colors.red,));
                      } else {
                        User? result = await AuthService().registerUser(
                            nameController.text,emailController.text, passwordController.text,
                            context);
                        if (result != null) {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage(result)), (route) => false);
                          // Navigator.push(
                          //     context, MaterialPageRoute(builder: (context) {
                          //   return HomePage();
                          // }));
                          print(result.email);
                        }
                        }
                      setState((){
                        loading = false;
                      });

                      },
                      child: Text("Submit",style: TextStyle(
                      fontSize: 25,fontWeight: FontWeight.bold
                      )
                      )
                    ),
                ),

                SizedBox(height: 10,),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen(),),);
                }, child: Text("Already have an account? Login here"))
              ],
            ),
          ),
        ),
      ),
    );
        }
}