import 'package:flutter/material.dart';
import 'package:helper/screens/home_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  final String name = '5cs';
  final String pwd = 'myeiksagar';

  @override
  Widget build(BuildContext context) {
    String enteredName = '';
    String enteredPwd = '';
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(189, 159, 199, 1),
              Color.fromRGBO(44, 62, 80, 1)
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_open_outlined,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  // Name Input Field
                  TextFormField(
                    onChanged: (value) {
                      enteredName = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Password Input Field
                  TextFormField(
                    onChanged: (value) {
                      enteredPwd = value;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Login Button
                  ElevatedButton(
                      onPressed: () {
                        if (name == enteredName && pwd == enteredPwd) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage()),
                          );
                        } else {
                          // Show an error message or handle incorrect credentials
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  'Error',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                content:
                                    const Text('Invalid username or password.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      )),
                  const SizedBox(height: 20),
                  const Text(
                    'Developed by: hzys',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontStyle: FontStyle.italic),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
