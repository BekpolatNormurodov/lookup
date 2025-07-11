import 'package:lookup/library.dart';
import 'package:http/http.dart' as http;

class UserDataService {
  Future<List<UserDataModel>> userDataService(id) async {
    try {
      var url = Uri.parse('https://f9282873ed82.ngrok-free.app/search/?id=$id');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List json = jsonDecode(response.body);
        List<UserDataModel> data =
            json.map((e) => UserDataModel.fromJson(e)).toList();
        return data;
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return [];
    }
  }
}