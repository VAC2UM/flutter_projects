import 'package:get_it/get_it.dart';
import '../data/data_source.dart';

final GetIt locator = GetIt.instance;

class AppStateService {
  String currentUser = '';

  void setCurrentUser(String user) {
    currentUser = user;
  }

  void logout() {
    currentUser = '';
  }

  bool get isAuthenticated => currentUser.isNotEmpty;
}

void setupLocator() {
  locator.registerSingleton<AppData>(AppData.initial());
  locator.registerSingleton<AppStateService>(AppStateService());
}