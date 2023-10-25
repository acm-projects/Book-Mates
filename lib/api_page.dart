import 'package:bookmates_app/API/tst_model.dart';
import 'package:bookmates_app/API/tst_service.dart';
import 'package:flutter/material.dart';

class APIPage extends StatefulWidget {
  const APIPage({super.key});

  @override
  State<APIPage> createState() => _APIPageState();
}

class _APIPageState extends State<APIPage> {
  List<TST>? TSTS; // we are displaying a list of api's data

  bool isLoading = false; // use for loading skeletons

  @override
  void initState() {
    // load the data when the page is initialized
    super.initState();

    //fetch data from api
    getData();
  }

  getData() async {
    TSTS = await RemoteService().getTST(); // will give me a list of TST data

    if (TSTS != null) {
      setState(() {
        isLoading = true; // all the data has been loaded, update the flags
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API PAGE'),
      ),
      body: Visibility(
        visible: isLoading, // if loaded, show the data
        replacement: const CircularProgressIndicator(),
        child: ListView.builder(
            itemCount:
                TSTS?.length, // amount of things that'll be shown on the page
            itemBuilder: (context, index) {
              return Text(TSTS![index].title as String);
            }),
      ),
    );
  }
}
