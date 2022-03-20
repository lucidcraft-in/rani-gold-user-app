import 'package:flutter/material.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login-screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          
        ),
        
        body: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 5, left: 55, right: 55),
                      width: MediaQuery.of(context).size.width,
                      height: 130,
                      color: Theme.of(context).primaryColor,
                      child: Column(
                        children: [
                         Container(
                                
                                  padding: EdgeInsets.all(5),
                                  child: Image.asset('assets/images/logo.png',height: 42,),
                                ),
                             
                                      Text(
                                        "  Rani  ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 36,
                                            color: Colors.white,
                                            fontFamily: 'Segan'),
                                      ),
                                      Text(
                                        "Jewellery",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            fontFamily: 'Segan',
                                            color: Colors.white70),
                                      )
                                   
                                  
                              
                            
                        
                        ],
                      ),
                    )
                  ],
                ),
              ),
            
              SizedBox(
                height: 60,
              ),
              LoginForm(),
              // SizedBox(height: MediaQuery.of(context).size.height/3.7,),
              // Container(
              //   height: 50,
              //   color:  Color(0xFFccccb3).withOpacity(0.3),
              //   padding: EdgeInsets.only(top: 10, bottom: 20,left: 18 ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       // Text("Powered by Lucid Craft",style: TextStyle(color: Colors.white60,fontSize: 12),),
              //       // FlatButton(onPressed: () {}, child: Text("Sign up here",style: TextStyle(fontFamily: 'latto',color: Colors.white),))
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
