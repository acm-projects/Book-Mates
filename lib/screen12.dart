import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: signup()) 
    );
}
class Home extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        backgroundColor:Colors.green[700],
        title: Text("BOOKMATES", style:TextStyle(fontSize:40.0, fontWeight: FontWeight.bold, color: Colors.white70)),
        centerTitle: true,
        toolbarHeight: 200,
        elevation: 25,
      ),
      body: Center(
        
        child:Text.rich(
        
        TextSpan(
          
          text:"Welcome Back!\n\n\n",
          style:TextStyle(fontSize:25, color:Colors.black87),
          children: [TextSpan(
            
            text:"Login\n\n",
            style:TextStyle(fontSize:20,),
            children: [TextSpan(
              text: "Email\n\n____________________________________________\n\nPassword\n\n____________________________________________",
               
            )]
        )]
         

        
        ),
        
           
        
      )),
          
      /*bottomSheet: Center(
        child:TextButton(
          onPressed: () {},
          child: Text("Login"),
        ),
      ),*/
  );
  }
}
class signup extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        backgroundColor:Colors.green[700],
        title: Text("BOOKMATES", style:TextStyle(fontSize:40.0, fontWeight: FontWeight.bold, color: Colors.white70)),
        centerTitle: true,
        toolbarHeight: 200,
        elevation: 25,
      ),
      body: Center(
        
        child:Text.rich(
        
        TextSpan(
          
          text:"Create an account!\n\n\n",
          style:TextStyle(fontSize:25, color:Colors.black87),
          children: [TextSpan(
            
            text:"First Name\n\n",
            style:TextStyle(fontSize:20,),
            children: [TextSpan(
              text: "Email\n\n________________________________________\n\Last Name\n\n_________________________________________\n\Email\n\n_________________________________________\n\Password\n__________________________________________",
               
            )]
        )]
           

        
        ),
        
           
        
      )),
        
      
      /*bottomSheet: Center(
        child:TextButton(
          onPressed: () {},
          child: Text("Login"),
        ),
      ),*/
  );
  }
}

class createGroup extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        backgroundColor:Colors.green[700],
        title: Text("Create Your Group", style:TextStyle(fontSize:40.0, fontWeight: FontWeight.bold, color: Colors.white70)),
        centerTitle: true,
        toolbarHeight: 200,
        elevation: 25,
      ),
      body: Center(
        
        child:Text.rich(
        
        TextSpan(
            
            text:"Group Name\n\n",
            style:TextStyle(fontSize:20,),
            children: [TextSpan(
              text: "________________________________________\n\Book Name\n\n_________________________________________\n\Add a group profile pic",
               
            )]
        )
           

        
        ,
        
           
        
      )),
        
      
      /*bottomSheet: Center(
        child:TextButton(
          onPressed: () {},
          child: Text("Login"),
        ),
      ),*/
  );
  }

}
