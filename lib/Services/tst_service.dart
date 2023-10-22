import 'package:bookmates_app/Services/tst_model.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  Future<List<TST>?> getTST() async {
    // we are getting a list of TST type
    var client = http.Client();

    var url = Uri.parse(
        'https://jsonplaceholder.typicode.com/posts'); // the internet fetch is the url containing the json data

    var responseData = await client.get(url);

    if (responseData.statusCode == 200) {
      //if sucessful
      var json = responseData.body;

      return tstFromJson(json); // returning a list of this json data
    }
    return null;
  }
}
