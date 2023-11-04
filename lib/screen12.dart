import 'package:flutter/material.dart';

void main() {
  runApp( MaterialApp(home: LogIn()) 
    );
}
class LogIn extends StatelessWidget {
   LogIn({super.key});
  void call_Signup()
  {
     Register();
  }
  

  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    //button();
    return Scaffold(
      backgroundColor:  Color.fromARGB(255,117, 161, 15),
      
      
      
      
      
      body: SingleChildScrollView(

        child :
      Stack(
          children : [
          
        Column(
          children:[
            SizedBox(height: 60,width:410),
           
          Image(image:AssetImage('lib/icons/Title.png'),alignment:Alignment.topCenter)]
        ),
        Container(
          padding: EdgeInsets.all(40),
            margin:  EdgeInsets.only(top:150),
            width:415,
            height:900,
            decoration: BoxDecoration(
              color:Color.fromARGB(255,250, 241, 213),
              borderRadius: BorderRadius.only(topRight: Radius.circular(40.0),topLeft: Radius.circular(40.0)),
    
              
            ),
           
             
            child:
            Stack(
            
            children : [
            Column(
              
              children: [
            
            
             Text("Welcome Back!\n\n",
              textAlign: TextAlign.left,
              style:TextStyle(color: Colors.black, fontSize: 30,fontWeight: FontWeight.bold, fontFamily: 'Spartan')),
            TextFormField(
            decoration:  InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Email\n\n\n\n',
            ),),
             Text("\n\n\n",
              textAlign: TextAlign.left),
            TextFormField(
            decoration:  InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Password\n\n\n\n',
            ),
            ),
            
             SizedBox(height:150),
                ElevatedButton(onPressed: (){},style:ElevatedButton.styleFrom( fixedSize: const Size(240, 50),backgroundColor: Color.fromARGB(255,117, 161, 15),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),), child: const Text("Log In")),
              
               SizedBox(height:20),
             Text("\nDon't have an account?\n",
            style:TextStyle(fontSize: 15, fontFamily: 'Spartan'),
              textAlign: TextAlign.center),

               InkWell(child: Text('Sign Up', style:TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontFamily:'Spartan')), onTap:() {
                 Navigator.push(context, MaterialPageRoute(builder: (context) {return Register();}));
               },),
              

              
        ])])
      ),

   
            
            

            
    ])));     
  
            
  }

    
 
}

void callLogIn()
{
  LogIn();
}

class Register extends StatelessWidget {
  const Register({super.key});

  

  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    //button();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255,117, 161, 15),
      
      
      
      
      
      body: SingleChildScrollView(

        child :
      Stack(
          children : [
          
        Column(
          children:[
           const SizedBox(height: 60,width:410),
           
          Image(image:AssetImage('lib/icons/Title.png'),alignment:Alignment.topCenter)]
        ),
        Container(
          padding: EdgeInsets.all(40),
            margin:  EdgeInsets.only(top:150),
            width:415,
            height:900,
            decoration: BoxDecoration(
              color:Color.fromARGB(255,250, 241, 213),
              borderRadius: BorderRadius.only(topRight: Radius.circular(40.0),topLeft: Radius.circular(40.0)),
    
              
            ),
           
             
            child:
            Stack(
            
            children : [
            Column(
              
              children: [
            
            
             Text("Create an Account\n\n",
              textAlign: TextAlign.left,
              style:TextStyle(color: Colors.black, fontSize: 31,fontWeight: FontWeight.bold, fontFamily: 'Spartan')),
            TextFormField(
            decoration:  InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'First Name\n',
            ),),
             Text("\n",
              textAlign: TextAlign.left),
            TextFormField(
            decoration:  InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Last Name\n',
            ),
            ),
            Text("\n",
              textAlign: TextAlign.left),
            TextFormField(
            decoration:  InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Email\n',
            ),
            ),
            Text("\n",
              textAlign: TextAlign.left),
            TextFormField(
            decoration:  InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Password',
            ),
            ),
            
             SizedBox(height:80),
                ElevatedButton(onPressed: (){},style:ElevatedButton.styleFrom( fixedSize:  Size(240, 50),backgroundColor: Color.fromARGB(255,117, 161, 15),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),), child:  Text("Sign Up")),
              
               SizedBox(height:20),
             Text("\nAlready have an account?\n",
            style:TextStyle(fontSize: 15, fontFamily: 'Spartan'),
              textAlign: TextAlign.center),
               InkWell(child: Text('Log In', style:TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontFamily:'Spartan')),onTap:() {
                 Navigator.push(context, MaterialPageRoute(builder: (context) {return LogIn();}));
   } )
              

              
        ])])
      ),


            
            

            
    ])));     
      
            
  }

  
}



