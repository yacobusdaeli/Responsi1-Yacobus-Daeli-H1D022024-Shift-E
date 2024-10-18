import 'package:flutter/material.dart';
import 'package:responsipm/helpers/user_info.dart';
import 'package:responsipm/ui/login_page.dart';
import 'package:responsipm/ui/penerbit_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    var token = await UserInfo().getToken();
    if (token != null) {
      setState(() {
        page = const PenerbitPage(); // Ubah dari ProdukPage ke PenerbitPage
      });
    } else {
      setState(() {
        page = const LoginPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penerbit',
      debugShowCheckedModeBanner: false,
      home: page,
    );
  }
}
