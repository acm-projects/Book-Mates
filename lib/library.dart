import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: Library()) 
    );
}


class Library extends StatelessWidget
{
  const Library({super.key});

  @override
  Widget build(BuildContext context)
  {
  return Scaffold(
    appBar:AppBar(title: const Text("Your Library"), centerTitle:true,backgroundColor: Colors.red[200] ),
    body: Column(
      children: [
      
      TextFormField(decoration: const InputDecoration(
              border:OutlineInputBorder(),
              hintText:'Search for a book..',
            ))
      
    ]),
  );
  }
}