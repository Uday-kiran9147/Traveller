import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // runApp(MyApp());

  SharedPreferences sf = await SharedPreferences.getInstance();
  var n = "udaykiran";
  var name = sf.setString("username", n);
  if (await name) {
    print(n);
  }
  else{
    print("not saved");
  }
}