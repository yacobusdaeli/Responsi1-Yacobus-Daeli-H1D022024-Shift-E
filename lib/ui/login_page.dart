import 'package:flutter/material.dart';
import 'package:responsipm/bloc/login_bloc.dart';
import 'package:responsipm/helpers/user_info.dart';
import 'package:responsipm/ui/penerbit_page.dart';
import 'package:responsipm/ui/registrasi_page.dart';
import 'package:responsipm/widget/success_dialog.dart';
import 'package:responsipm/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildAppBar(),
                  const SizedBox(height: 50),
                  _buildLoginForm(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4A90E2), // Biru
            Color(0xFF9013FE), // Ungu
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Column(
      children: const [
        Text(
          'Login',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Courier New',
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _emailTextField(),
          const SizedBox(height: 20),
          _passwordTextField(),
          const SizedBox(height: 40),
          _buttonLogin(),
          const SizedBox(height: 20),
          _menuRegistrasi(),
        ],
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      controller: _emailTextboxController,
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.email, color: Colors.white),
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white, fontFamily: 'Courier New'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      controller: _passwordTextboxController,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.lock, color: Colors.white),
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      obscureText: true,
      style: const TextStyle(color: Colors.white, fontFamily: 'Courier New'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Password harus diisi';
        }
        return null;
      },
    );
  }

  Widget _buttonLogin() {
    return _isLoading
        ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  horizontal: 80, vertical: 15), // Sesuaikan padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.black54,
            ),
            child: const Text(
              "Login",
              style: TextStyle(
                  fontSize: 18, color: Colors.white, fontFamily: 'Courier New'),
            ),
            onPressed: () {
              var validate = _formKey.currentState!.validate();
              if (validate && !_isLoading) _submit();
            },
          );
  }

  void _submit() {
    setState(() {
      _isLoading = true;
    });

    LoginBloc.login(
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then((value) async {
      if (value.code == 200) {
        await UserInfo().setToken(value.token.toString());
        await UserInfo().setUserID(int.parse(value.userID.toString()));

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
            description: "Anda berhasil login.",
            okClick: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PenerbitPage()),
              );
            },
          ),
        );
      } else {
        _showWarningDialog("Login gagal, silahkan coba lagi");
      }
    }).catchError((error) {
      _showWarningDialog("Login gagal, silahkan coba lagi");
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget _menuRegistrasi() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
              horizontal: 60,
              vertical: 15), // Sesuaikan padding untuk tombol registrasi
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.black54,
        ),
        child: const Text(
          "Registrasi",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontFamily: 'Courier New',
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
      ),
    );
  }

  void _showWarningDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WarningDialog(description: message),
    );
  }
}
