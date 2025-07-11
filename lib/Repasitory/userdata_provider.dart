import 'package:lookup/library.dart';

enum UserDataState { intial, waiting, success, error }

class UserDataProvider extends ChangeNotifier {
  UserDataState state = UserDataState.intial;
  set(UserDataState value) {
    state = value;
    notifyListeners();
  }

  List<UserDataModel> data = [];

  Future getData(id) async {
    set(UserDataState.waiting);
    try {
      data = await UserDataService().userDataService(id);
      set(UserDataState.success);
    } catch (e) {
      set(UserDataState.error);
    }
  }
}